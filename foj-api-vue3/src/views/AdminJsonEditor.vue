<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <div>
        <h1 class="text-2xl font-bold">{{ title }}</h1>
        <p class="text-muted-foreground mt-1">{{ isProblemMode ? '编辑题目基本信息、题面、样例和语言' : '编辑原始配置内容' }}</p>
      </div>
      <div class="flex gap-2">
        <Button variant="secondary" @click="$router.back()">返回</Button>
        <Button :loading="saving" @click="save">保存</Button>
      </div>
    </div>

    <Card>
      <div v-if="message" class="mb-4 p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
        {{ message }}
      </div>

      <div v-if="isProblemMode" class="space-y-8">
        <section class="space-y-4">
          <h2 class="text-lg font-semibold">基本信息</h2>
          <div class="grid md:grid-cols-2 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">展示 ID</span>
              <input v-model="problem.problemId" class="input" placeholder="例如 FOJ-1000" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">标题</span>
              <input v-model="problem.title" class="input" placeholder="题目标题" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">权限</span>
              <select v-model.number="problem.auth" class="input">
                <option :value="1">公开</option>
                <option :value="2">私有</option>
                <option :value="3">比赛中</option>
              </select>
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">类型</span>
              <select v-model.number="problem.type" class="input">
                <option :value="0">ACM</option>
                <option :value="1">OI</option>
              </select>
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">时间限制 ms</span>
              <input v-model.number="problem.timeLimit" type="number" min="0" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">内存限制 MB</span>
              <input v-model.number="problem.memoryLimit" type="number" min="0" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">来源</span>
              <input v-model="problem.source" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">难度</span>
              <select v-model.number="problem.difficulty" class="input">
                <option :value="0">简单</option>
                <option :value="1">中等</option>
                <option :value="2">困难</option>
              </select>
            </label>
          </div>
        </section>

        <section class="space-y-4">
          <h2 class="text-lg font-semibold">题面</h2>
          <MarkdownEditor v-model="problem.description" label="题目描述" :rows="8" />
          <MarkdownEditor v-model="problem.input" label="输入描述" :rows="5" />
          <MarkdownEditor v-model="problem.output" label="输出描述" :rows="5" />
          <MarkdownEditor v-model="problem.hint" label="提示" :rows="4" />
        </section>

        <section class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-lg font-semibold">题面样例</h2>
              <p class="text-sm text-muted-foreground mt-1">只展示给用户，不参与判题。</p>
            </div>
            <Button size="sm" variant="secondary" @click="addExample">添加样例</Button>
          </div>
          <div v-for="(sample, index) in examples" :key="index" class="p-4 bg-secondary/30 rounded-lg space-y-3">
            <div class="flex items-center justify-between">
              <span class="font-medium">样例 {{ index + 1 }}</span>
              <button class="text-sm text-destructive hover:underline" @click="removeExample(index)">删除</button>
            </div>
            <div class="grid md:grid-cols-2 gap-3">
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">输入</span>
                <textarea v-model="sample.input" class="textarea" rows="5" />
              </label>
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">输出</span>
                <textarea v-model="sample.output" class="textarea" rows="5" />
              </label>
            </div>
          </div>
          <Empty v-if="examples.length === 0" title="暂无题面样例" />
        </section>

        <section class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-lg font-semibold">判题测试点</h2>
              <p class="text-sm text-muted-foreground mt-1">用于判定提交是否正确，不会展示在题面中。</p>
            </div>
            <Button size="sm" variant="secondary" @click="addJudgeCase">添加测试点</Button>
          </div>
          <div v-for="(judgeCase, index) in judgeCases" :key="judgeCase.id ?? index" class="p-4 bg-secondary/30 rounded-lg space-y-3">
            <div class="flex items-center justify-between">
              <span class="font-medium">测试点 {{ index + 1 }}</span>
              <button class="text-sm text-destructive hover:underline" @click="removeJudgeCase(index)">删除</button>
            </div>
            <div class="grid md:grid-cols-2 gap-3">
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">输入</span>
                <textarea v-model="judgeCase.input" class="textarea" rows="5" />
              </label>
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">输出</span>
                <textarea v-model="judgeCase.output" class="textarea" rows="5" />
              </label>
            </div>
            <div>
              <label class="space-y-1.5 block">
                <span class="text-sm text-muted-foreground">分数（OI 可用）</span>
                <input v-model.number="judgeCase.score" type="number" min="0" class="input w-32" />
              </label>
            </div>
          </div>
          <Empty v-if="judgeCases.length === 0" title="暂无判题测试点" />
        </section>

        <section class="space-y-4">
          <h2 class="text-lg font-semibold">语言与标签</h2>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">允许语言</span>
            <input v-model="languagesText" class="input" list="language-options" placeholder="用逗号分隔，例如 C++,Java,Python3" />
            <datalist id="language-options">
              <option v-for="language in availableLanguages" :key="language" :value="language" />
            </datalist>
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">标签</span>
            <div class="rounded-lg border border-border bg-input p-3">
              <div v-if="tagGroups.length" class="space-y-4">
                <div v-for="group in tagGroups" :key="tagGroupKey(group)" class="space-y-2">
                  <div class="text-sm text-muted-foreground">{{ group.classification?.name || '未分类' }}</div>
                  <div class="flex flex-wrap gap-2">
                    <label
                      v-for="tag in group.tagList"
                      :key="tag.id"
                      class="inline-flex cursor-pointer items-center gap-2 rounded-md border border-border px-2.5 py-1.5 text-sm transition-colors hover:bg-secondary/60"
                      :class="selectedTagIds.includes(Number(tag.id)) ? 'border-primary bg-primary/10 text-primary' : ''"
                    >
                      <input
                        v-model="selectedTagIds"
                        type="checkbox"
                        class="h-4 w-4 accent-primary"
                        :value="Number(tag.id)"
                      />
                      <span
                        class="h-2.5 w-2.5 rounded-full"
                        :style="{ backgroundColor: tag.color || '#409eff' }"
                      />
                      <span>{{ tag.name }}</span>
                    </label>
                  </div>
                </div>
              </div>
              <Empty v-else title="暂无可选标签" />
            </div>
          </label>
        </section>
      </div>

      <textarea
        v-else
        v-model="jsonText"
        class="w-full min-h-[520px] p-4 bg-input border border-border rounded-lg font-mono text-sm focus:outline-none focus:ring-2 focus:ring-ring"
        spellcheck="false"
      />
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { adminApi } from '@/api/admin'
import { problemApi } from '@/api/problem'
import { isSuccess } from '@/api/adapter'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Empty from '@/components/ui/Empty.vue'
import MarkdownEditor from '@/components/ui/MarkdownEditor.vue'

type ExampleForm = {
  input: string
  output: string
}

type JudgeCaseForm = {
  id?: number
  input: string
  output: string
  score?: number
  groupNum?: number
}

type Row = Record<string, any>

const route = useRoute()
const router = useRouter()

const jsonText = ref('{}')
const saving = ref(false)
const message = ref('')
const messageType = ref<'success' | 'error'>('success')
const defaultLanguages = [
  'C',
  'C With O2',
  'C++',
  'C++ With O2',
  'C++ 17',
  'C++ 17 With O2',
  'C++ 20',
  'C++ 20 With O2',
  'Java',
  'Python2',
  'Python3',
  'PyPy2',
  'PyPy3',
  'Golang',
  'C#',
  'PHP',
  'JavaScript Node',
  'JavaScript V8',
  'Ruby',
  'Rust',
]
const availableLanguages = ref<string[]>([...defaultLanguages])
const languagesText = ref(defaultLanguages.join(','))
const examples = ref<ExampleForm[]>([])
const judgeCases = ref<JudgeCaseForm[]>([])
const originalJudgeCaseMode = ref('default')
const tagGroups = ref<Row[]>([])
const selectedTagIds = ref<number[]>([])

const problem = reactive<Record<string, any>>({
  problemId: '',
  title: '',
  auth: route.params.contestId ? 3 : 1,
  type: 0,
  timeLimit: 1000,
  memoryLimit: 256,
  stackLimit: 128,
  difficulty: 0,
  judgeMode: 'default',
  judgeCaseMode: 'default',
  description: '',
  input: '',
  output: '',
  source: '',
  hint: '',
  examples: '[]',
})

const mode = computed(() => String(route.meta.adminEditor || 'problem'))
const isProblemMode = computed(() => mode.value === 'problem' || mode.value === 'contest-problem')
const id = computed(() => Number(route.params.problemId || route.params.contestId || 0))

const title = computed(() => {
  const action = id.value && (mode.value !== 'contest' || route.params.contestId) ? '编辑' : '创建'
  if (mode.value === 'contest') return `${action}比赛`
  if (mode.value === 'contest-problem') return `${action}比赛题目`
  return `${action}题目`
})

const toNameList = (text: string) =>
  text.split(',').map((item) => item.trim()).filter(Boolean)

const allTags = computed(() =>
  tagGroups.value.flatMap((group) => Array.isArray(group.tagList) ? group.tagList as Row[] : [])
)

const selectedTags = computed(() =>
  selectedTagIds.value
    .map((id) => allTags.value.find((tag) => Number(tag.id) === id))
    .filter(Boolean)
    .map((tag) => ({
      id: Number(tag!.id),
      name: tag!.name,
      color: tag!.color,
      oj: tag!.oj || 'ME',
      tcid: tag!.tcid ?? null,
    }))
)

const tagGroupKey = (group: Row) => group.classification?.id ?? 'unclassified'

const problemPayload = computed(() => {
  const normalizedJudgeCases = judgeCases.value.map((judgeCase, index) => ({
    id: judgeCase.id,
    input: judgeCase.input,
    output: judgeCase.output,
    score: judgeCase.score,
    rank: index + 1,
    status: 0,
  }))

  return {
    problem: {
      ...problem,
      judgeMode: problem.judgeMode || 'default',
      judgeCaseMode: 'default',
      examples: JSON.stringify(examples.value.map(({ input, output }) => ({ input, output }))),
    },
    samples: normalizedJudgeCases,
    isUploadTestCase: false,
    judgeMode: problem.judgeMode || 'default',
    changeModeCode: false,
    changeJudgeCaseMode: originalJudgeCaseMode.value !== 'default',
    languages: toNameList(languagesText.value).map((name) => ({ name })),
    tags: selectedTags.value,
    codeTemplates: [],
  }
})

const load = async () => {
  if (!id.value || mode.value === 'contest-problem' && !route.params.problemId) {
    jsonText.value = JSON.stringify(defaultPayload(), null, 2)
    return
  }

  const cid = Number(route.params.contestId || 0)
  const response = mode.value === 'contest'
    ? await adminApi.getContest(id.value)
    : await adminApi.getProblem(Number(route.params.problemId), cid || undefined)

  if (isSuccess(response.data)) {
    if (isProblemMode.value) {
      applyProblem(response.data.data)
      await loadJudgeCases(Number(route.params.problemId))
    } else {
      jsonText.value = JSON.stringify(response.data.data, null, 2)
    }
  }
}

const loadLanguages = async () => {
  try {
    const response = await problemApi.getLanguages(false)
    if (!isSuccess(response.data) || !Array.isArray(response.data.data)) {
      return
    }
    const languageNames = response.data.data.map((item) => item.name).filter(Boolean) as string[]
    if (languageNames.length) {
      availableLanguages.value = languageNames
      if (!route.params.problemId) {
        languagesText.value = languageNames.join(',')
      }
    }
  } catch {
    availableLanguages.value = [...defaultLanguages]
  }
}

const loadTags = async () => {
  try {
    const response = await adminApi.getProblemTagsAndClassification('ME')
    if (isSuccess(response.data) && Array.isArray(response.data.data)) {
      tagGroups.value = response.data.data as Row[]
    }
  } catch {
    tagGroups.value = []
  }
}

const loadJudgeCases = async (pid: number) => {
  if (!pid) {
    return
  }
  try {
    const response = await adminApi.getProblemCases(pid, false)
    if (!isSuccess(response.data) || !Array.isArray(response.data.data)) {
      return
    }
    judgeCases.value = response.data.data.map((item: any) => ({
      id: item.id,
      input: item.input ?? '',
      output: item.output ?? '',
      score: item.score,
      groupNum: item.groupNum,
    }))
  } catch {
    judgeCases.value = []
  }
}

const applyProblem = (data: any) => {
  Object.assign(problem, data.problem ?? data)
  originalJudgeCaseMode.value = problem.judgeCaseMode || 'default'
  if (problem.examples) {
    try {
      const parsed = JSON.parse(problem.examples)
      if (Array.isArray(parsed)) {
        examples.value = parsed.map((item) => ({ input: item.input ?? '', output: item.output ?? '' }))
      }
    } catch {
      examples.value = []
    }
  }
  if (Array.isArray(data.languages)) {
    languagesText.value = data.languages.map((item: any) => item.name || item).filter(Boolean).join(',')
  }
  if (Array.isArray(data.tags)) {
    selectedTagIds.value = data.tags
      .map((item: any) => item.id ?? allTags.value.find((tag) => tag.name === item.name || tag.name === item)?.id)
      .map((id: unknown) => Number(id))
      .filter((id: number) => Number.isFinite(id))
  }
}

const defaultPayload = () => {
  if (mode.value === 'contest') {
    return {
      title: '',
      description: '',
      auth: 0,
      type: 0,
      startTime: '',
      endTime: '',
      duration: 0,
    }
  }
  return problemPayload.value
}

const addExample = () => {
  examples.value.push({ input: '', output: '' })
}

const removeExample = (index: number) => {
  examples.value.splice(index, 1)
}

const addJudgeCase = () => {
  judgeCases.value.push({ input: '', output: '' })
}

const removeJudgeCase = (index: number) => {
  judgeCases.value.splice(index, 1)
}

const save = async () => {
  saving.value = true
  message.value = ''
  try {
    if (isProblemMode.value && judgeCases.value.length === 0) {
      messageType.value = 'error'
      message.value = '至少需要添加一个判题测试点'
      return
    }
    const cid = Number(route.params.contestId || 0)
    const payload = isProblemMode.value ? problemPayload.value : JSON.parse(jsonText.value)
    const response = mode.value === 'contest'
      ? id.value ? await adminApi.updateContest(payload) : await adminApi.createContest(payload)
      : route.params.problemId ? await adminApi.updateProblem(payload, cid || undefined) : await adminApi.createProblem(payload, cid || undefined)

    if (isSuccess(response.data)) {
      messageType.value = 'success'
      message.value = '保存成功'
      if (!route.params.problemId && mode.value !== 'contest') {
        router.back()
      }
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '保存失败'
    }
  } catch (error: unknown) {
    messageType.value = 'error'
    message.value = error instanceof SyntaxError
      ? 'JSON 格式不正确'
      : (error as any)?.response?.data?.msg || (error as Error)?.message || '保存失败'
  } finally {
    saving.value = false
  }
}

onMounted(async () => {
  if (isProblemMode.value) {
    await Promise.all([loadLanguages(), loadTags()])
  }
  await load()
})
</script>

<style scoped>
.input {
  width: 100%;
  height: 2.5rem;
  border-radius: 0.5rem;
  border: 1px solid theme('colors.border');
  background: theme('colors.input');
  padding: 0 0.75rem;
  outline: none;
}

.input:focus,
.textarea:focus {
  box-shadow: 0 0 0 2px theme('colors.ring');
}

.textarea {
  width: 100%;
  border-radius: 0.5rem;
  border: 1px solid theme('colors.border');
  background: theme('colors.input');
  padding: 0.75rem;
  outline: none;
}
</style>
