<template>
  <div class="min-h-[calc(100vh-4rem)]">
    <!-- Hero Section -->
    <section class="relative py-20 px-4 overflow-hidden">
      <div class="absolute inset-0 bg-gradient-to-br from-primary/10 via-transparent to-accent/10"></div>
      <div class="relative max-w-7xl mx-auto text-center">
        <h1 class="text-4xl sm:text-5xl lg:text-6xl font-bold mb-6">
          <span class="gradient-text">FOJ</span>
          <span class="text-foreground"> 在线判题系统</span>
        </h1>
        <p class="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
          提升编程能力，挑战算法极限。海量题库，实时判题，公平竞技。
        </p>
        <div class="flex flex-wrap justify-center gap-4">
          <RouterLink
            to="/problems"
            class="px-8 py-3 bg-primary text-primary-foreground font-medium rounded-lg hover:bg-primary/90 transition-colors"
          >
            开始刷题
          </RouterLink>
          <RouterLink
            to="/contests"
            class="px-8 py-3 bg-secondary text-foreground font-medium rounded-lg hover:bg-secondary/80 transition-colors"
          >
            参加比赛
          </RouterLink>
        </div>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="py-16 px-4 bg-card/50">
      <div class="max-w-7xl mx-auto">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div v-for="stat in stats" :key="stat.label" class="text-center">
            <div class="text-3xl sm:text-4xl font-bold text-primary mb-2">{{ stat.value }}</div>
            <div class="text-muted-foreground">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="py-16 px-4">
      <div class="max-w-7xl mx-auto">
        <h2 class="text-3xl font-bold text-center mb-12">平台特色</h2>
        <div class="grid md:grid-cols-3 gap-8">
          <div
            v-for="feature in features"
            :key="feature.title"
            class="p-6 bg-card border border-border rounded-xl hover:border-primary/50 transition-colors"
          >
            <div class="w-12 h-12 bg-primary/20 rounded-lg flex items-center justify-center mb-4">
              <component :is="feature.icon" class="w-6 h-6 text-primary" />
            </div>
            <h3 class="text-xl font-semibold mb-2">{{ feature.title }}</h3>
            <p class="text-muted-foreground">{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Recent Problems -->
    <section class="py-16 px-4 bg-card/50">
      <div class="max-w-7xl mx-auto">
        <div class="flex items-center justify-between mb-8">
          <h2 class="text-2xl font-bold">最新题目</h2>
          <RouterLink to="/problems" class="text-primary hover:underline">
            查看全部 &rarr;
          </RouterLink>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <RouterLink
            v-for="problem in recentProblems"
            :key="problem.pid"
            :to="`/problem/${problem.problemId}`"
            class="p-4 bg-card border border-border rounded-lg hover:border-primary/50 transition-colors"
          >
            <div class="flex items-start justify-between mb-2">
              <span class="text-muted-foreground text-sm">#{{ problem.problemId }}</span>
              <span :class="DIFFICULTY_CLASS[problem.difficulty]" class="text-sm font-medium">
                {{ DIFFICULTY_TEXT[problem.difficulty] }}
              </span>
            </div>
            <h3 class="font-medium mb-2 line-clamp-1">{{ problem.title }}</h3>
            <div class="flex items-center gap-4 text-sm text-muted-foreground">
              <span>通过率: {{ getAcceptRate(problem) }}%</span>
            </div>
          </RouterLink>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="py-8 px-4 border-t border-border">
      <div class="max-w-7xl mx-auto text-center text-muted-foreground">
        <p>&copy; 2026 FOJ Online Judge. All rights reserved.</p>
      </div>
    </footer>

    <button
      v-if="announcements.length"
      type="button"
      class="fixed right-6 bottom-6 z-40 h-11 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium shadow-lg hover:bg-primary/90 transition-colors"
      @click="openAnnouncements"
    >
      公告
    </button>

    <div
      v-if="showAnnouncementModal && activeAnnouncement"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4"
      @click.self="closeAnnouncements"
    >
      <div class="w-full max-w-2xl bg-card border border-border rounded-lg shadow-xl overflow-hidden">
        <div class="flex items-center justify-between px-5 py-4 border-b border-border">
          <div>
            <h2 class="text-lg font-semibold">站点公告</h2>
            <p class="text-xs text-muted-foreground mt-1">
              {{ activeAnnouncement.username || '管理员' }} · {{ formatTime(activeAnnouncement.gmtCreate || activeAnnouncement.gmtModified || '') }}
            </p>
          </div>
          <button
            type="button"
            class="w-8 h-8 inline-flex items-center justify-center rounded-md text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
            @click="closeAnnouncements"
          >
            ×
          </button>
        </div>

        <div
          :class="[
            'grid min-h-80 max-h-[70vh]',
            announcements.length > 1 ? 'md:grid-cols-[180px_1fr]' : 'grid-cols-1',
          ]"
        >
          <div v-if="announcements.length > 1" class="border-r border-border bg-secondary/30 p-2 overflow-y-auto">
            <button
              v-for="(announcement, index) in announcements"
              :key="announcement.id"
              type="button"
              :class="[
                'w-full text-left px-3 py-2 rounded-md text-sm transition-colors',
                activeAnnouncementIndex === index ? 'bg-primary text-primary-foreground' : 'hover:bg-secondary',
              ]"
              @click="activeAnnouncementIndex = index"
            >
              <span class="block truncate">{{ announcement.title }}</span>
            </button>
          </div>

          <article class="p-5 overflow-y-auto">
            <h3 class="text-xl font-bold mb-4">{{ activeAnnouncement.title }}</h3>
            <div
              class="text-sm leading-7 text-muted-foreground break-words"
              v-html="formatAnnouncement(activeAnnouncement.content)"
            ></div>
          </article>
        </div>

        <div class="flex flex-wrap items-center justify-end gap-3 px-5 py-4 border-t border-border bg-secondary/20">
          <button
            type="button"
            class="px-3 py-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors"
            @click="closeAnnouncements"
          >
            关闭
          </button>
          <button
            type="button"
            class="px-3 py-1.5 text-sm bg-secondary text-foreground rounded-md hover:bg-secondary/80 transition-colors"
            @click="closeAnnouncementsForSession"
          >
            本次登录不再提示
          </button>
          <button
            type="button"
            class="px-3 py-1.5 text-sm bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
            @click="closeAnnouncementsForToday"
          >
            今日不再提示
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, h } from 'vue'
import { RouterLink } from 'vue-router'
import { problemApi } from '@/api/problem'
import { homeApi, type Announcement } from '@/api/home'
import { getPageRecords, isSuccess, mapProblem } from '@/api/adapter'
import type { Problem } from '@/types'
import { DIFFICULTY_TEXT, DIFFICULTY_CLASS } from '@/types'
import dayjs from 'dayjs'

const recentProblems = ref<Problem[]>([])
const announcements = ref<Announcement[]>([])
const showAnnouncementModal = ref(false)
const activeAnnouncementIndex = ref(0)
const ANNOUNCEMENT_SESSION_KEY = 'foj-announcement-dismissed-session'
const ANNOUNCEMENT_TODAY_KEY = 'foj-announcement-dismissed-date'

const activeAnnouncement = computed(() => announcements.value[activeAnnouncementIndex.value])

const stats = [
  { value: '1000+', label: '题目数量' },
  { value: '50000+', label: '提交次数' },
  { value: '10000+', label: '注册用户' },
  { value: '100+', label: '比赛场次' },
]

const CodeIcon = () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
  h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4' })
])

const TrophyIcon = () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
  h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' })
])

const ChartIcon = () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
  h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z' })
])

const features = [
  {
    title: '海量题库',
    description: '覆盖各类算法和数据结构，从入门到进阶，循序渐进提升编程能力。',
    icon: CodeIcon,
  },
  {
    title: '实时判题',
    description: '毫秒级判题响应，支持多种编程语言，即时反馈代码运行结果。',
    icon: TrophyIcon,
  },
  {
    title: '竞技排名',
    description: '参与在线比赛，与全球选手同台竞技，实时更新排名积分。',
    icon: ChartIcon,
  },
]

const getAcceptRate = (problem: Problem) => {
  if (problem.submit_count === 0) return 0
  return Math.round((problem.accept_count / problem.submit_count) * 100)
}

const formatAnnouncement = (content: string) => {
  if (!content) return ''
  return content.replace(/\n/g, '<br>')
}

const formatTime = (time: string) => {
  if (!time) return '刚刚'
  return dayjs(time).format('YYYY-MM-DD')
}

const fetchRecentProblems = async () => {
  try {
    const response = await problemApi.getList({ page: 1, page_size: 6 })
    if (isSuccess(response.data)) {
      recentProblems.value = getPageRecords(response.data.data).map(mapProblem)
    } else {
      recentProblems.value = []
    }
  } catch {
    recentProblems.value = []
  }
}

const fetchAnnouncements = async () => {
  try {
    const response = await homeApi.getCommonAnnouncements({ page: 1, page_size: 3 })
    if (isSuccess(response.data)) {
      announcements.value = getPageRecords(response.data.data) as Announcement[]
      announcements.value = announcements.value.slice(0, 3)
      showAnnouncementModal.value = announcements.value.length > 0 && shouldAutoShowAnnouncements()
    } else {
      announcements.value = []
    }
  } catch {
    announcements.value = []
  }
}

const shouldAutoShowAnnouncements = () => {
  const today = dayjs().format('YYYY-MM-DD')
  return sessionStorage.getItem(ANNOUNCEMENT_SESSION_KEY) !== '1'
    && localStorage.getItem(ANNOUNCEMENT_TODAY_KEY) !== today
}

const openAnnouncements = () => {
  activeAnnouncementIndex.value = 0
  showAnnouncementModal.value = true
}

const closeAnnouncements = () => {
  showAnnouncementModal.value = false
}

const closeAnnouncementsForSession = () => {
  sessionStorage.setItem(ANNOUNCEMENT_SESSION_KEY, '1')
  closeAnnouncements()
}

const closeAnnouncementsForToday = () => {
  localStorage.setItem(ANNOUNCEMENT_TODAY_KEY, dayjs().format('YYYY-MM-DD'))
  closeAnnouncements()
}

onMounted(async () => {
  await Promise.all([
    fetchRecentProblems(),
    fetchAnnouncements(),
  ])
})
</script>
