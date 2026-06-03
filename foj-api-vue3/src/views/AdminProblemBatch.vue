<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <div>
        <h1 class="text-2xl font-bold">题目导入导出</h1>
        <p class="text-muted-foreground mt-1">导出 FOJ 题目包，或导入 FOJ/QDUOJ/FPS/Hydro 题目包</p>
      </div>
      <div class="flex gap-2">
        <input v-model="keyword" class="input w-56" placeholder="搜索题目" @keyup.enter="handleSearch" />
        <Button variant="secondary" @click="handleSearch">搜索</Button>
        <Button :loading="exporting" @click="exportSelected">导出选中</Button>
      </div>
    </div>

    <div v-if="message" class="mb-4 p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
      {{ message }}
    </div>

    <Card no-padding>
      <Loading v-if="loading" />
      <div v-else-if="rows.length === 0" class="p-8">
        <Empty title="暂无可导出的题目" />
      </div>
      <div v-else class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-secondary/50 text-muted-foreground">
            <tr>
              <th class="px-4 py-3 text-left w-12">
                <input type="checkbox" :checked="isAllSelected" @change="toggleAll" />
              </th>
              <th class="px-4 py-3 text-left font-medium">ID</th>
              <th class="px-4 py-3 text-left font-medium">展示 ID</th>
              <th class="px-4 py-3 text-left font-medium">标题</th>
              <th class="px-4 py-3 text-left font-medium">作者</th>
              <th class="px-4 py-3 text-left font-medium">创建时间</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in rows" :key="row.id" class="border-t border-border hover:bg-secondary/20">
              <td class="px-4 py-3">
                <input v-model="selectedIds" type="checkbox" :value="Number(row.id)" />
              </td>
              <td class="px-4 py-3 whitespace-nowrap">{{ row.id }}</td>
              <td class="px-4 py-3 whitespace-nowrap">{{ row.problemId || '-' }}</td>
              <td class="px-4 py-3">{{ row.title || '-' }}</td>
              <td class="px-4 py-3 whitespace-nowrap">{{ row.author || '-' }}</td>
              <td class="px-4 py-3 whitespace-nowrap">{{ formatTime(row.gmtCreate) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <template #footer>
        <div class="flex items-center justify-between gap-4">
          <span class="text-sm text-muted-foreground">已选 {{ selectedIds.length }} 项，共 {{ total }} 条</span>
          <Pagination v-if="totalPages > 1" :current-page="currentPage" :total-pages="totalPages" @change="handlePageChange" />
        </div>
      </template>
    </Card>

    <div class="grid md:grid-cols-2 gap-4 mt-6">
      <Card v-for="item in importTypes" :key="item.kind">
        <div class="flex items-start justify-between gap-4">
          <div>
            <h2 class="font-semibold">{{ item.title }}</h2>
            <p class="text-sm text-muted-foreground mt-1">{{ item.description }}</p>
          </div>
          <Button :loading="uploadingKind === item.kind" @click="upload(item.kind)">上传</Button>
        </div>
        <input class="mt-4 block w-full text-sm" type="file" accept=".zip,.xml" @change="setFile(item.kind, $event)" />
        <p v-if="files[item.kind]" class="text-sm text-muted-foreground mt-2">{{ files[item.kind]?.name }}</p>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { computed, onMounted, reactive, ref } from 'vue'
import { adminApi } from '@/api/admin'
import { getPageRecords, getPageTotal, isSuccess } from '@/api/adapter'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import Pagination from '@/components/ui/Pagination.vue'

type Row = Record<string, any>
type ImportKind = 'foj' | 'qduoj' | 'fps' | 'hydro'

const rows = ref<Row[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = 10
const keyword = ref('')
const selectedIds = ref<number[]>([])
const loading = ref(false)
const exporting = ref(false)
const uploadingKind = ref<ImportKind | ''>('')
const message = ref('')
const messageType = ref<'success' | 'error'>('success')
const files = reactive<Record<ImportKind, File | null>>({ foj: null, qduoj: null, fps: null, hydro: null })

const importTypes: Array<{ kind: ImportKind; title: string; description: string }> = [
  { kind: 'foj', title: '导入 FOJ 题目', description: '导入系统导出的 FOJ zip 题目包' },
  { kind: 'qduoj', title: '导入 QDUOJ 题目', description: '导入 QDUOJ 格式题目包' },
  { kind: 'fps', title: '导入 FPS 题目', description: '导入 FPS XML/压缩包' },
  { kind: 'hydro', title: '导入 Hydro 题目', description: '导入 Hydro 题目包' },
]

const totalPages = computed(() => Math.ceil(total.value / pageSize))
const isAllSelected = computed(() => rows.value.length > 0 && rows.value.every((row) => selectedIds.value.includes(Number(row.id))))

const setMessage = (type: 'success' | 'error', text: string) => {
  messageType.value = type
  message.value = text
}

const formatTime = (value: unknown) => value ? dayjs(value as string).format('YYYY-MM-DD HH:mm') : '-'

const downloadBlob = (blob: Blob, filename: string) => {
  if (!blob || blob.size === 0) {
    setMessage('error', '下载文件为空，请重新导出后再下载')
    return
  }
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  link.remove()
  window.setTimeout(() => URL.revokeObjectURL(url), 1000)
}

const load = async () => {
  loading.value = true
  message.value = ''
  try {
    const response = await adminApi.getProblemList({
      page: currentPage.value,
      page_size: pageSize,
      keyword: keyword.value || undefined,
      oj: 'Mine',
    })
    if (isSuccess(response.data)) {
      rows.value = getPageRecords(response.data.data) as Row[]
      total.value = getPageTotal(response.data.data)
    } else {
      setMessage('error', response.data.msg || '加载失败')
    }
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  selectedIds.value = []
  load()
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  load()
}

const toggleAll = () => {
  if (isAllSelected.value) {
    const pageIds = new Set(rows.value.map((row) => Number(row.id)))
    selectedIds.value = selectedIds.value.filter((id) => !pageIds.has(id))
  } else {
    selectedIds.value = [...new Set([...selectedIds.value, ...rows.value.map((row) => Number(row.id))])]
  }
}

const exportSelected = async () => {
  if (!selectedIds.value.length) {
    setMessage('error', '请选择需要导出的题目')
    return
  }
  exporting.value = true
  try {
    const response = await adminApi.exportProblemZip(selectedIds.value)
    downloadBlob(response.data, `foj-problems-${dayjs().format('YYYYMMDD-HHmmss')}.zip`)
    setMessage('success', '导出已开始下载')
  } finally {
    exporting.value = false
  }
}

const setFile = (kind: ImportKind, event: Event) => {
  const input = event.target as HTMLInputElement
  files[kind] = input.files?.[0] ?? null
}

const upload = async (kind: ImportKind) => {
  const file = files[kind]
  if (!file) {
    setMessage('error', '请先选择文件')
    return
  }
  uploadingKind.value = kind
  try {
    const response = await adminApi.uploadProblemArchive(kind, file)
    if (isSuccess(response.data)) {
      files[kind] = null
      setMessage('success', '导入成功')
      load()
    } else {
      setMessage('error', response.data.msg || '导入失败')
    }
  } finally {
    uploadingKind.value = ''
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
