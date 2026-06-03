<template>
  <div>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">管理后台</h1>
        <p class="admin-page-description">
          {{ userStore.user?.username }} · {{ roleText }}
        </p>
      </div>
      <Button variant="secondary" :loading="loading" @click="fetchDashboard">
        刷新
      </Button>
    </div>

    <Loading v-if="loading" />

    <div v-else class="space-y-6">
      <div v-if="errorMessage" class="p-3 bg-destructive/10 border border-destructive/20 rounded-lg text-destructive text-sm">
        {{ errorMessage }}
      </div>

      <div class="grid gap-3 md:grid-cols-3">
        <div v-for="stat in stats" :key="stat.label" class="rounded-lg border border-border bg-card px-5 py-4">
          <div class="text-xs font-semibold text-muted-foreground">{{ stat.label }}</div>
          <div class="mt-2 flex items-end justify-between gap-3">
            <div class="text-3xl font-bold text-foreground">{{ stat.value }}</div>
            <span class="admin-status-pill">{{ stat.note }}</span>
          </div>
        </div>
      </div>

      <div class="grid gap-4 lg:grid-cols-3">
        <Card class-name="h-full">
          <template #header>
            <div class="flex items-center justify-between gap-3">
              <h2 class="font-semibold">最近登录</h2>
              <span class="admin-status-pill">Session</span>
            </div>
          </template>
          <div class="space-y-3 text-sm">
            <div class="grid grid-cols-3 gap-3">
              <div class="text-muted-foreground">时间</div>
              <div class="col-span-2 text-right md:text-left">{{ formatTime(session.gmtCreate) }}</div>
            </div>
            <div class="grid grid-cols-3 gap-3">
              <div class="text-muted-foreground">IP</div>
              <div class="col-span-2 text-right md:text-left">{{ session.ip || '-' }}</div>
            </div>
            <div>
              <div class="text-muted-foreground">User Agent</div>
              <div class="mt-1 break-words text-xs leading-5">{{ session.userAgent || '-' }}</div>
            </div>
          </div>
        </Card>

        <Card class="lg:col-span-2">
          <template #header>
            <div class="flex items-center justify-between gap-3">
              <h2 class="font-semibold">服务概览</h2>
              <span class="admin-status-pill">5s 自动刷新</span>
            </div>
          </template>
          <div class="grid gap-3 text-sm md:grid-cols-3">
            <div class="rounded-lg border border-border bg-secondary/30 p-4">
              <div class="text-xs font-semibold text-muted-foreground">Nacos</div>
              <div class="mt-2 font-medium">{{ serviceInfo.nacos?.status || '-' }}</div>
            </div>
            <div class="rounded-lg border border-border bg-secondary/30 p-4">
              <div class="text-xs font-semibold text-muted-foreground">CPU</div>
              <div class="mt-2 font-medium">{{ formatPercent(serviceInfo.backupPercentCpuLoad) }}</div>
            </div>
            <div class="rounded-lg border border-border bg-secondary/30 p-4">
              <div class="text-xs font-semibold text-muted-foreground">内存</div>
              <div class="mt-2 font-medium">{{ formatPercent(serviceInfo.backupPercentMemoryLoad) }}</div>
            </div>
          </div>
        </Card>
      </div>

      <Card no-padding>
        <template #header>
          <h2 class="font-semibold">后端服务</h2>
        </template>
        <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 bg-secondary/60 text-sm font-medium text-muted-foreground border-b border-border">
          <div class="col-span-4">服务</div>
          <div class="col-span-3">地址</div>
          <div class="col-span-2">端口</div>
          <div class="col-span-3">状态</div>
        </div>
        <div
          v-for="service in backendServices"
          :key="String(service.serviceId || service.host || service.port)"
          class="grid grid-cols-12 gap-4 px-6 py-4 border-b border-border last:border-b-0 text-sm"
        >
          <div class="col-span-4 font-medium">{{ service.serviceId || '-' }}</div>
          <div class="col-span-3 text-muted-foreground">{{ service.host || '-' }}</div>
          <div class="col-span-2 text-muted-foreground">{{ service.port || '-' }}</div>
          <div class="col-span-3">
            <span class="admin-status-pill">{{ service.secure ? '保护阈值触发' : '正常' }}</span>
          </div>
        </div>
        <div v-if="backendServices.length === 0" class="p-6">
          <Empty title="暂无后端服务数据" />
        </div>
      </Card>

      <Card no-padding>
        <template #header>
          <h2 class="font-semibold">判题服务</h2>
        </template>
        <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 bg-secondary/60 text-sm font-medium text-muted-foreground border-b border-border">
          <div class="col-span-4">服务</div>
          <div class="col-span-3">地址</div>
          <div class="col-span-2">端口</div>
          <div class="col-span-3">状态</div>
        </div>
        <div
          v-for="service in judgeServices"
          :key="String(getServiceNode(service).serviceId || getServiceNode(service).host || getServiceNode(service).port)"
          class="grid grid-cols-12 gap-4 px-6 py-4 border-b border-border last:border-b-0 text-sm"
        >
          <div class="col-span-4 font-medium">{{ getServiceNode(service).serviceId || '-' }}</div>
          <div class="col-span-3 text-muted-foreground">{{ getServiceNode(service).host || '-' }}</div>
          <div class="col-span-2 text-muted-foreground">{{ getServiceNode(service).port || '-' }}</div>
          <div class="col-span-3">
            <span class="admin-status-pill">{{ getServiceNode(service).secure ? '保护阈值触发' : '正常' }}</span>
          </div>
        </div>
        <div v-if="judgeServices.length === 0" class="p-6">
          <Empty title="暂无判题服务数据" />
        </div>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import dayjs from 'dayjs'
import { adminApi } from '@/api/admin'
import { isSuccess } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'

const userStore = useUserStore()

const loading = ref(false)
const errorMessage = ref('')
const dashboardInfo = ref<Record<string, number>>({})
const session = ref<Record<string, string>>({})
const serviceInfo = ref<Record<string, any>>({})
const judgeServices = ref<Array<Record<string, any>>>([])
let intervalId: ReturnType<typeof setInterval> | null = null

const roleText = computed(() => {
  if (userStore.isSuperAdmin) return '超级管理员'
  return '管理员'
})

const stats = computed(() => [
  { label: '总用户数', value: dashboardInfo.value.userNum ?? 0, note: 'Users' },
  { label: '今日提交', value: dashboardInfo.value.todayJudgeNum ?? 0, note: 'Today' },
  { label: '近 14 天比赛', value: dashboardInfo.value.recentContestNum ?? 0, note: 'Contests' },
])

const backendServices = computed<Array<Record<string, any>>>(() => {
  const services = serviceInfo.value.backupService
  return Array.isArray(services) ? services : []
})

const formatTime = (time?: string) => {
  if (!time) return '-'
  return dayjs(time).format('YYYY-MM-DD HH:mm:ss')
}

const formatPercent = (value: unknown) => {
  if (value === undefined || value === null || value === '') return '-'
  return typeof value === 'number' ? `${value}%` : String(value)
}

const getServiceNode = (service: Record<string, any>) => {
  return service.service && typeof service.service === 'object' ? service.service : service
}

const fetchServiceInfo = async () => {
  const [serviceResponse, judgeResponse] = await Promise.all([
    adminApi.getServiceInfo(),
    adminApi.getJudgeServiceInfo(),
  ])

  if (isSuccess(serviceResponse.data)) {
    serviceInfo.value = serviceResponse.data.data
  }
  if (isSuccess(judgeResponse.data)) {
    judgeServices.value = judgeResponse.data.data
  }
}

const fetchDashboard = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const [dashboardResponse, sessionResponse] = await Promise.all([
      adminApi.getDashboardInfo(),
      adminApi.getRecentSession(),
      fetchServiceInfo(),
    ])

    if (isSuccess(dashboardResponse.data)) {
      dashboardInfo.value = dashboardResponse.data.data
    }
    if (isSuccess(sessionResponse.data)) {
      session.value = sessionResponse.data.data
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string } } }
    errorMessage.value = err.response?.data?.msg || '管理端数据加载失败'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchDashboard()
  intervalId = setInterval(fetchServiceInfo, 5000)
})

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId)
})
</script>
