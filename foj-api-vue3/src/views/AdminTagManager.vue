<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <div>
        <h1 class="text-2xl font-bold">标签管理</h1>
        <p class="text-muted-foreground mt-1">按分类维护题目标签</p>
      </div>
      <div class="flex flex-wrap gap-2">
        <select v-model="tagOj" class="input w-32" @change="load">
          <option value="ME">本 OJ</option>
        </select>
        <Button variant="secondary" @click="openClassificationDialog()">新增分类</Button>
        <Button @click="openTagDialog()">新增标签</Button>
      </div>
    </div>

    <div v-if="message" class="mb-4 p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
      {{ message }}
    </div>

    <Loading v-if="loading" />

    <div v-else class="grid lg:grid-cols-3 md:grid-cols-2 gap-4">
      <Card v-for="group in groups" :key="groupKey(group)" no-padding>
        <div class="p-4 border-b border-border flex items-center justify-between gap-3">
          <div>
            <h2 class="font-semibold">{{ group.classification?.name || '未分类' }}</h2>
            <p class="text-xs text-muted-foreground mt-1">共 {{ group.tagList?.length || 0 }} 个标签</p>
          </div>
          <div v-if="group.classification" class="flex gap-2">
            <button class="text-sm text-primary hover:underline" @click="openClassificationDialog(group.classification)">编辑</button>
            <button class="text-sm text-destructive hover:underline" @click="deleteClassification(group.classification)">删除</button>
          </div>
        </div>
        <div class="p-4 flex flex-wrap gap-2">
          <button
            v-for="tag in group.tagList"
            :key="tag.id"
            class="px-2.5 py-1 rounded text-sm text-white"
            :style="{ backgroundColor: tag.color || '#409eff' }"
            @click="openTagDialog(tag)"
          >
            {{ tag.name }}
          </button>
          <button class="px-2.5 py-1 rounded text-sm border border-dashed border-border text-muted-foreground hover:text-foreground" @click="openTagDialog(null, group.classification)">
            + 标签
          </button>
        </div>
      </Card>
    </div>

    <div v-if="showTagDialog" class="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div class="w-full max-w-md bg-card border border-border rounded-lg p-5 shadow-xl">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-semibold">{{ tagForm.id ? '编辑标签' : '新增标签' }}</h2>
          <button class="text-muted-foreground hover:text-foreground" @click="showTagDialog = false">关闭</button>
        </div>
        <div class="space-y-4">
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">名称</span>
            <input v-model="tagForm.name" class="input" />
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">颜色</span>
            <input v-model="tagForm.color" type="color" class="h-10 w-20 bg-input border border-border rounded" />
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">分类</span>
            <select v-model="tagForm.tcid" class="input">
              <option :value="null">未分类</option>
              <option v-for="classification in classifications" :key="classification.id" :value="classification.id">
                {{ classification.name }}
              </option>
            </select>
          </label>
          <div class="flex justify-end gap-2 pt-2">
            <Button v-if="tagForm.id" variant="destructive" @click="deleteTag(tagForm)">删除</Button>
            <Button variant="secondary" @click="showTagDialog = false">取消</Button>
            <Button :loading="saving" @click="saveTag">保存</Button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showClassificationDialog" class="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div class="w-full max-w-md bg-card border border-border rounded-lg p-5 shadow-xl">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-semibold">{{ classificationForm.id ? '编辑分类' : '新增分类' }}</h2>
          <button class="text-muted-foreground hover:text-foreground" @click="showClassificationDialog = false">关闭</button>
        </div>
        <div class="space-y-4">
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">名称</span>
            <input v-model="classificationForm.name" class="input" />
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">排序</span>
            <input v-model.number="classificationForm.rank" type="number" min="0" class="input" />
          </label>
          <div class="flex justify-end gap-2 pt-2">
            <Button variant="secondary" @click="showClassificationDialog = false">取消</Button>
            <Button :loading="saving" @click="saveClassification">保存</Button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { adminApi } from '@/api/admin'
import { isSuccess } from '@/api/adapter'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'

type Row = Record<string, any>

const loading = ref(false)
const saving = ref(false)
const tagOj = ref('ME')
const groups = ref<Row[]>([])
const message = ref('')
const messageType = ref<'success' | 'error'>('success')
const showTagDialog = ref(false)
const showClassificationDialog = ref(false)

const tagForm = reactive<Row>({ id: null, name: '', color: '#409eff', oj: 'ME', tcid: null })
const classificationForm = reactive<Row>({ id: null, name: '', rank: 0, oj: 'ME' })

const classifications = computed(() =>
  groups.value.map((group) => group.classification).filter(Boolean) as Row[]
)

const groupKey = (group: Row) => group.classification?.id ?? 'unclassified'

const setMessage = (type: 'success' | 'error', text: string) => {
  messageType.value = type
  message.value = text
}

const load = async () => {
  loading.value = true
  message.value = ''
  try {
    const response = await adminApi.getProblemTagsAndClassification(tagOj.value)
    if (isSuccess(response.data)) {
      groups.value = Array.isArray(response.data.data) ? response.data.data as Row[] : []
    } else {
      setMessage('error', response.data.msg || '加载失败')
    }
  } finally {
    loading.value = false
  }
}

const openTagDialog = (tag?: Row | null, classification?: Row | null) => {
  Object.assign(tagForm, tag
    ? { ...tag }
    : { id: null, name: '', color: '#409eff', oj: tagOj.value, tcid: classification?.id ?? null })
  showTagDialog.value = true
}

const saveTag = async () => {
  if (!tagForm.name) {
    setMessage('error', '标签名称不能为空')
    return
  }
  saving.value = true
  const payload: Row = { ...tagForm, oj: tagForm.oj || tagOj.value }
  const response = payload.id ? await adminApi.updateTag(payload) : await adminApi.addTag(payload)
  saving.value = false
  if (isSuccess(response.data)) {
    showTagDialog.value = false
    setMessage('success', '保存成功')
    load()
  } else {
    setMessage('error', response.data.msg || '保存失败')
  }
}

const deleteTag = async (tag: Row) => {
  if (!window.confirm(`确认删除标签 ${tag.name}？`)) return
  const response = await adminApi.deleteTag(Number(tag.id))
  if (isSuccess(response.data)) {
    setMessage('success', '删除成功')
    load()
  } else {
    setMessage('error', response.data.msg || '删除失败')
  }
}

const openClassificationDialog = (classification?: Row | null) => {
  Object.assign(classificationForm, classification
    ? { ...classification }
    : { id: null, name: '', rank: 0, oj: tagOj.value })
  showClassificationDialog.value = true
}

const saveClassification = async () => {
  if (!classificationForm.name) {
    setMessage('error', '分类名称不能为空')
    return
  }
  saving.value = true
  const payload: Row = { ...classificationForm, oj: classificationForm.oj || tagOj.value }
  const response = payload.id
    ? await adminApi.updateTagClassification(payload)
    : await adminApi.addTagClassification(payload)
  saving.value = false
  if (isSuccess(response.data)) {
    showClassificationDialog.value = false
    setMessage('success', '保存成功')
    load()
  } else {
    setMessage('error', response.data.msg || '保存失败')
  }
}

const deleteClassification = async (classification: Row) => {
  if (!window.confirm(`确认删除分类 ${classification.name}？`)) return
  const response = await adminApi.deleteTagClassification(Number(classification.id))
  if (isSuccess(response.data)) {
    setMessage('success', '删除成功')
    load()
  } else {
    setMessage('error', response.data.msg || '删除失败')
  }
}

onMounted(load)
</script>

<style scoped>
.input {
  height: 2.5rem;
  border-radius: 0.5rem;
  border: 1px solid theme('colors.border');
  background: theme('colors.input');
  padding: 0 0.75rem;
  outline: none;
}

.input:focus {
  box-shadow: 0 0 0 2px theme('colors.ring');
}
</style>
