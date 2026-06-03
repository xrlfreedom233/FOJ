<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <div class="flex flex-col lg:flex-row gap-6">
      <!-- Sidebar Filters -->
      <aside class="lg:w-64 flex-shrink-0">
        <Card>
          <template #header>
            <h2 class="font-semibold">筛选条件</h2>
          </template>

          <div class="space-y-4">
            <!-- Search -->
            <div>
              <label class="block text-sm text-muted-foreground mb-2">搜索题目</label>
              <input
                v-model="filters.keyword"
                type="text"
                placeholder="题目名称或编号"
                class="w-full h-9 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                @input="debouncedSearch"
              />
            </div>

            <!-- Difficulty -->
            <div>
              <label class="block text-sm text-muted-foreground mb-2">难度</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="diff in difficulties"
                  :key="diff.value"
                  @click="toggleDifficulty(diff.value)"
                  :class="[
                    'px-3 py-1 text-sm rounded-full transition-colors',
                    filters.difficulty === diff.value
                      ? 'bg-primary text-primary-foreground'
                      : 'bg-secondary hover:bg-secondary/80',
                  ]"
                >
                  {{ diff.label }}
                </button>
              </div>
            </div>

            <!-- Tags -->
            <div v-if="popularTags.length > 0">
              <label class="block text-sm text-muted-foreground mb-2">标签</label>
              <div class="flex flex-wrap gap-2">
                <button
                  v-for="tag in popularTags"
                  :key="tag.id"
                  @click="toggleTag(tag.id)"
                  :class="[
                    'px-2 py-1 text-xs rounded-full transition-colors',
                    filters.tagId === tag.id
                      ? 'bg-primary text-primary-foreground'
                      : 'bg-secondary hover:bg-secondary/80',
                  ]"
                >
                  {{ tag.name }}
                </button>
              </div>
            </div>

            <!-- Reset -->
            <button
              @click="resetFilters"
              class="w-full px-3 py-2 text-sm text-muted-foreground hover:text-foreground border border-border rounded-lg hover:bg-secondary transition-colors"
            >
              重置筛选
            </button>
          </div>
        </Card>
      </aside>

      <!-- Problem List -->
      <main class="flex-1">
        <Card no-padding>
          <template #header>
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <h1 class="text-xl font-bold">题目列表</h1>
              <div class="flex items-center gap-3">
                <span class="text-sm text-muted-foreground">共 {{ total }} 题</span>
                <Button variant="secondary" :loading="randomLoading" @click="goRandomProblem">随机一题</Button>
              </div>
            </div>
          </template>

          <Loading v-if="loading" />

          <div v-else-if="problems.length === 0">
            <Empty title="暂无题目" description="没有找到符合条件的题目" />
          </div>

          <div v-else>
            <!-- Table Header -->
            <div class="hidden md:grid problem-list-grid gap-4 px-6 py-3 bg-secondary/50 text-sm font-medium text-muted-foreground border-b border-border">
              <div>状态</div>
              <div>编号</div>
              <div>题目名称</div>
              <div>难度</div>
              <div>通过率</div>
            </div>

            <!-- Problem Items -->
            <RouterLink
              v-for="problem in problems"
              :key="problem.pid"
              :to="`/problem/${problem.problemId}`"
              class="grid problem-list-grid gap-4 px-6 py-4 items-center hover:bg-secondary/30 border-b border-border last:border-b-0 transition-colors"
            >
              <!-- Status -->
              <div>
                <span
                  v-if="problem.status === 1"
                  class="inline-flex items-center justify-center w-5 h-5 rounded-full bg-success/20"
                  title="已通过"
                >
                  <svg class="w-3 h-3 text-success" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                  </svg>
                </span>
                <span
                  v-else-if="problem.status === 2"
                  class="inline-flex items-center justify-center w-5 h-5 rounded-full bg-warning/20"
                  title="尝试过"
                >
                  <svg class="w-3 h-3 text-warning" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v3.586L7.707 9.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 10.586V7z" clip-rule="evenodd" />
                  </svg>
                </span>
                <span
                  v-else
                  class="inline-flex items-center justify-center w-5 h-5 text-xs text-muted-foreground"
                  title="未提交"
                >
                  -
                </span>
              </div>

              <!-- ID -->
              <div class="text-muted-foreground whitespace-nowrap font-mono text-sm">{{ problem.problemId }}</div>

              <!-- Title -->
              <div class="min-w-0">
                <span class="font-medium hover:text-primary transition-colors">{{ problem.title }}</span>
                <div class="flex flex-wrap gap-1 mt-1 md:hidden">
                  <Badge v-for="tag in problem.tags?.slice(0, 2)" :key="tag" variant="outline">
                    {{ tag }}
                  </Badge>
                </div>
              </div>

              <!-- Difficulty -->
              <div>
                <span :class="DIFFICULTY_CLASS[problem.difficulty]" class="font-medium">
                  {{ DIFFICULTY_TEXT[problem.difficulty] }}
                </span>
              </div>

              <!-- Accept Rate -->
              <div>
                <div class="flex items-center gap-2">
                  <div class="flex-1 h-2 bg-secondary rounded-full overflow-hidden">
                    <div
                      class="h-full bg-primary rounded-full transition-all"
                      :style="{ width: `${getAcceptRate(problem)}%` }"
                    ></div>
                  </div>
                  <span class="text-sm text-muted-foreground w-12">{{ getAcceptRate(problem) }}%</span>
                </div>
              </div>
            </RouterLink>
          </div>

          <template #footer>
            <div v-if="totalPages > 1" class="flex justify-center">
              <Pagination
                :current-page="currentPage"
                :total-pages="totalPages"
                @change="handlePageChange"
              />
            </div>
          </template>
        </Card>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { useDebounceFn } from '@vueuse/core'
import { problemApi, type ProblemQueryParams, type ProblemTag } from '@/api/problem'
import { getPageRecords, getPageTotal, isSuccess, mapProblem } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import type { Problem } from '@/types'
import { DIFFICULTY_TEXT, DIFFICULTY_CLASS } from '@/types'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import Pagination from '@/components/ui/Pagination.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const problems = ref<Problem[]>([])
const total = ref(0)
const loading = ref(false)
const randomLoading = ref(false)
const currentPage = ref(1)
const pageSize = 20
const popularTags = ref<Array<Required<Pick<ProblemTag, 'id' | 'name'>>>>([])

const filters = reactive<ProblemQueryParams>({
  keyword: '',
  difficulty: undefined,
  tagId: undefined,
})

const difficulties = [
  { value: 0, label: '简单' },
  { value: 1, label: '中等' },
  { value: 2, label: '困难' },
]

const totalPages = computed(() => Math.ceil(total.value / pageSize))

const getAcceptRate = (problem: Problem) => {
  if (problem.submit_count === 0) return 0
  return Math.round((problem.accept_count / problem.submit_count) * 100)
}

const applyUserProblemStatus = async () => {
  if (!userStore.isLoggedIn || problems.value.length === 0) return
  const response = await problemApi.getUserProblemStatus(problems.value.map((problem) => problem.pid))
  if (!isSuccess(response.data)) return
  problems.value = problems.value.map((problem) => {
    const status = response.data.data[String(problem.pid)]?.status
    return {
      ...problem,
      status: status === 0 ? 1 : status === -10 || status === undefined ? 0 : 2,
    }
  })
}

const fetchProblems = async () => {
  loading.value = true
  try {
    const params: ProblemQueryParams = {
      page: currentPage.value,
      page_size: pageSize,
      ...filters,
    }
    
    // Remove undefined values
    Object.keys(params).forEach(key => {
      if (params[key as keyof ProblemQueryParams] === undefined || params[key as keyof ProblemQueryParams] === '') {
        delete params[key as keyof ProblemQueryParams]
      }
    })

    const response = await problemApi.getList(params)
    if (isSuccess(response.data)) {
      problems.value = getPageRecords(response.data.data).map(mapProblem)
      total.value = getPageTotal(response.data.data)
      await applyUserProblemStatus()
    } else {
      problems.value = []
      total.value = 0
    }
  } catch {
    problems.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const fetchTags = async () => {
  try {
    const response = await problemApi.getTags()
    if (!isSuccess(response.data) || !Array.isArray(response.data.data)) {
      popularTags.value = []
      return
    }

    const tagMap = new Map<number, string>()
    response.data.data.forEach((tag) => {
      if (tag?.id && tag.name) tagMap.set(tag.id, tag.name)
    })
    popularTags.value = Array.from(tagMap, ([id, name]) => ({ id, name }))
  } catch {
    popularTags.value = []
  }
}

const goRandomProblem = async () => {
  randomLoading.value = true
  try {
    const response = await problemApi.getRandomProblem()
    if (isSuccess(response.data) && response.data.data?.problemId) {
      router.push(`/problem/${response.data.data.problemId}`)
    }
  } finally {
    randomLoading.value = false
  }
}

const toggleDifficulty = (value: number) => {
  filters.difficulty = filters.difficulty === value ? undefined : value
  currentPage.value = 1
  updateRoute()
}

const toggleTag = (tagId: number) => {
  filters.tagId = filters.tagId === tagId ? undefined : tagId
  currentPage.value = 1
  updateRoute()
}

const resetFilters = () => {
  filters.keyword = ''
  filters.difficulty = undefined
  filters.tagId = undefined
  currentPage.value = 1
  updateRoute()
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  updateRoute()
}

const updateRoute = () => {
  const query: Record<string, string> = {}
  if (currentPage.value > 1) query.page = String(currentPage.value)
  if (filters.keyword) query.keyword = filters.keyword
  if (filters.difficulty !== undefined) query.difficulty = String(filters.difficulty)
  if (filters.tagId) query.tagId = String(filters.tagId)
  
  router.push({ query })
}

const debouncedSearch = useDebounceFn(() => {
  currentPage.value = 1
  updateRoute()
}, 300)

// Initialize from route
onMounted(() => {
  if (route.query.page) currentPage.value = Number(route.query.page)
  if (route.query.keyword) filters.keyword = String(route.query.keyword)
  if (route.query.difficulty) filters.difficulty = Number(route.query.difficulty)
  fetchTags().then(() => {
    if (route.query.tagId) {
      filters.tagId = Number(route.query.tagId)
    } else if (route.query.tag) {
      const tag = popularTags.value.find((item) => item.name === String(route.query.tag))
      filters.tagId = tag?.id
    }
    fetchProblems()
  })
})

watch(
  () => route.query,
  () => {
    fetchProblems()
  }
)
</script>

<style scoped>
.problem-list-grid {
  grid-template-columns: 64px 100px minmax(220px, 1fr) 96px 288px;
}

@media (max-width: 767px) {
  .problem-list-grid {
    grid-template-columns: 32px minmax(0, 1fr) 72px;
  }

  .problem-list-grid > :nth-child(2),
  .problem-list-grid > :nth-child(5) {
    display: none;
  }
}
</style>
