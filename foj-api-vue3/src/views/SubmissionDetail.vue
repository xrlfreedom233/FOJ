<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <Loading v-if="loading" />

    <div v-else-if="submission" class="space-y-6">
      <!-- Header -->
      <Card>
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div class="flex items-center gap-3 mb-2">
              <span class="text-muted-foreground">#{{ submission.sid }}</span>
              <span
                :class="SUBMISSION_STATUS_CLASS[submission.status]"
                class="text-lg font-bold"
              >
                {{ SUBMISSION_STATUS_TEXT[submission.status] }}
              </span>
            </div>
            <RouterLink
              :to="`/problem/${submission.problemId}`"
              class="text-xl font-medium hover:text-primary transition-colors"
            >
              #{{ submission.problemId }} {{ submission.problem_title }}
            </RouterLink>
          </div>

          <div class="flex items-center gap-6 text-sm">
            <div>
              <div class="text-muted-foreground">用户</div>
              <div class="font-medium">{{ submission.username }}</div>
            </div>
            <div>
              <div class="text-muted-foreground">语言</div>
              <div class="font-medium">{{ getLanguageLabel(submission.language) }}</div>
            </div>
            <div>
              <div class="text-muted-foreground">提交时间</div>
              <div class="font-medium">{{ formatTime(submission.create_time) }}</div>
            </div>
          </div>
        </div>
      </Card>

      <Card v-if="userStore.isSuperAdmin">
        <template #header>
          <h2 class="font-semibold">管理员判题操作</h2>
        </template>
        <div v-if="actionMessage" class="mb-4 p-3 rounded-lg text-sm" :class="actionMessageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
          {{ actionMessage }}
        </div>
        <div class="flex flex-wrap items-center gap-3">
          <Button :loading="actionLoading === 'rejudge'" @click="handleRejudge">重判</Button>
          <Button variant="secondary" :loading="actionLoading === 'cancel'" @click="handleCancelJudge">取消判题</Button>
          <select v-model.number="manualStatus" class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring">
            <option :value="0">Accepted</option>
            <option :value="-1">Wrong Answer</option>
            <option :value="1">Time Limit Exceeded</option>
            <option :value="2">Memory Limit Exceeded</option>
            <option :value="3">Runtime Error</option>
            <option :value="-2">Compile Error</option>
          </select>
          <input
            v-model.number="manualScore"
            type="number"
            min="0"
            class="h-10 w-28 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
            placeholder="分数"
          />
          <Button variant="secondary" :loading="actionLoading === 'manual'" @click="handleManualJudge">手动判题</Button>
        </div>
      </Card>

      <!-- Stats -->
      <div v-if="submission.status === 0" class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card>
          <div class="text-center">
            <div class="text-2xl font-bold text-success">{{ submission.time_cost }}ms</div>
            <div class="text-sm text-muted-foreground">运行时间</div>
          </div>
        </Card>
        <Card>
          <div class="text-center">
            <div class="text-2xl font-bold text-primary">{{ formatMemory(submission.memory_cost) }}</div>
            <div class="text-sm text-muted-foreground">内存消耗</div>
          </div>
        </Card>
        <Card>
          <div class="text-center">
            <div class="text-2xl font-bold text-accent">{{ submission.code_length }}</div>
            <div class="text-sm text-muted-foreground">代码长度</div>
          </div>
        </Card>
        <Card>
          <div class="text-center">
            <div class="text-2xl font-bold text-foreground">{{ submission.judge_info?.length || 0 }}</div>
            <div class="text-sm text-muted-foreground">测试点数</div>
          </div>
        </Card>
      </div>

      <!-- Compile Error -->
      <Card v-if="submission.status === -2 && submission.compile_info">
        <template #header>
          <h2 class="font-semibold text-destructive">编译错误信息</h2>
        </template>
        <pre class="p-4 bg-card border border-border rounded-lg text-sm font-mono overflow-x-auto text-destructive">{{ submission.compile_info }}</pre>
      </Card>

      <!-- Judge Info -->
      <Card v-if="submission.judge_info?.length">
        <template #header>
          <h2 class="font-semibold">测试点详情</h2>
        </template>

        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-3">
          <div
            v-for="(info, index) in submission.judge_info"
            :key="index"
            :class="[
              'p-3 rounded-lg border text-center transition-colors',
              info.status === 0
                ? 'border-success/50 bg-success/10'
                : 'border-destructive/50 bg-destructive/10',
            ]"
          >
            <div class="text-sm font-medium mb-1">测试点 #{{ info.case_id }}</div>
            <div
              :class="info.status === 0 ? 'text-success' : 'text-destructive'"
              class="text-xs font-medium mb-1"
            >
              {{ SUBMISSION_STATUS_TEXT[info.status] }}
            </div>
            <div class="text-xs text-muted-foreground">
              {{ info.time_cost }}ms / {{ formatMemory(info.memory_cost) }}
            </div>
          </div>
        </div>
      </Card>

      <!-- Code -->
      <Card>
        <template #header>
          <div class="flex items-center justify-between">
            <h2 class="font-semibold">提交代码</h2>
            <button
              @click="copyCode"
              class="px-3 py-1.5 text-sm text-primary hover:bg-primary/10 rounded-lg transition-colors"
            >
              复制代码
            </button>
          </div>
        </template>

        <div class="border border-border rounded-lg overflow-hidden">
          <Codemirror
            v-model="submission.code"
            :style="{ maxHeight: '500px' }"
            :extensions="extensions"
            :disabled="true"
          />
        </div>
      </Card>

      <!-- Actions -->
      <div class="flex items-center gap-4">
        <button
          @click="handleResubmit"
          class="px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors"
        >
          重新提交
        </button>
        <button
          class="px-4 py-2 bg-secondary text-foreground rounded-lg hover:bg-secondary/80 transition-colors"
          @click="goSubmissionList"
        >
          返回列表
        </button>
      </div>
    </div>

    <div v-else>
      <Empty title="提交记录不存在" description="请检查提交编号是否正确">
        <button
          class="mt-4 inline-block px-4 py-2 bg-primary text-primary-foreground rounded-lg"
          @click="goSubmissionList"
        >
          返回提交列表
        </button>
      </Empty>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { Codemirror } from 'vue-codemirror'
import { cpp } from '@codemirror/lang-cpp'
import { java } from '@codemirror/lang-java'
import { python } from '@codemirror/lang-python'
import { oneDark } from '@codemirror/theme-one-dark'
import { submissionApi } from '@/api/submission'
import { adminApi } from '@/api/admin'
import { isSuccess, mapSubmissionDetail } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import type { SubmissionDetail } from '@/types'
import { SUBMISSION_STATUS_TEXT, SUBMISSION_STATUS_CLASS, LANGUAGES } from '@/types'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import dayjs from 'dayjs'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const submission = ref<SubmissionDetail | null>(null)
const loading = ref(true)
const actionLoading = ref<'rejudge' | 'cancel' | 'manual' | ''>('')
const actionMessage = ref('')
const actionMessageType = ref<'success' | 'error'>('success')
const manualStatus = ref(0)
const manualScore = ref<number | undefined>()

const getLanguageExtension = (lang: string) => {
  if (lang.includes('Java')) return java()
  if (lang.includes('Py')) return python()
  return cpp()
}

const extensions = computed(() => [
  getLanguageExtension(submission.value?.language || 'C++ 17'),
  oneDark,
])

const getLanguageLabel = (lang: string) => {
  return LANGUAGES.find(l => l.value === lang)?.label || lang
}

const formatTime = (time: string) => {
  return dayjs(time).format('YYYY-MM-DD HH:mm:ss')
}

const formatMemory = (kb: number) => {
  if (kb < 1024) return `${kb}KB`
  return `${(kb / 1024).toFixed(1)}MB`
}

const copyCode = async () => {
  if (!submission.value?.code) return
  try {
    await navigator.clipboard.writeText(submission.value.code)
  } catch {
    // Fallback
  }
}

const handleResubmit = () => {
  if (!submission.value) return
  sessionStorage.setItem('foj-resubmit-code', JSON.stringify({
    problemId: submission.value.problemId,
    language: submission.value.language,
    code: submission.value.code,
  }))
  router.push(`/problem/${submission.value.problemId}`)
}

const goSubmissionList = () => {
  router.push({ name: 'submissions' })
}

const fetchSubmission = async () => {
  const sid = Number(route.params.sid)
  if (!sid) return

  loading.value = true
  try {
    const response = await submissionApi.getDetail(sid)
    if (isSuccess(response.data)) {
      submission.value = mapSubmissionDetail(response.data.data)
    } else {
      submission.value = null
    }
  } catch {
    submission.value = null
  } finally {
    loading.value = false
  }
}

const setActionMessage = (type: 'success' | 'error', text: string) => {
  actionMessageType.value = type
  actionMessage.value = text
}

const handleRejudge = async () => {
  if (!submission.value) return
  actionLoading.value = 'rejudge'
  const response = await adminApi.rejudge(submission.value.sid)
  actionLoading.value = ''
  if (isSuccess(response.data)) {
    setActionMessage('success', '已提交重判')
    fetchSubmission()
  } else {
    setActionMessage('error', response.data.msg || '重判失败')
  }
}

const handleCancelJudge = async () => {
  if (!submission.value) return
  actionLoading.value = 'cancel'
  const response = await adminApi.cancelJudge(submission.value.sid)
  actionLoading.value = ''
  if (isSuccess(response.data)) {
    setActionMessage('success', '已取消判题')
    fetchSubmission()
  } else {
    setActionMessage('error', response.data.msg || '取消失败')
  }
}

const handleManualJudge = async () => {
  if (!submission.value) return
  actionLoading.value = 'manual'
  const response = await adminApi.manualJudge(submission.value.sid, manualStatus.value, manualScore.value)
  actionLoading.value = ''
  if (isSuccess(response.data)) {
    setActionMessage('success', '手动判题已保存')
    fetchSubmission()
  } else {
    setActionMessage('error', response.data.msg || '手动判题失败')
  }
}

onMounted(fetchSubmission)
</script>
