<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <Card no-padding>
      <template #header>
        <div class="flex items-center justify-between">
          <h1 class="text-xl font-bold">提交记录</h1>
          <div class="flex items-center gap-4">
            <!-- Filters -->
            <select
              v-model="filters.status"
              @change="handleFilterChange"
              class="px-3 py-1.5 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
            >
              <option value="">全部状态</option>
              <option value="0">Accepted</option>
              <option value="-1">Wrong Answer</option>
              <option value="1">TLE</option>
              <option value="2">MLE</option>
              <option value="3">RE</option>
              <option value="-2">CE</option>
              <option value="5">Pending</option>
              <option value="6">Compiling</option>
              <option value="7">Judging</option>
            </select>

            <select
              v-model="filters.language"
              @change="handleFilterChange"
              class="px-3 py-1.5 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
            >
              <option value="">全部语言</option>
              <option v-for="lang in LANGUAGES" :key="lang.value" :value="lang.value">
                {{ lang.label }}
              </option>
            </select>
          </div>
        </div>
      </template>

      <Loading v-if="loading" />

      <div v-else-if="submissions.length === 0">
        <Empty title="暂无提交记录" description="快去刷题吧！">
          <RouterLink
            to="/problems"
            class="mt-4 inline-block px-4 py-2 bg-primary text-primary-foreground rounded-lg"
          >
            去刷题
          </RouterLink>
        </Empty>
      </div>

      <div v-else>
        <!-- Table Header -->
        <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 bg-secondary/50 text-sm font-medium text-muted-foreground border-b border-border">
          <div class="col-span-1">编号</div>
          <div class="col-span-3">题目</div>
          <div class="col-span-2">状态</div>
          <div class="col-span-1">语言</div>
          <div class="col-span-1">时间</div>
          <div class="col-span-1">内存</div>
          <div class="col-span-2">用户</div>
          <div class="col-span-1">提交时间</div>
        </div>

        <!-- Submission Items -->
        <RouterLink
          v-for="submission in submissions"
          :key="submission.sid"
          :to="`/submission/${submission.sid}`"
          class="grid grid-cols-12 gap-4 px-6 py-4 items-center hover:bg-secondary/30 border-b border-border last:border-b-0 transition-colors"
        >
          <!-- ID -->
          <div class="col-span-1 text-muted-foreground text-sm">
            #{{ submission.sid }}
          </div>

          <!-- Problem -->
          <div class="col-span-3">
            <span class="text-muted-foreground text-sm mr-2">#{{ submission.problemId }}</span>
            <span class="font-medium">{{ submission.problem_title }}</span>
          </div>

          <!-- Status -->
          <div class="col-span-2">
            <span
              :class="SUBMISSION_STATUS_CLASS[submission.status]"
              class="font-medium text-sm"
            >
              {{ SUBMISSION_STATUS_TEXT[submission.status] }}
            </span>
          </div>

          <!-- Language -->
          <div class="col-span-1 text-sm">
            {{ getLanguageLabel(submission.language) }}
          </div>

          <!-- Time -->
          <div class="col-span-1 text-sm text-muted-foreground">
            {{ submission.status === 0 ? `${submission.time_cost}ms` : '-' }}
          </div>

          <!-- Memory -->
          <div class="col-span-1 text-sm text-muted-foreground">
            {{ submission.status === 0 ? `${submission.memory_cost}KB` : '-' }}
          </div>

          <!-- User -->
          <div class="col-span-2 text-sm">
            {{ submission.username }}
          </div>

          <!-- Time -->
          <div class="col-span-1 text-sm text-muted-foreground">
            {{ formatTime(submission.create_time) }}
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { submissionApi, type SubmissionQueryParams } from '@/api/submission'
import { getPageRecords, getPageTotal, isSuccess, mapSubmission } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import type { Submission } from '@/types'
import { SUBMISSION_STATUS_TEXT, SUBMISSION_STATUS_CLASS, LANGUAGES } from '@/types'
import Card from '@/components/ui/Card.vue'
import Pagination from '@/components/ui/Pagination.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/zh-cn'

dayjs.extend(relativeTime)
dayjs.locale('zh-cn')

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const submissions = ref<Submission[]>([])
const total = ref(0)
const loading = ref(false)
const currentPage = ref(1)
const pageSize = 20

const filters = reactive<SubmissionQueryParams>({
  status: undefined,
  language: undefined,
})

const totalPages = computed(() => Math.ceil(total.value / pageSize))

const getLanguageLabel = (lang: string) => {
  return LANGUAGES.find(l => l.value === lang)?.label || lang
}

const formatTime = (time: string) => {
  return dayjs(time).fromNow()
}

const fetchSubmissions = async () => {
  loading.value = true
  try {
    const params: SubmissionQueryParams = {
      page: currentPage.value,
      page_size: pageSize,
    }

    // Check if viewing own submissions
    if (route.query.mine === '1' && userStore.user) {
      params.uid = userStore.user.uid
    }

    if (filters.status !== undefined && filters.status !== null && String(filters.status) !== '') {
      params.status = Number(filters.status)
    }
    if (filters.language) params.language = filters.language

    const response = await submissionApi.getList(params)
    if (isSuccess(response.data)) {
      submissions.value = getPageRecords(response.data.data).map(mapSubmission)
      total.value = getPageTotal(response.data.data)
    } else {
      submissions.value = []
      total.value = 0
    }
  } catch {
    submissions.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  currentPage.value = 1
  updateRoute()
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  updateRoute()
}

const updateRoute = () => {
  const query: Record<string, string> = {}
  if (route.query.mine) query.mine = '1'
  if (currentPage.value > 1) query.page = String(currentPage.value)
  if (filters.status !== undefined && filters.status !== null && String(filters.status) !== '') {
    query.status = String(filters.status)
  }
  if (filters.language) query.language = filters.language

  router.push({ query })
}

onMounted(() => {
  if (route.query.page) currentPage.value = Number(route.query.page)
  if (route.query.status) filters.status = Number(route.query.status)
  if (route.query.language) filters.language = String(route.query.language)
  fetchSubmissions()
})

watch(
  () => route.query,
  () => {
    fetchSubmissions()
  }
)
</script>
