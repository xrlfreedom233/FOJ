<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <h1 class="text-2xl font-bold">比赛列表</h1>

      <!-- Filters -->
      <div class="flex items-center gap-4">
        <div class="flex rounded-lg border border-border overflow-hidden">
          <button
            v-for="tab in statusTabs"
            :key="tab.value"
            @click="filters.status = tab.value; fetchContests()"
            :class="[
              'px-4 py-2 text-sm font-medium transition-colors',
              filters.status === tab.value
                ? 'bg-primary text-primary-foreground'
                : 'bg-card hover:bg-secondary',
            ]"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>
    </div>

    <Loading v-if="loading" />

    <div v-else-if="contests.length === 0">
      <Empty title="暂无比赛" description="敬请期待更多精彩比赛" />
    </div>

    <div v-else class="space-y-4">
      <Card
        v-for="contest in contests"
        :key="contest.cid"
        hover
        @click="$router.push(`/contest/${contest.cid}`)"
      >
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div class="flex-1">
            <div class="flex items-center gap-3 mb-2">
              <Badge :variant="getStatusVariant(contest.status)">
                {{ getStatusText(contest.status) }}
              </Badge>
              <Badge v-if="contest.type === 1" variant="warning">私有</Badge>
              <Badge v-else-if="contest.type === 2" variant="outline">保护</Badge>
            </div>
            <h2 class="text-xl font-semibold mb-2">{{ contest.title }}</h2>
            <p class="text-muted-foreground text-sm line-clamp-2">{{ contest.description }}</p>
          </div>

          <div class="flex flex-col gap-2 text-sm md:text-right md:min-w-[200px]">
            <div>
              <span class="text-muted-foreground">开始时间: </span>
              <span>{{ formatTime(contest.start_time) }}</span>
            </div>
            <div>
              <span class="text-muted-foreground">结束时间: </span>
              <span>{{ formatTime(contest.end_time) }}</span>
            </div>
            <div>
              <span class="text-muted-foreground">参赛人数: </span>
              <span class="text-primary font-medium">{{ contest.participant_count }}</span>
            </div>
          </div>
        </div>

        <!-- Progress Bar for Running Contest -->
        <div v-if="contest.status === 1" class="mt-4">
          <div class="flex items-center justify-between text-sm mb-1">
            <span class="text-muted-foreground">比赛进度</span>
            <span class="text-primary">{{ getContestProgress(contest) }}%</span>
          </div>
          <div class="h-2 bg-secondary rounded-full overflow-hidden">
            <div
              class="h-full bg-primary rounded-full transition-all"
              :style="{ width: `${getContestProgress(contest)}%` }"
            ></div>
          </div>
        </div>
      </Card>
    </div>

    <div v-if="totalPages > 1" class="mt-8 flex justify-center">
      <Pagination
        :current-page="currentPage"
        :total-pages="totalPages"
        @change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { contestApi, type ContestQueryParams } from '@/api/contest'
import { getPageRecords, getPageTotal, isSuccess, mapContest } from '@/api/adapter'
import type { Contest } from '@/types'
import Card from '@/components/ui/Card.vue'
import Badge from '@/components/ui/Badge.vue'
import Pagination from '@/components/ui/Pagination.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import dayjs from 'dayjs'

const contests = ref<Contest[]>([])
const total = ref(0)
const loading = ref(false)
const currentPage = ref(1)
const pageSize = 10

const filters = reactive<ContestQueryParams>({
  status: undefined,
})

const statusTabs = [
  { value: undefined, label: '全部' },
  { value: 1, label: '进行中' },
  { value: 0, label: '未开始' },
  { value: 2, label: '已结束' },
]

const totalPages = computed(() => Math.ceil(total.value / pageSize))

const getStatusText = (status: number) => {
  switch (status) {
    case 0: return '未开始'
    case 1: return '进行中'
    case 2: return '已结束'
    default: return '未知'
  }
}

const getStatusVariant = (status: number): 'default' | 'primary' | 'success' | 'warning' | 'destructive' | 'outline' => {
  switch (status) {
    case 0: return 'warning'
    case 1: return 'success'
    case 2: return 'default'
    default: return 'outline'
  }
}

const formatTime = (time: string) => {
  return dayjs(time).format('YYYY-MM-DD HH:mm')
}

const getContestProgress = (contest: Contest) => {
  const now = Date.now()
  const start = new Date(contest.start_time).getTime()
  const end = new Date(contest.end_time).getTime()
  const progress = ((now - start) / (end - start)) * 100
  return Math.min(Math.max(progress, 0), 100).toFixed(0)
}

const fetchContests = async () => {
  loading.value = true
  try {
    const params: ContestQueryParams = {
      page: currentPage.value,
      page_size: pageSize,
      ...filters,
    }

    const response = await contestApi.getList(params)
    if (isSuccess(response.data)) {
      contests.value = getPageRecords(response.data.data).map(mapContest)
      total.value = getPageTotal(response.data.data)
    } else {
      contests.value = []
      total.value = 0
    }
  } catch {
    contests.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  fetchContests()
}

onMounted(fetchContests)
</script>
