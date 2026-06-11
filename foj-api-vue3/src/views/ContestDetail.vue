<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <Loading v-if="loading" />

    <div v-else-if="contest" class="space-y-6">
      <!-- Header -->
      <Card>
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          <div>
            <div class="flex items-center gap-3 mb-3">
              <Badge :variant="getStatusVariant(contest.status)" class="text-sm">
                {{ getStatusText(contest.status) }}
              </Badge>
              <span class="text-muted-foreground">#{{ contest.cid }}</span>
            </div>
            <h1 class="text-2xl font-bold mb-2">{{ contest.title }}</h1>
            <p class="text-muted-foreground">{{ contest.description }}</p>
          </div>

          <div class="flex flex-col gap-2 lg:text-right lg:min-w-[220px]">
            <div class="text-sm">
              <span class="text-muted-foreground">开始: </span>
              <span class="font-medium">{{ formatTime(contest.start_time) }}</span>
            </div>
            <div class="text-sm">
              <span class="text-muted-foreground">结束: </span>
              <span class="font-medium">{{ formatTime(contest.end_time) }}</span>
            </div>
            <div class="text-sm">
              <span class="text-muted-foreground">时长: </span>
              <span class="font-medium">{{ getDuration(contest) }}</span>
            </div>
            <div class="text-sm">
              <span class="text-muted-foreground">参赛人数: </span>
              <span class="font-medium text-primary">{{ contest.participant_count }}</span>
            </div>
          </div>
        </div>

        <!-- Countdown / Progress -->
        <div class="mt-6 pt-6 border-t border-border">
          <div v-if="contest.status === 0" class="text-center">
            <div class="text-muted-foreground mb-2">距离开始还有</div>
            <div class="text-3xl font-bold text-warning">{{ countdown }}</div>
          </div>
          <div v-else-if="contest.status === 1">
            <div class="flex items-center justify-between text-sm mb-2">
              <span class="text-muted-foreground">比赛进度</span>
              <span>剩余时间: {{ countdown }}</span>
            </div>
            <div class="h-3 bg-secondary rounded-full overflow-hidden">
              <div
                class="h-full bg-primary rounded-full transition-all"
                :style="{ width: `${progress}%` }"
              ></div>
            </div>
          </div>
          <div v-else class="text-center text-muted-foreground">
            比赛已结束
          </div>
        </div>
      </Card>

      <div
        v-if="latestSubmission"
        class="rounded-lg border px-4 py-3"
        :class="latestSubmission.status === 0 ? 'border-success/30 bg-success/10' : isPendingStatus(latestSubmission.status) ? 'border-border bg-card' : 'border-destructive/30 bg-destructive/10'"
      >
        <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <div class="text-sm text-muted-foreground">本次提交结果</div>
            <div class="mt-1 flex flex-wrap items-center gap-2">
              <span class="font-mono text-sm">#{{ latestSubmission.submitId }}</span>
              <span
                :class="SUBMISSION_STATUS_CLASS[latestSubmission.status] || 'status-pending'"
                class="font-semibold"
              >
                {{ SUBMISSION_STATUS_TEXT[latestSubmission.status] || 'Unknown' }}
              </span>
              <span v-if="latestSubmission.problemId" class="text-sm text-muted-foreground">
                {{ latestSubmission.problemId }}
              </span>
            </div>
          </div>
          <RouterLink
            :to="`/submission/${latestSubmission.submitId}`"
            class="text-sm text-primary hover:underline"
          >
            查看详情
          </RouterLink>
        </div>
      </div>

      <Card v-if="showRegisterCard">
        <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
          <div>
            <h2 class="text-lg font-semibold">{{ registerCardTitle }}</h2>
            <p class="mt-1 text-sm text-muted-foreground">
              {{ registerCardDescription }}
            </p>
            <p v-if="accessMessage" class="mt-2 text-sm" :class="accessMessageType === 'error' ? 'text-destructive' : 'text-success'">
              {{ accessMessage }}
            </p>
          </div>
          <div class="grid w-full gap-2 md:max-w-md" :class="contestRequiresPassword ? 'sm:grid-cols-[minmax(0,1fr)_96px]' : 'sm:grid-cols-[96px]'">
            <input
              v-if="contestRequiresPassword"
              v-model="contestPassword"
              type="password"
              class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              placeholder="比赛密码"
              @keyup.enter="registerContest"
            />
            <Button :loading="registering" @click="registerContest">{{ registerButtonText }}</Button>
          </div>
        </div>
      </Card>

      <!-- Tabs -->
      <div class="flex gap-2 border-b border-border">
        <button
          v-for="tab in tabs"
          :key="tab.value"
          @click="activeTab = tab.value"
          :disabled="!hasContestAccess && tab.value !== 'announcements'"
          :class="[
            'px-4 py-3 text-sm font-medium border-b-2 -mb-px transition-colors',
            activeTab === tab.value
              ? 'border-primary text-primary'
              : 'border-transparent text-muted-foreground hover:text-foreground',
            !hasContestAccess && tab.value !== 'announcements' ? 'cursor-not-allowed opacity-50 hover:text-muted-foreground' : '',
          ]"
        >
          {{ tab.label }}
        </button>
      </div>

      <!-- Problems Tab -->
      <Card v-if="activeTab === 'problems'" no-padding>
        <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 bg-secondary/50 text-sm font-medium text-muted-foreground border-b border-border">
          <div class="col-span-1">序号</div>
          <div class="col-span-6">题目名称</div>
          <div class="col-span-2">通过数</div>
          <div class="col-span-3">通过率</div>
        </div>

        <RouterLink
          v-for="problem in contest.problems"
          :key="problem.index"
          :to="`/contest/${contest.cid}/problem/${problem.index}`"
          class="grid grid-cols-12 gap-4 px-6 py-4 items-center hover:bg-secondary/30 border-b border-border last:border-b-0 transition-colors"
        >
          <div class="col-span-1 font-mono font-bold text-primary">{{ problem.index }}</div>
          <div class="col-span-6 font-medium">{{ problem.title }}</div>
          <div class="col-span-2 text-sm text-muted-foreground">
            {{ problem.accept_count }} / {{ problem.submit_count }}
          </div>
          <div class="col-span-3">
            <div class="flex items-center gap-2">
              <div class="flex-1 h-2 bg-secondary rounded-full overflow-hidden">
                <div
                  class="h-full bg-primary rounded-full"
                  :style="{ width: `${getAcceptRate(problem)}%` }"
                ></div>
              </div>
              <span class="text-sm text-muted-foreground w-12">{{ getAcceptRate(problem) }}%</span>
            </div>
          </div>
        </RouterLink>

        <div v-if="!contest.problems?.length" class="p-8">
          <Empty title="暂无题目" description="比赛题目将在开始后公布" />
        </div>
      </Card>

      <!-- Rank Tab -->
      <Card v-if="activeTab === 'rank'" no-padding>
        <div class="hidden md:grid gap-4 px-6 py-3 bg-secondary/50 text-sm font-medium text-muted-foreground border-b border-border"
          :style="{ gridTemplateColumns: `60px 200px 100px 80px repeat(${contest.problems?.length || 0}, 1fr)` }"
        >
          <div>排名</div>
          <div>选手</div>
          <div>总罚时</div>
          <div>通过</div>
          <div v-for="problem in contest.problems" :key="problem.index" class="text-center">
            {{ problem.index }}
          </div>
        </div>

        <div
          v-for="user in rankList"
          :key="user.uid"
          class="grid gap-4 px-6 py-3 items-center border-b border-border last:border-b-0 hover:bg-secondary/30 transition-colors"
          :style="{ gridTemplateColumns: `60px 200px 100px 80px repeat(${contest.problems?.length || 0}, 1fr)` }"
        >
          <div>
            <span
              :class="[
                'inline-flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold',
                user.rank === 1 ? 'bg-yellow-500/20 text-yellow-500' :
                user.rank === 2 ? 'bg-gray-400/20 text-gray-400' :
                user.rank === 3 ? 'bg-amber-600/20 text-amber-600' :
                'bg-secondary text-muted-foreground',
              ]"
            >
              {{ user.rank }}
            </span>
          </div>
          <div class="font-medium">{{ user.nickname || user.username }}</div>
          <div class="text-sm text-muted-foreground">{{ formatPenalty(user.total_time) }}</div>
          <div class="font-bold text-primary">{{ user.solved }}</div>
          <div
            v-for="prob in user.problems"
            :key="prob.index"
            class="text-center"
          >
            <div
              v-if="prob.status === 2"
              class="text-success text-sm"
            >
              <div class="font-medium">{{ formatPenalty(prob.time) }}</div>
              <div class="text-xs" v-if="prob.try_count > 1">(-{{ prob.try_count - 1 }})</div>
            </div>
            <div
              v-else-if="prob.try_count > 0"
              class="text-destructive text-sm"
            >
              (-{{ prob.try_count }})
            </div>
            <div v-else class="text-muted-foreground">-</div>
          </div>
        </div>

        <div v-if="rankList.length === 0" class="p-8">
          <Empty title="暂无排名数据" description="比赛开始后将显示排名" />
        </div>
      </Card>

      <!-- Announcements Tab -->
      <Card v-if="activeTab === 'announcements'" no-padding>
        <div v-if="announcementList.length" class="divide-y divide-border">
          <article v-for="announcement in announcementList" :key="announcement.id" class="p-6">
            <div class="flex flex-col gap-2 md:flex-row md:items-start md:justify-between">
              <h2 class="text-lg font-semibold">{{ announcement.title }}</h2>
              <span class="text-sm text-muted-foreground">{{ formatTime(announcement.gmtCreate || announcement.gmtModified) }}</span>
            </div>
            <p class="mt-3 whitespace-pre-wrap text-sm leading-6 text-muted-foreground">{{ announcement.content }}</p>
          </article>
        </div>
        <div v-else class="p-8">
          <Empty title="暂无公告" description="比赛公告将在这里显示" />
        </div>
      </Card>

      <!-- Submissions Tab -->
      <Card v-if="activeTab === 'submissions'" no-padding>
        <Loading v-if="submissionLoading" />

        <div v-else-if="submissionList.length" class="overflow-x-auto">
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

          <RouterLink
            v-for="submission in submissionList"
            :key="submission.sid"
            :to="`/submission/${submission.sid}`"
            class="grid grid-cols-12 gap-4 px-6 py-4 items-center hover:bg-secondary/30 border-b border-border last:border-b-0 transition-colors"
          >
            <div class="col-span-1 text-sm text-muted-foreground">#{{ submission.sid }}</div>
            <div class="col-span-3 min-w-0">
              <span class="mr-2 text-sm text-muted-foreground">#{{ submission.problemId }}</span>
              <span class="font-medium">{{ submission.problem_title }}</span>
            </div>
            <div class="col-span-2">
              <span :class="SUBMISSION_STATUS_CLASS[submission.status] || 'status-pending'" class="text-sm font-medium">
                {{ SUBMISSION_STATUS_TEXT[submission.status] || 'Unknown' }}
              </span>
            </div>
            <div class="col-span-1 text-sm">{{ submission.language }}</div>
            <div class="col-span-1 text-sm text-muted-foreground">
              {{ submission.status === 0 ? `${submission.time_cost}ms` : '-' }}
            </div>
            <div class="col-span-1 text-sm text-muted-foreground">
              {{ submission.status === 0 ? `${submission.memory_cost}KB` : '-' }}
            </div>
            <div class="col-span-2 text-sm">{{ submission.username }}</div>
            <div class="col-span-1 text-sm text-muted-foreground">{{ formatRelativeTime(submission.create_time) }}</div>
          </RouterLink>
        </div>

        <div v-else class="p-8">
          <Empty title="暂无提交记录" description="比赛提交会显示在这里" />
        </div>

        <template #footer>
          <div v-if="submissionTotalPages > 1" class="flex justify-center">
            <Pagination
              :current-page="submissionPage"
              :total-pages="submissionTotalPages"
              @change="handleSubmissionPageChange"
            />
          </div>
        </template>
      </Card>
    </div>

    <div v-else-if="!userStore.isLoggedIn">
      <Empty title="请先登录" description="登录后可以查看并参加比赛">
        <Button class="mt-4" @click="goLogin">去登录</Button>
      </Empty>
    </div>

    <div v-else>
      <Empty title="比赛不存在" description="请检查比赛编号是否正确">
        <RouterLink
          to="/contests"
          class="mt-4 inline-block px-4 py-2 bg-primary text-primary-foreground rounded-lg"
        >
          返回比赛列表
        </RouterLink>
      </Empty>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'
import { contestApi } from '@/api/contest'
import { submissionApi } from '@/api/submission'
import {
  getPageRecords,
  getPageTotal,
  isSuccess,
  mapContestDetail,
  mapContestRankUser,
  mapSubmission,
} from '@/api/adapter'
import type { ContestDetail, ContestRankUser, ContestProblem, Submission } from '@/types'
import { SUBMISSION_STATUS_CLASS, SUBMISSION_STATUS_TEXT } from '@/types'
import Card from '@/components/ui/Card.vue'
import Badge from '@/components/ui/Badge.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import Button from '@/components/ui/Button.vue'
import Pagination from '@/components/ui/Pagination.vue'
import { useUserStore } from '@/stores/user'
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/zh-cn'

dayjs.extend(duration)
dayjs.extend(relativeTime)
dayjs.locale('zh-cn')

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const contest = ref<ContestDetail | null>(null)
const rankList = ref<ContestRankUser[]>([])
const announcementList = ref<ContestAnnouncement[]>([])
const submissionList = ref<Submission[]>([])
const submissionTotal = ref(0)
const submissionPage = ref(1)
const submissionLoading = ref(false)
const loading = ref(true)
const activeTab = ref('problems')
const countdown = ref('')
const progress = ref(0)
const hasContestAccess = ref(true)
const isContestRegistered = ref(false)
const contestPassword = ref('')
const registering = ref(false)
const accessMessage = ref('')
const accessMessageType = ref<'success' | 'error'>('error')
const latestSubmission = ref<{ submitId: number; status: number; problemId?: string } | null>(null)

let timer: ReturnType<typeof setInterval> | null = null
let submissionTimer: ReturnType<typeof setInterval> | null = null

const tabs = [
  { value: 'problems', label: '题目列表' },
  { value: 'rank', label: '排行榜' },
  { value: 'submissions', label: '提交记录' },
  { value: 'announcements', label: '公告' },
]

const submissionPageSize = 20
const submissionTotalPages = computed(() => Math.ceil(submissionTotal.value / submissionPageSize))
const contestRequiresPassword = computed(() => contest.value?.type === 1 || contest.value?.type === 2)
const showRegisterCard = computed(() => Boolean(contest.value) && !isContestRegistered.value)
const registerCardTitle = computed(() => {
  if (contest.value?.type === 1) return '需要报名后进入比赛'
  if (contest.value?.type === 2) return '参加比赛后可提交代码'
  return '参加比赛'
})
const registerCardDescription = computed(() => {
  if (contest.value?.type === 1) return '该比赛需要密码，报名通过后可查看题目和榜单。'
  if (contest.value?.type === 2) return '该比赛需要密码，报名通过后可提交代码。'
  return '参加后会记录参赛身份，并可在比赛中提交代码。'
})
const registerButtonText = computed(() => contest.value?.type === 0 ? '参加' : '报名')

type ContestAnnouncement = {
  id: number
  title: string
  content: string
  gmtCreate?: string
  gmtModified?: string
}

const getStatusText = (status: number) => {
  switch (status) {
    case 0: return '未开始'
    case 1: return '进行中'
    case 2: return '已结束'
    default: return '未知'
  }
}

const getStatusVariant = (status: number): 'success' | 'warning' | 'default' => {
  switch (status) {
    case 0: return 'warning'
    case 1: return 'success'
    default: return 'default'
  }
}

const formatTime = (time?: string) => {
  return time ? dayjs(time).format('YYYY-MM-DD HH:mm') : '-'
}

const formatRelativeTime = (time?: string) => {
  return time ? dayjs(time).fromNow() : '-'
}

const getDuration = (contest: ContestDetail) => {
  const start = dayjs(contest.start_time)
  const end = dayjs(contest.end_time)
  const diff = end.diff(start, 'minute')
  const hours = Math.floor(diff / 60)
  const minutes = diff % 60
  return hours > 0 ? `${hours}小时${minutes > 0 ? minutes + '分钟' : ''}` : `${minutes}分钟`
}

const getAcceptRate = (problem: ContestProblem) => {
  if (problem.submit_count === 0) return 0
  return Math.round((problem.accept_count / problem.submit_count) * 100)
}

const formatPenalty = (minutes: number) => {
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  return `${hours}:${mins.toString().padStart(2, '0')}`
}

const isPendingStatus = (status: number) => [5, 6, 7, 9, 15].includes(status)

const stopSubmissionPolling = () => {
  if (submissionTimer) {
    clearInterval(submissionTimer)
    submissionTimer = null
  }
}

const checkLatestSubmission = async () => {
  const cid = Number(route.params.cid)
  if (!cid || !latestSubmission.value) return

  try {
    const response = await submissionApi.checkContestStatuses(cid, [latestSubmission.value.submitId])
    if (!isSuccess(response.data)) return

    const raw = response.data.data?.[latestSubmission.value.submitId] as { status?: number; displayPid?: string } | undefined
    if (!raw || raw.status === undefined || raw.status === null) return

    latestSubmission.value = {
      ...latestSubmission.value,
      status: raw.status,
      problemId: raw.displayPid || latestSubmission.value.problemId,
    }

    if (!isPendingStatus(raw.status)) {
      stopSubmissionPolling()
      fetchContestSubmissions(cid)
    }
  } catch {
    stopSubmissionPolling()
  }
}

const startSubmissionPolling = (submitId: number, problemId?: string) => {
  stopSubmissionPolling()
  latestSubmission.value = { submitId, status: 9, problemId }
  checkLatestSubmission()
  submissionTimer = setInterval(checkLatestSubmission, 2000)
}

const updateCountdown = () => {
  if (!contest.value) return

  const now = Date.now()
  const start = new Date(contest.value.start_time).getTime()
  const end = new Date(contest.value.end_time).getTime()

  if (contest.value.status === 0) {
    const diff = start - now
    if (diff <= 0) {
      contest.value.status = 1
      countdown.value = ''
    } else {
      const d = dayjs.duration(diff)
      countdown.value = `${d.days()}天 ${d.hours()}小时 ${d.minutes()}分 ${d.seconds()}秒`
    }
  } else if (contest.value.status === 1) {
    const diff = end - now
    if (diff <= 0) {
      contest.value.status = 2
      countdown.value = ''
      progress.value = 100
    } else {
      const d = dayjs.duration(diff)
      countdown.value = `${d.hours()}:${d.minutes().toString().padStart(2, '0')}:${d.seconds().toString().padStart(2, '0')}`
      progress.value = ((now - start) / (end - start)) * 100
    }
  }
}

const checkContestAccess = async (cid: number, contestInfo: ContestDetail) => {
  if (contestInfo.type === 0 && !userStore.isLoggedIn) {
    hasContestAccess.value = true
    isContestRegistered.value = false
    return true
  }

  try {
    const response = await contestApi.getAccess(cid)
    isContestRegistered.value = isSuccess(response.data) && Boolean(response.data.data?.access)
  } catch {
    isContestRegistered.value = false
  }

  hasContestAccess.value = contestInfo.type !== 1 || isContestRegistered.value
  if (!hasContestAccess.value) {
    activeTab.value = 'announcements'
  }
  return hasContestAccess.value
}

const fetchContestSubmissions = async (cid: number) => {
  submissionLoading.value = true
  try {
    const response = await contestApi.getSubmissions(cid, {
      page: submissionPage.value,
      page_size: submissionPageSize,
      onlyMine: true,
    })
    if (isSuccess(response.data)) {
      submissionList.value = getPageRecords(response.data.data).map(mapSubmission)
      submissionTotal.value = getPageTotal(response.data.data)
    } else {
      submissionList.value = []
      submissionTotal.value = 0
    }
  } catch {
    submissionList.value = []
    submissionTotal.value = 0
  } finally {
    submissionLoading.value = false
  }
}

const handleSubmissionPageChange = (page: number) => {
  submissionPage.value = page
  const cid = Number(route.params.cid)
  if (cid) fetchContestSubmissions(cid)
}

const fetchContest = async () => {
  const cid = Number(route.params.cid)
  if (!cid) return

  if (!userStore.isLoggedIn) {
    loading.value = false
    contest.value = null
    return
  }

  loading.value = true
  if (timer) {
    clearInterval(timer)
    timer = null
  }
  accessMessage.value = ''
  try {
    const response = await contestApi.getDetail(cid)
    if (isSuccess(response.data)) {
      contest.value = mapContestDetail(response.data.data, [])
      const canEnter = await checkContestAccess(cid, contest.value)

      if (canEnter) {
        const problemsResponse = await contestApi.getProblems(cid)
        const problems = isSuccess(problemsResponse.data) ? problemsResponse.data.data : []
        contest.value = mapContestDetail(response.data.data, problems)
      }

      try {
        const announcementsResponse = await contestApi.getAnnouncements(cid)
        announcementList.value = isSuccess(announcementsResponse.data)
          ? getPageRecords<ContestAnnouncement>(announcementsResponse.data.data)
          : []
      } catch {
        announcementList.value = []
      }
    } else {
      contest.value = null
      announcementList.value = []
    }

    if (contest.value && hasContestAccess.value) {
      const rankResponse = await contestApi.getRank(cid)
      if (isSuccess(rankResponse.data)) {
        rankList.value = getPageRecords(rankResponse.data.data).map((user, index) =>
          mapContestRankUser(user, contest.value!.problems, index)
        )
      } else {
        rankList.value = []
      }
      await fetchContestSubmissions(cid)
    } else {
      rankList.value = []
      submissionList.value = []
      submissionTotal.value = 0
    }
  } catch {
    contest.value = null
    rankList.value = []
    announcementList.value = []
    submissionList.value = []
    submissionTotal.value = 0
  } finally {
    loading.value = false
    updateCountdown()
    timer = setInterval(updateCountdown, 1000)
  }
}

const registerContest = async () => {
  const cid = Number(route.params.cid)
  if (!cid || registering.value) return

  if (!userStore.isLoggedIn) {
    goLogin()
    return
  }

  registering.value = true
  accessMessage.value = ''
  try {
    const response = await contestApi.register(cid, contestPassword.value.trim() || undefined)
    if (isSuccess(response.data)) {
      accessMessageType.value = 'success'
      accessMessage.value = '报名成功'
      contestPassword.value = ''
      await fetchContest()
      activeTab.value = 'problems'
    } else {
      accessMessageType.value = 'error'
      accessMessage.value = response.data.msg || '报名失败'
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    accessMessageType.value = 'error'
    accessMessage.value = err.response?.data?.msg || err.response?.data?.message || '报名失败'
  } finally {
    registering.value = false
  }
}

const goLogin = () => {
  router.push({ name: 'login', query: { redirect: route.fullPath } })
}

onMounted(() => {
  if (route.query.submitId) {
    const submitId = Number(route.query.submitId)
    if (Number.isFinite(submitId)) {
      startSubmissionPolling(submitId, route.query.problemId ? String(route.query.problemId) : undefined)
    }
  }
  fetchContest()
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
  stopSubmissionPolling()
})
</script>
