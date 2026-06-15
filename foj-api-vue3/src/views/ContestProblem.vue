<template>
  <div class="min-h-[calc(100vh-4rem)] pb-16">
    <Loading v-if="loading" />

    <div v-else-if="problem" class="flex flex-col lg:flex-row h-[calc(100vh-4rem)]">
      <!-- Problem Description -->
      <div class="lg:w-1/2 overflow-y-auto border-r border-border">
        <div class="p-6">
          <!-- Contest Info -->
          <RouterLink
            :to="`/contest/${cid}`"
            class="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-primary mb-4"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            返回比赛
          </RouterLink>

          <!-- Header -->
          <div class="flex items-start justify-between mb-6">
            <div>
              <div class="flex items-center gap-3 mb-2">
                <span class="text-2xl font-bold text-primary">{{ index }}</span>
                <span :class="DIFFICULTY_CLASS[problem.difficulty]" class="font-medium">
                  {{ DIFFICULTY_TEXT[problem.difficulty] }}
                </span>
              </div>
              <h1 class="text-2xl font-bold">{{ problem.title }}</h1>
            </div>
          </div>

          <!-- Limits -->
          <div class="flex items-center gap-6 mb-6 p-4 bg-secondary/50 rounded-lg text-sm">
            <div>
              <span class="text-muted-foreground">时间限制: </span>
              <span class="font-medium">{{ problem.time_limit }}ms</span>
            </div>
            <div>
              <span class="text-muted-foreground">内存限制: </span>
              <span class="font-medium">{{ problem.memory_limit }}MB</span>
            </div>
          </div>

          <!-- Description -->
          <div class="space-y-6">
            <section>
              <h2 class="text-lg font-semibold mb-3">题目描述</h2>
              <div class="prose prose-invert max-w-none" v-html="formatContent(problem.description)"></div>
            </section>

            <section>
              <h2 class="text-lg font-semibold mb-3">输入格式</h2>
              <div class="prose prose-invert max-w-none" v-html="formatContent(problem.input_description)"></div>
            </section>

            <section>
              <h2 class="text-lg font-semibold mb-3">输出格式</h2>
              <div class="prose prose-invert max-w-none" v-html="formatContent(problem.output_description)"></div>
            </section>

            <!-- Samples -->
            <section v-if="problem.samples?.length">
              <h2 class="text-lg font-semibold mb-3">样例</h2>
              <div v-for="(sample, idx) in problem.samples" :key="idx" class="mb-4">
                <div class="grid md:grid-cols-2 gap-4">
                  <div>
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-medium">输入 #{{ idx + 1 }}</span>
                      <button @click="copyToClipboard(sample.input)" class="text-xs text-primary hover:underline">
                        复制
                      </button>
                    </div>
                    <pre class="p-3 bg-card border border-border rounded-lg text-sm font-mono overflow-x-auto">{{ sample.input }}</pre>
                  </div>
                  <div>
                    <div class="flex items-center justify-between mb-2">
                      <span class="text-sm font-medium">输出 #{{ idx + 1 }}</span>
                      <button @click="copyToClipboard(sample.output)" class="text-xs text-primary hover:underline">
                        复制
                      </button>
                    </div>
                    <pre class="p-3 bg-card border border-border rounded-lg text-sm font-mono overflow-x-auto">{{ sample.output }}</pre>
                  </div>
                </div>
              </div>
            </section>

            <section v-if="problem.hint">
              <h2 class="text-lg font-semibold mb-3">提示</h2>
              <div class="prose prose-invert max-w-none" v-html="formatContent(problem.hint)"></div>
            </section>
          </div>
        </div>
      </div>

      <!-- Code Editor -->
      <div class="lg:w-1/2 flex flex-col">
        <div class="flex items-center justify-between px-4 py-3 border-b border-border bg-card">
          <select
            v-model="selectedLanguage"
            class="px-3 py-1.5 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          >
            <option v-for="lang in languageOptions" :key="lang.value" :value="lang.value">
              {{ lang.label }}
            </option>
          </select>

          <div class="flex items-center gap-2">
            <button
              @click="resetCode"
              class="px-3 py-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors"
            >
              重置
            </button>
            <Button
              @click="handleSubmit"
              :loading="submitting"
              :disabled="!userStore.isLoggedIn"
            >
              {{ userStore.isLoggedIn ? '提交' : '请先登录' }}
            </Button>
          </div>
        </div>

        <div class="flex-1 overflow-hidden">
          <Codemirror
            v-model="code"
            :style="{ height: '100%' }"
            :extensions="extensions"
            :autofocus="true"
          />
        </div>

        <div v-if="submitResult" class="p-4 border-t border-border bg-card">
          <div class="flex items-center gap-3">
            <span :class="submitResult.success ? 'text-success' : 'text-destructive'" class="font-medium">
              {{ submitResult.message }}
            </span>
            <RouterLink
              v-if="submitResult.sid"
              :to="`/submission/${submitResult.sid}`"
              class="text-primary hover:underline text-sm"
            >
              查看详情
            </RouterLink>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="flex items-center justify-center h-[calc(100vh-4rem)]">
      <Empty title="题目不存在" description="请检查题目编号是否正确">
        <RouterLink
          :to="`/contest/${cid}`"
          class="mt-4 inline-block px-4 py-2 bg-primary text-primary-foreground rounded-lg"
        >
          返回比赛
        </RouterLink>
      </Empty>
    </div>

    <div
      v-if="fullScreenProblems.length"
      class="fixed inset-x-0 bottom-0 z-40 border-t border-border bg-card/95 backdrop-blur"
    >
      <div class="mx-auto flex max-w-7xl gap-2 overflow-x-auto px-4 py-2">
        <RouterLink
          v-for="item in fullScreenProblems"
          :key="item.problemId"
          :to="`/contest/${cid}/problem/${item.problemId}`"
          class="flex min-w-[216px] max-w-[260px] items-center gap-2 rounded-md border px-3 py-2 text-sm transition-colors"
          :class="[
            item.problemId === index ? 'border-primary bg-primary/10 text-primary' : 'border-border hover:bg-secondary/60',
          ]"
          :title="item.title"
        >
          <span
            class="flex h-7 shrink-0 items-center justify-center whitespace-nowrap rounded px-2 text-xs font-semibold"
            :class="getFullScreenStatusClass(item.status)"
          >
            {{ item.problemId }}
          </span>
          <span class="flex min-w-0 items-baseline gap-1">
            <span class="block min-w-0 truncate">{{ item.title }}</span>
            <span v-if="item.score !== undefined && item.score !== null" class="shrink-0 text-xs text-muted-foreground">{{ item.score }}</span>
          </span>
        </RouterLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { Codemirror } from 'vue-codemirror'
import { cpp } from '@codemirror/lang-cpp'
import { java } from '@codemirror/lang-java'
import { python } from '@codemirror/lang-python'
import { oneDark } from '@codemirror/theme-one-dark'
import { contestApi } from '@/api/contest'
import { problemApi, type FullScreenProblem } from '@/api/problem'
import { submissionApi } from '@/api/submission'
import { isSuccess, mapProblemDetail } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import { renderMarkdown } from '@/utils/markdown'
import type { ProblemDetail } from '@/types'
import { DIFFICULTY_TEXT, DIFFICULTY_CLASS, LANGUAGES } from '@/types'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const cid = computed(() => Number(route.params.cid))
const index = computed(() => String(route.params.index))

const problem = ref<ProblemDetail | null>(null)
const loading = ref(true)
const submitting = ref(false)
const selectedLanguage = ref('Java')
const code = ref('')
const submitResult = ref<{ success: boolean; message: string; sid?: number } | null>(null)
const languageOptions = ref(LANGUAGES.map(lang => ({ ...lang })))
const codeTemplates = ref<Record<string, string>>({})
const fullScreenProblems = ref<FullScreenProblem[]>([])

const defaultCodes: Record<string, string> = {
  C: '#include <stdio.h>\n\nint main() {\n    \n    return 0;\n}',
  'C++ 17': '#include <iostream>\nusing namespace std;\n\nint main() {\n    \n    return 0;\n}',
  Java: 'import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        \n    }\n}',
  Python3: '# Python 3\n\n',
  Golang: 'package main\n\nimport "fmt"\n\nfunc main() {\n    \n}',
  Rust: 'use std::io;\n\nfn main() {\n    \n}',
}

const getLanguageExtension = (lang: string) => {
  if (lang.includes('Java')) return java()
  if (lang.includes('Py')) return python()
  return cpp()
}

const extensions = computed(() => [
  getLanguageExtension(selectedLanguage.value),
  oneDark,
])

const formatContent = (content: string) => renderMarkdown(content)

const copyToClipboard = async (text: string) => {
  try {
    await navigator.clipboard.writeText(text)
  } catch {
    // Fallback
  }
}

const resetCode = () => {
  code.value = codeTemplates.value[selectedLanguage.value] || defaultCodes[selectedLanguage.value] || ''
}

const getFullScreenStatusClass = (status?: number) => {
  if (status === 0) return 'bg-success/20 text-success'
  if (status === undefined || status === null) return 'bg-secondary text-muted-foreground'
  if (status === -5) return 'bg-warning/20 text-warning'
  return 'bg-destructive/15 text-destructive'
}

const loadFullScreenProblemList = async () => {
  try {
    const response = await problemApi.getFullScreenProblemList({ cid: cid.value })
    fullScreenProblems.value = isSuccess(response.data) && Array.isArray(response.data.data)
      ? response.data.data
      : []
  } catch {
    fullScreenProblems.value = []
  }
}

const loadProblemCodeConfig = async () => {
  if (!problem.value) return
  const [languageResponse, templateResponse] = await Promise.all([
    problemApi.getProblemLanguages(problem.value.pid),
    problemApi.getProblemCodeTemplate(problem.value.pid),
  ])

  const languageIdMap = new Map<number, string>()
  if (isSuccess(languageResponse.data) && languageResponse.data.data?.length) {
    const languages = languageResponse.data.data
      .filter(lang => lang.name)
      .map(lang => {
        if (lang.id !== undefined && lang.name) {
          languageIdMap.set(Number(lang.id), lang.name)
        }
        if (lang.name && lang.codeTemplate) {
          codeTemplates.value[lang.name] = lang.codeTemplate
        }
        return {
          value: lang.name || '',
          label: lang.name || '',
        }
      })
      .filter(lang => lang.value)
    if (languages.length) {
      languageOptions.value = languages
      if (!languages.some(lang => lang.value === selectedLanguage.value)) {
        selectedLanguage.value = languages[0].value
      }
    }
  }

  if (isSuccess(templateResponse.data) && templateResponse.data.data?.length) {
    templateResponse.data.data.forEach(template => {
      const language = template.language || (template.lid !== undefined ? languageIdMap.get(Number(template.lid)) : undefined)
      const templateCode = template.code || template.sourceCode || template.template
      if (language && templateCode) {
        codeTemplates.value[language] = templateCode
      }
    })
  }
}

const handleSubmit = async () => {
  if (!userStore.isLoggedIn || !problem.value) return

  submitting.value = true
  submitResult.value = null

  try {
    const response = await submissionApi.contestSubmit(cid.value, {
      pid: index.value,
      language: selectedLanguage.value,
      code: code.value,
    })

    if (isSuccess(response.data)) {
      const submitId = response.data.data.submitId ?? response.data.data.sid
      submitResult.value = {
        success: true,
        message: '提交成功！',
        sid: submitId,
      }
      router.push({
        path: `/contest/${cid.value}`,
        query: {
          submitId: submitId ? String(submitId) : undefined,
          problemId: index.value,
        },
      })
    } else {
      submitResult.value = {
        success: false,
        message: response.data.msg || '提交失败',
      }
    }
  } catch {
    submitResult.value = {
      success: false,
      message: '提交失败，请检查后端服务或登录状态',
    }
  } finally {
    submitting.value = false
  }
}

const fetchProblem = async () => {
  loading.value = true
  try {
    const response = await contestApi.getProblem(cid.value, index.value)
    if (isSuccess(response.data)) {
      problem.value = mapProblemDetail(response.data.data)
      await loadFullScreenProblemList()
      await loadProblemCodeConfig()
      resetCode()
    } else {
      problem.value = null
      fullScreenProblems.value = []
    }
  } catch {
    problem.value = null
    fullScreenProblems.value = []
  } finally {
    loading.value = false
  }
}

watch(selectedLanguage, () => {
  resetCode()
}, { immediate: true })

watch(
  () => [route.params.cid, route.params.index],
  () => {
    submitResult.value = null
    fetchProblem()
  }
)

onMounted(fetchProblem)
</script>

<style>
.prose {
  color: inherit;
  line-height: 1.75;
}

.prose p {
  margin-bottom: 1em;
}
</style>
