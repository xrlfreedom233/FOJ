<template>
  <div class="space-y-6">
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">{{ isEdit ? '编辑比赛' : '创建比赛' }}</h1>
        <p class="admin-page-description">维护比赛基本信息、访问权限、榜单策略和奖项设置</p>
      </div>
      <div class="flex gap-2">
        <Button variant="secondary" @click="$router.back()">返回</Button>
        <Button :loading="saving" @click="save">保存</Button>
      </div>
    </div>

    <div class="contest-summary-grid">
      <div v-for="item in summaryItems" :key="item.label" class="contest-summary-item">
        <span>{{ item.label }}</span>
        <strong>{{ item.value }}</strong>
      </div>
    </div>

    <Card no-padding>
      <div v-if="message" class="mx-6 mt-6 p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
        {{ message }}
      </div>

      <div v-if="loading" class="p-6">
        <Loading />
      </div>

      <div v-else class="divide-y divide-border">
        <section class="editor-section">
          <div class="section-heading">
            <h2>基础信息</h2>
            <p>设置参赛者在列表和详情页看到的核心信息。</p>
          </div>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">标题</span>
            <input v-model="contest.title" class="input" />
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">描述</span>
            <textarea v-model="contest.description" class="textarea" rows="8" />
          </label>
          <div class="grid md:grid-cols-3 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">开始时间</span>
              <div class="grid grid-cols-[1fr_72px_72px] gap-2">
                <input v-model="startDate" type="date" class="input" @change="applyStartParts" />
                <select v-model.number="startHour" class="input" aria-label="开始小时" @change="applyStartParts">
                  <option v-for="hour in hourOptions" :key="hour" :value="hour">{{ padTime(hour) }} 时</option>
                </select>
                <select v-model.number="startMinute" class="input" aria-label="开始分钟" @change="applyStartParts">
                  <option v-for="minute in minuteOptions" :key="minute" :value="minute">{{ padTime(minute) }} 分</option>
                </select>
              </div>
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">结束时间</span>
              <div class="grid grid-cols-[1fr_72px_72px] gap-2">
                <input v-model="endDate" type="date" class="input" @change="applyEndParts" />
                <select v-model.number="endHour" class="input" aria-label="结束小时" @change="applyEndParts">
                  <option v-for="hour in hourOptions" :key="hour" :value="hour">{{ padTime(hour) }} 时</option>
                </select>
                <select v-model.number="endMinute" class="input" aria-label="结束分钟" @change="applyEndParts">
                  <option v-for="minute in minuteOptions" :key="minute" :value="minute">{{ padTime(minute) }} 分</option>
                </select>
              </div>
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">时长</span>
              <div class="grid grid-cols-2 gap-2">
                <div class="flex min-w-0 items-center overflow-hidden rounded-lg border border-border bg-input focus-within:ring-2 focus-within:ring-ring">
                  <input v-model.number="durationHours" type="number" min="0" class="min-w-0 flex-1 bg-transparent px-3 py-2 text-sm outline-none" @change="applyDuration" @blur="applyDuration" />
                  <span class="shrink-0 border-l border-border px-2 text-xs text-muted-foreground">小时</span>
                </div>
                <div class="flex min-w-0 items-center overflow-hidden rounded-lg border border-border bg-input focus-within:ring-2 focus-within:ring-ring">
                  <input v-model.number="durationMinutes" type="number" min="0" max="59" class="min-w-0 flex-1 bg-transparent px-3 py-2 text-sm outline-none" @change="applyDuration" @blur="applyDuration" />
                  <span class="shrink-0 border-l border-border px-2 text-xs text-muted-foreground">分钟</span>
                </div>
              </div>
              <span v-if="durationText" class="text-xs text-muted-foreground">{{ durationText }}</span>
            </label>
          </div>
        </section>

        <section class="editor-section">
          <div class="section-heading">
            <h2>赛制与榜单</h2>
            <p>控制比赛计分方式、榜单展示和封榜策略。</p>
          </div>
          <div class="grid md:grid-cols-3 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">赛制</span>
              <select v-model.number="contest.type" class="input" :disabled="isEdit" @change="setSealRankTimeDefaultValue">
                <option :value="0">ACM</option>
                <option :value="1">OI</option>
              </select>
            </label>
            <label v-if="contest.type === 1" class="space-y-1.5">
              <span class="text-sm font-medium">OI 排名分数</span>
              <select v-model="contest.oiRankScoreType" class="input">
                <option value="Recent">最近一次提交</option>
                <option value="Highest">最高分提交</option>
              </select>
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">榜单显示名称</span>
              <select v-model="contest.rankShowName" class="input">
                <option value="username">用户名</option>
                <option value="nickname">昵称</option>
                <option value="realname">真实姓名</option>
              </select>
            </label>
          </div>

          <div class="grid md:grid-cols-3 gap-4">
            <label class="switch-row">
              <input v-model="contest.sealRank" type="checkbox" @change="setSealRankTimeDefaultValue" />
              <span>开启封榜</span>
            </label>
            <label v-if="contest.sealRank" class="space-y-1.5">
              <span class="text-sm font-medium">封榜时间</span>
              <select v-model.number="sealRankTime" class="input">
                <option :value="0" :disabled="contest.duration < 1800">结束前半小时</option>
                <option :value="1" :disabled="contest.duration < 3600">结束前一小时</option>
                <option :value="2">全程封榜</option>
              </select>
            </label>
            <label v-if="contest.sealRank" class="switch-row switch-row-with-label-space">
              <input v-model="contest.autoRealRank" type="checkbox" />
              <span>赛后自动开放实时榜</span>
            </label>
            <label class="switch-row">
              <input v-model="contest.openRank" type="checkbox" />
              <span>开放外榜</span>
            </label>
            <label class="switch-row">
              <input v-model="contest.allowEndSubmit" type="checkbox" />
              <span>赛后允许提交</span>
            </label>
          </div>
        </section>

        <section class="editor-section">
          <div class="section-heading">
            <h2>权限</h2>
            <p>设置访问范围、比赛密码和账号限制。</p>
          </div>
          <div class="grid md:grid-cols-3 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">访问权限</span>
              <select v-model.number="contest.auth" class="input">
                <option :value="0">公开</option>
                <option :value="1">私有</option>
                <option :value="2">保护</option>
              </select>
            </label>
            <label v-if="contest.auth !== 0" class="space-y-1.5">
              <span class="text-sm font-medium">比赛密码</span>
              <input v-model="contest.pwd" class="input" />
            </label>
            <label v-if="contest.auth !== 0" class="switch-row switch-row-with-label-space">
              <input v-model="contest.openAccountLimit" type="checkbox" />
              <span>限制账号范围</span>
            </label>
          </div>

          <div v-if="contest.openAccountLimit" class="grid md:grid-cols-4 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">前缀</span>
              <input v-model="accountRule.prefix" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">后缀</span>
              <input v-model="accountRule.suffix" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">起始编号</span>
              <input v-model.number="accountRule.number_from" type="number" class="input" />
            </label>
            <label class="space-y-1.5">
              <span class="text-sm font-medium">结束编号</span>
              <input v-model.number="accountRule.number_to" type="number" class="input" />
            </label>
            <label class="space-y-1.5 md:col-span-4">
              <span class="text-sm font-medium">额外账号</span>
              <textarea v-model="accountRule.extra_account" class="textarea" rows="4" />
            </label>
          </div>
        </section>

        <section class="editor-section">
          <div class="flex items-center justify-between">
            <div class="section-heading">
              <h2>打星用户</h2>
              <p>打星账号参与比赛但不计入正式排名。</p>
            </div>
            <div class="star-user-control">
              <div class="flex gap-2">
                <input v-model="starUserInput" class="input star-user-input" placeholder="用户名" :disabled="checkingStarUser" @input="starUserError = ''" @keyup.enter="addStarUser" />
                <Button class="star-user-button" size="sm" variant="secondary" :loading="checkingStarUser" @click="addStarUser">添加</Button>
              </div>
              <p v-if="starUserError" class="star-user-error">{{ starUserError }}</p>
            </div>
          </div>
          <div class="flex flex-wrap gap-2">
            <button v-for="username in contest.starAccount" :key="username" class="px-2.5 py-1 rounded bg-warning/10 text-warning text-sm" @click="removeStarUser(username)">
              {{ username }} x
            </button>
            <span v-if="!contest.starAccount.length" class="text-sm text-muted-foreground">暂无打星用户</span>
          </div>
        </section>

        <section class="editor-section">
          <div class="flex items-center justify-between">
            <div class="section-heading">
              <h2>奖项</h2>
              <p>配置榜单奖项标签和获奖范围。</p>
            </div>
            <Button v-if="contest.awardType !== 0" size="sm" variant="secondary" @click="addAward">新增奖项</Button>
          </div>
          <div class="grid md:grid-cols-3 gap-4">
            <label class="space-y-1.5">
              <span class="text-sm font-medium">奖项类型</span>
              <select v-model.number="contest.awardType" class="input" @change="ensureAwards">
                <option :value="0">不设置</option>
                <option :value="1">按比例</option>
                <option :value="2">按人数</option>
              </select>
            </label>
          </div>
          <div v-if="contest.awardType !== 0" class="space-y-3">
            <div v-for="(award, index) in contest.awardConfigList" :key="index" class="grid md:grid-cols-[80px_1fr_100px_auto] gap-3 items-end">
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">优先级</span>
                <input v-model.number="award.priority" type="number" class="input" />
              </label>
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">名称</span>
                <input v-model="award.name" class="input" />
              </label>
              <label class="space-y-1.5">
                <span class="text-sm text-muted-foreground">{{ contest.awardType === 1 ? '比例%' : '人数' }}</span>
                <input v-model.number="award.num" type="number" class="input" />
              </label>
              <button class="h-10 text-sm text-destructive hover:underline" @click="removeAward(index)">删除</button>
            </div>
          </div>
        </section>
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import dayjs from 'dayjs'
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { adminApi } from '@/api/admin'
import { authApi } from '@/api/auth'
import { isSuccess } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'

type Award = { priority: number; name: string; background: string; color: string; num: number }

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)
const saving = ref(false)
const message = ref('')
const messageType = ref<'success' | 'error'>('success')
const durationText = ref('')
const durationHours = ref(0)
const durationMinutes = ref(0)
const startDate = ref('')
const startHour = ref(0)
const startMinute = ref(0)
const endDate = ref('')
const endHour = ref(0)
const endMinute = ref(0)
const sealRankTime = ref(2)
const starUserInput = ref('')
const starUserError = ref('')
const checkingStarUser = ref(false)
const INPUT_DATE_FORMAT = 'YYYY-MM-DDTHH:mm'
const hourOptions = Array.from({ length: 24 }, (_, index) => index)
const minuteOptions = Array.from({ length: 60 }, (_, index) => index)

const defaultAwards = (): Award[] => [
  { priority: 1, name: '金牌', background: '#e6bf25', color: '#ffffff', num: 10 },
  { priority: 2, name: '银牌', background: '#b4c0c7', color: '#ffffff', num: 20 },
  { priority: 3, name: '铜牌', background: '#cd7f32', color: '#ffffff', num: 30 },
]

const getAwardDefaultStyle = (index: number) => defaultAwards()[index] ?? { background: '#ededed', color: '#333333' }

const contest = reactive<Record<string, any>>({
  title: '',
  description: '',
  startTime: '',
  endTime: '',
  duration: 0,
  type: 0,
  pwd: '',
  sealRank: false,
  sealRankTime: '',
  autoRealRank: true,
  auth: 0,
  openRank: true,
  openPrint: false,
  rankShowName: 'username',
  openAccountLimit: false,
  allowEndSubmit: false,
  accountLimitRule: '',
  starAccount: [],
  oiRankScoreType: 'Recent',
  awardType: 0,
  awardConfigList: defaultAwards(),
})

const accountRule = reactive({
  prefix: '',
  suffix: '',
  number_from: 0,
  number_to: 10,
  extra_account: '',
})

const isEdit = computed(() => Boolean(route.params.contestId))

const summaryItems = computed(() => [
  { label: '赛制', value: contest.type === 0 ? 'ACM' : 'OI' },
  { label: '访问权限', value: contest.auth === 0 ? '公开' : contest.auth === 1 ? '私有' : '保护' },
  { label: '榜单', value: contest.openRank ? '开放' : '关闭' },
  { label: '时长', value: durationText.value || '未设置' },
])

const payload = computed(() => {
  const data = { ...contest }
  data.openPrint = false
  data.awardConfigList = (Array.isArray(data.awardConfigList) ? data.awardConfigList : []).map((award: Award, index: number) => {
    const style = getAwardDefaultStyle(index)
    return {
      ...award,
      background: award.background || style.background,
      color: award.color || style.color,
    }
  })
  data.startTime = toBackendDate(data.startTime)
  data.endTime = toBackendDate(data.endTime)
  if (data.sealRank) {
    data.sealRankTime = getSealRankTime()
  } else {
    data.sealRankTime = null
  }
  if (data.openAccountLimit) {
    data.accountLimitRule = accountRuleToString()
  } else {
    data.accountLimitRule = ''
  }
  if (!isEdit.value) {
    data.uid = userStore.user?.uid
    data.author = userStore.user?.username
  }
  return data
})

const setMessage = (type: 'success' | 'error', text: string) => {
  messageType.value = type
  message.value = text
}

const padTime = (value: number) => String(value).padStart(2, '0')
const toInputDate = (value: unknown) => value ? dayjs(value as string).format(INPUT_DATE_FORMAT) : ''
const toBackendDate = (value: unknown) => {
  if (!value) return null
  const parsed = dayjs(value as string)
  return parsed.isValid() ? parsed.toDate().toISOString() : null
}
const toDateTimeValue = (date: string, hour: number, minute: number) => date ? `${date}T${padTime(hour)}:${padTime(minute)}` : ''

const getRequestErrorMessage = (error: unknown) => {
  const err = error as {
    message?: string
    response?: {
      data?: {
        msg?: string
        message?: string
        error?: string
      }
    }
  }
  return err.response?.data?.msg || err.response?.data?.message || err.response?.data?.error || err.message || '保存失败'
}

const syncStartParts = () => {
  const parsed = dayjs(contest.startTime)
  if (!contest.startTime || !parsed.isValid()) return
  startDate.value = parsed.format('YYYY-MM-DD')
  startHour.value = parsed.hour()
  startMinute.value = parsed.minute()
}

const syncEndParts = () => {
  const parsed = dayjs(contest.endTime)
  if (!contest.endTime || !parsed.isValid()) return
  endDate.value = parsed.format('YYYY-MM-DD')
  endHour.value = parsed.hour()
  endMinute.value = parsed.minute()
}

const syncDateTimeParts = () => {
  syncStartParts()
  syncEndParts()
}

const load = async () => {
  if (!isEdit.value) {
    changeDuration()
    return
  }
  loading.value = true
  const response = await adminApi.getContest(Number(route.params.contestId))
  loading.value = false
  if (!isSuccess(response.data)) {
    setMessage('error', response.data.msg || '加载失败')
    return
  }
  Object.assign(contest, response.data.data)
  contest.startTime = toInputDate(contest.startTime)
  contest.endTime = toInputDate(contest.endTime)
  syncDateTimeParts()
  if (!Array.isArray(contest.starAccount)) contest.starAccount = []
  if (!Array.isArray(contest.awardConfigList)) contest.awardConfigList = defaultAwards()
  if (contest.accountLimitRule) Object.assign(accountRule, stringToAccountRule(contest.accountLimitRule))
  syncSealRankOption()
  changeDuration()
}

const validate = () => {
  if (!contest.title) return '标题不能为空'
  if (!contest.description) return '描述不能为空'
  if (!contest.startTime) return '开始时间不能为空'
  if (!contest.endTime) return '结束时间不能为空'
  if (!contest.duration || contest.duration <= 0) return '比赛结束时间必须晚于开始时间'
  if (contest.auth !== 0 && !contest.pwd) return '非公开比赛必须设置密码'
  return ''
}

const save = async () => {
  const error = validate()
  if (error) {
    setMessage('error', error)
    return
  }
  saving.value = true
  try {
    const response = isEdit.value ? await adminApi.updateContest(payload.value) : await adminApi.createContest(payload.value)
    if (isSuccess(response.data)) {
      setMessage('success', '保存成功')
      router.push('/admin/contest')
    } else {
      setMessage('error', response.data.msg || '保存失败')
    }
  } catch (err) {
    setMessage('error', getRequestErrorMessage(err))
  } finally {
    saving.value = false
  }
}

const changeDuration = () => {
  if (!contest.startTime || !contest.endTime) {
    contest.duration = 0
    durationText.value = ''
    durationHours.value = 0
    durationMinutes.value = 0
    return
  }
  const start = dayjs(contest.startTime)
  const end = dayjs(contest.endTime)
  const diffSeconds = end.diff(start, 'second')
  if (diffSeconds <= 0) {
    contest.duration = 0
    durationText.value = '结束时间需要晚于开始时间'
    durationHours.value = 0
    durationMinutes.value = 0
    return
  }
  setDuration(diffSeconds)
  setSealRankTimeDefaultValue()
}

const setDuration = (seconds: number) => {
  const normalizedSeconds = Math.max(0, Math.floor(seconds / 60) * 60)
  contest.duration = normalizedSeconds
  durationHours.value = Math.floor(normalizedSeconds / 3600)
  durationMinutes.value = Math.floor((normalizedSeconds % 3600) / 60)
  durationText.value = formatDurationText(normalizedSeconds)
}

const formatDurationText = (seconds: number) => {
  if (seconds <= 0) return ''
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  if (hours && minutes) return `${hours} 小时 ${minutes} 分钟`
  if (hours) return `${hours} 小时`
  return `${minutes} 分钟`
}

const applyDuration = () => {
  const hours = Math.max(0, Math.floor(Number(durationHours.value) || 0))
  const minutes = Math.min(59, Math.max(0, Math.floor(Number(durationMinutes.value) || 0)))
  const totalSeconds = hours * 3600 + minutes * 60
  durationHours.value = hours
  durationMinutes.value = minutes
  contest.duration = totalSeconds
  durationText.value = formatDurationText(totalSeconds)
  if (contest.startTime && totalSeconds > 0) {
    contest.endTime = dayjs(contest.startTime).add(totalSeconds, 'second').format(INPUT_DATE_FORMAT)
    syncEndParts()
  }
  setSealRankTimeDefaultValue()
}

const handleStartTimeChange = () => {
  if (contest.duration > 0) {
    contest.endTime = dayjs(contest.startTime).add(contest.duration, 'second').format(INPUT_DATE_FORMAT)
    syncEndParts()
  }
  changeDuration()
}

const applyStartParts = () => {
  contest.startTime = toDateTimeValue(startDate.value, startHour.value, startMinute.value)
  handleStartTimeChange()
}

const applyEndParts = () => {
  contest.endTime = toDateTimeValue(endDate.value, endHour.value, endMinute.value)
  changeDuration()
}

const getSealRankTime = () => {
  if (sealRankTime.value === 0) return toBackendDate(dayjs(contest.endTime).subtract(30, 'minute').format(INPUT_DATE_FORMAT))
  if (sealRankTime.value === 1) return toBackendDate(dayjs(contest.endTime).subtract(1, 'hour').format(INPUT_DATE_FORMAT))
  return toBackendDate(contest.startTime)
}

const syncSealRankOption = () => {
  if (!contest.sealRankTime) return
  const seal = dayjs(contest.sealRankTime)
  if (seal.isSame(dayjs(contest.endTime).subtract(30, 'minute'))) sealRankTime.value = 0
  else if (seal.isSame(dayjs(contest.endTime).subtract(1, 'hour'))) sealRankTime.value = 1
  else sealRankTime.value = 2
}

const setSealRankTimeDefaultValue = () => {
  if (!contest.sealRank) return
  sealRankTime.value = contest.type === 0 && contest.duration >= 3600 ? 1 : 2
}

const accountRuleToString = () =>
  `<prefix>${accountRule.prefix}</prefix><suffix>${accountRule.suffix}</suffix><start>${accountRule.number_from}</start><end>${accountRule.number_to}</end><extra>${accountRule.extra_account}</extra>`

const stringToAccountRule = (value: string) => {
  const match = /<prefix>([\s\S]*?)<\/prefix><suffix>([\s\S]*?)<\/suffix><start>([\s\S]*?)<\/start><end>([\s\S]*?)<\/end><extra>([\s\S]*?)<\/extra>/.exec(value)
  return match ? {
    prefix: match[1],
    suffix: match[2],
    number_from: Number(match[3]),
    number_to: Number(match[4]),
    extra_account: match[5],
  } : accountRule
}

const addStarUser = async () => {
  const username = starUserInput.value.trim()
  starUserError.value = ''
  if (!username || contest.starAccount.includes(username)) {
    starUserInput.value = ''
    return
  }
  checkingStarUser.value = true
  try {
    const response = await authApi.checkUsername(username)
    if (!isSuccess(response.data) || !response.data.data?.username) {
      starUserError.value = `用户 ${username} 不存在`
      return
    }
    contest.starAccount.push(username)
    starUserInput.value = ''
    message.value = ''
  } catch (error: unknown) {
    setMessage('error', getRequestErrorMessage(error))
  } finally {
    checkingStarUser.value = false
  }
}

const removeStarUser = (username: string) => {
  contest.starAccount = contest.starAccount.filter((item: string) => item !== username)
}

const ensureAwards = () => {
  if (contest.awardType !== 0 && (!contest.awardConfigList || !contest.awardConfigList.length)) {
    contest.awardConfigList = defaultAwards()
  }
}

const addAward = () => {
  contest.awardConfigList.push({ priority: contest.awardConfigList.length + 1, name: '奖项', background: '#ededed', color: '#333333', num: 0 })
}

const removeAward = (index: number) => {
  contest.awardConfigList.splice(index, 1)
}

onMounted(load)
</script>

<style scoped>
.contest-summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 0.75rem;
}

.contest-summary-item {
  min-height: 4.25rem;
  border: 1px solid theme('colors.border');
  border-radius: 0.5rem;
  background: theme('colors.card');
  padding: 0.875rem 1rem;
}

.contest-summary-item span {
  display: block;
  color: theme('colors.muted-foreground');
  font-size: 0.75rem;
  font-weight: 600;
}

.contest-summary-item strong {
  display: block;
  margin-top: 0.5rem;
  color: theme('colors.foreground');
  font-size: 1rem;
}

.editor-section {
  padding: 1.5rem;
  display: grid;
  gap: 1rem;
}

.section-heading {
  display: grid;
  gap: 0.25rem;
}

.section-heading h2 {
  color: theme('colors.foreground');
  font-size: 1rem;
  font-weight: 700;
}

.section-heading p {
  color: theme('colors.muted-foreground');
  font-size: 0.875rem;
  line-height: 1.5;
}

.star-user-control {
  width: min(24rem, 100%);
}

.star-user-input {
  min-width: 0;
  flex: 1;
}

.star-user-button {
  width: 4rem;
  flex: 0 0 4rem;
  white-space: nowrap;
}

.star-user-error {
  margin-top: 0.375rem;
  color: theme('colors.destructive');
  font-size: 0.8125rem;
  line-height: 1.4;
}

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

.switch-row {
  min-height: 2.5rem;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: theme('colors.foreground');
}

.switch-row-with-label-space {
  padding-top: 1.625rem;
}

@media (max-width: 768px) {
  .contest-summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .editor-section {
    padding: 1rem;
  }
}
</style>
