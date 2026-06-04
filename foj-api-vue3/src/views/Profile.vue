<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <Card>
      <template #header>
        <h1 class="text-2xl font-bold">个人中心</h1>
      </template>

      <div v-if="userStore.user" class="space-y-8">
        <!-- Profile Header -->
        <div class="flex items-start justify-between gap-6">
          <div class="flex items-center gap-6">
          <label class="relative w-24 h-24 rounded-full bg-primary/20 flex items-center justify-center overflow-hidden cursor-pointer group">
            <img
              v-if="userStore.user.avatar"
              :src="userStore.user.avatar"
              :alt="userStore.user.username"
              class="w-full h-full object-cover"
            />
            <span v-else class="text-4xl font-bold text-primary">
              {{ userStore.user.username?.charAt(0).toUpperCase() }}
            </span>
            <span class="absolute inset-0 bg-black/50 text-white text-xs flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
              {{ avatarUploading ? '上传中' : '更换头像' }}
            </span>
            <input
              type="file"
              accept="image/*"
              class="hidden"
              :disabled="avatarUploading"
              @change="handleAvatarChange"
            />
          </label>
          <div>
            <h2 class="text-2xl font-bold">{{ userStore.user.nickname || userStore.user.username }}</h2>
            <p class="text-muted-foreground">@{{ userStore.user.username }}</p>
            <p class="text-sm text-muted-foreground mt-1">{{ userStore.user.signature || '这个人很懒，什么都没写~' }}</p>
          </div>
          </div>
          <Button variant="secondary" @click="toggleEdit">
            {{ editing ? '取消编辑' : '编辑资料' }}
          </Button>
        </div>

        <div v-if="message" class="p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
          {{ message }}
        </div>

        <!-- Edit Profile -->
        <div v-if="editing" class="space-y-4 border border-border rounded-lg p-4">
          <h3 class="text-lg font-semibold">编辑资料</h3>
          <div class="grid md:grid-cols-2 gap-4">
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">昵称</span>
              <input
                v-model="profileForm.nickname"
                maxlength="20"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">真实姓名</span>
              <input
                v-model="profileForm.realname"
                maxlength="50"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
            <label class="block md:col-span-2">
              <span class="block text-sm text-muted-foreground mb-2">个性简介</span>
              <textarea
                v-model="profileForm.signature"
                rows="3"
                class="w-full px-3 py-2 bg-input border border-border rounded-lg text-sm resize-y focus:outline-none focus:ring-2 focus:ring-ring"
              ></textarea>
            </label>
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">学校</span>
              <input
                v-model="profileForm.school"
                maxlength="100"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">学号</span>
              <input
                v-model="profileForm.number"
                maxlength="200"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">博客</span>
              <input
                v-model="profileForm.blog"
                maxlength="255"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
            <label class="block">
              <span class="block text-sm text-muted-foreground mb-2">Github</span>
              <input
                v-model="profileForm.github"
                maxlength="255"
                class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </label>
          </div>
          <div class="flex justify-end gap-3">
            <Button variant="secondary" @click="toggleEdit">取消</Button>
            <Button :loading="saving" @click="saveProfile">保存</Button>
          </div>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div class="p-4 bg-secondary/50 rounded-lg text-center">
            <div class="text-2xl font-bold text-primary">{{ solvedCount }}</div>
            <div class="text-sm text-muted-foreground">已通过</div>
          </div>
          <div class="p-4 bg-secondary/50 rounded-lg text-center">
            <div class="text-2xl font-bold text-foreground">{{ submitCount }}</div>
            <div class="text-sm text-muted-foreground">提交次数</div>
          </div>
          <div class="p-4 bg-secondary/50 rounded-lg text-center">
            <div class="text-2xl font-bold text-success">{{ getAcceptRate }}%</div>
            <div class="text-sm text-muted-foreground">通过率</div>
          </div>
        </div>

        <!-- Submission Heatmap -->
        <div class="space-y-4">
          <div class="flex items-center justify-between gap-3">
            <h3 class="text-lg font-semibold">提交热力图</h3>
            <span class="text-sm text-muted-foreground">近一年 {{ heatmapTotal }} 次提交</span>
          </div>
          <div class="overflow-x-auto rounded-lg border border-border p-4">
            <Loading v-if="heatmapLoading" text="加载热力图..." />
            <div v-else class="min-w-[760px]">
              <div class="grid grid-flow-col grid-rows-7 gap-1">
                <div
                  v-for="day in heatmapDays"
                  :key="day.date"
                  class="h-3 w-3 rounded-sm"
                  :class="getHeatmapClass(day.count)"
                  :title="`${day.date}: ${day.count} 次提交`"
                ></div>
              </div>
              <div class="mt-3 flex items-center justify-end gap-2 text-xs text-muted-foreground">
                <span>少</span>
                <span class="h-3 w-3 rounded-sm bg-secondary"></span>
                <span class="h-3 w-3 rounded-sm bg-success/30"></span>
                <span class="h-3 w-3 rounded-sm bg-success/50"></span>
                <span class="h-3 w-3 rounded-sm bg-success/70"></span>
                <span class="h-3 w-3 rounded-sm bg-success"></span>
                <span>多</span>
              </div>
            </div>
          </div>
        </div>

        <!-- User Info -->
        <div class="space-y-4">
          <h3 class="text-lg font-semibold">基本信息</h3>
          <div class="grid md:grid-cols-2 gap-4">
            <div class="p-4 bg-secondary/30 rounded-lg">
              <div class="text-sm text-muted-foreground mb-1">用户名</div>
              <div>{{ userStore.user.username }}</div>
            </div>
            <div class="p-4 bg-secondary/30 rounded-lg">
              <div class="text-sm text-muted-foreground mb-1">邮箱</div>
              <div>{{ userStore.user.email || '未设置' }}</div>
            </div>
            <div class="p-4 bg-secondary/30 rounded-lg">
              <div class="text-sm text-muted-foreground mb-1">角色</div>
              <div>{{ userRoleText }}</div>
            </div>
            <div class="p-4 bg-secondary/30 rounded-lg">
              <div class="text-sm text-muted-foreground mb-1">注册时间</div>
              <div>{{ formatDate(registerTime) }}</div>
            </div>
          </div>
        </div>

        <!-- Account Security -->
        <div class="space-y-4">
          <h3 class="text-lg font-semibold">账号安全</h3>
          <div class="divide-y divide-border rounded-lg border border-border overflow-hidden">
            <div class="p-4">
              <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                  <h4 class="font-medium">登录密码</h4>
                  <p class="text-sm text-muted-foreground mt-1">定期更新密码可以降低账号风险。</p>
                </div>
                <Button variant="secondary" @click="toggleSecurityPanel('password')">
                  {{ activeSecurityPanel === 'password' ? '收起' : '修改密码' }}
                </Button>
              </div>

              <div v-if="activeSecurityPanel === 'password'" class="mt-4 max-w-xl space-y-3">
                <div class="grid sm:grid-cols-3 gap-3">
                  <label class="block sm:col-span-1">
                    <span class="block text-sm text-muted-foreground mb-2">当前密码</span>
                    <input
                      v-model="passwordForm.oldPassword"
                      type="password"
                      autocomplete="current-password"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                  <label class="block sm:col-span-1">
                    <span class="block text-sm text-muted-foreground mb-2">新密码</span>
                    <input
                      v-model="passwordForm.newPassword"
                      type="password"
                      autocomplete="new-password"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                  <label class="block sm:col-span-1">
                    <span class="block text-sm text-muted-foreground mb-2">确认新密码</span>
                    <input
                      v-model="passwordForm.confirmPassword"
                      type="password"
                      autocomplete="new-password"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                </div>
                <div class="flex justify-end">
                  <Button :loading="changingPassword" @click="changePassword">保存新密码</Button>
                </div>
              </div>
            </div>

            <div class="p-4">
              <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                  <h4 class="font-medium">绑定邮箱</h4>
                  <p class="text-sm text-muted-foreground mt-1">{{ userStore.user.email || '当前未绑定邮箱' }}</p>
                </div>
                <Button variant="secondary" @click="toggleSecurityPanel('email')">
                  {{ activeSecurityPanel === 'email' ? '收起' : '修改邮箱' }}
                </Button>
              </div>

              <div v-if="activeSecurityPanel === 'email'" class="mt-4 max-w-xl space-y-3">
                <div class="grid sm:grid-cols-[1fr_128px] gap-3 items-end">
                  <label class="block">
                    <span class="block text-sm text-muted-foreground mb-2">新邮箱</span>
                    <input
                      v-model="emailForm.newEmail"
                      type="email"
                      autocomplete="email"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                  <Button variant="secondary" :loading="sendingEmailCode" @click="sendChangeEmailCode">发送验证码</Button>
                </div>
                <div class="grid sm:grid-cols-2 gap-3">
                  <label class="block">
                    <span class="block text-sm text-muted-foreground mb-2">邮箱验证码</span>
                    <input
                      v-model="emailForm.code"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                  <label class="block">
                    <span class="block text-sm text-muted-foreground mb-2">当前密码</span>
                    <input
                      v-model="emailForm.password"
                      type="password"
                      autocomplete="current-password"
                      class="w-full h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                    />
                  </label>
                </div>
                <div class="flex justify-end">
                  <Button :loading="changingEmail" @click="changeEmail">保存新邮箱</Button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Links -->
        <div class="flex flex-wrap gap-4">
          <RouterLink
            to="/submissions?mine=1"
            class="px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors"
          >
            我的提交
          </RouterLink>
          <RouterLink
            to="/problems"
            class="px-4 py-2 bg-secondary text-foreground rounded-lg hover:bg-secondary/80 transition-colors"
          >
            继续刷题
          </RouterLink>
        </div>
      </div>

      <div v-else class="text-center py-8">
        <Loading text="加载中..." />
      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { authApi } from '@/api/auth'
import { isSuccess } from '@/api/adapter'
import type { UserHomeInfo } from '@/types'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import dayjs from 'dayjs'

const userStore = useUserStore()
const editing = ref(false)
const saving = ref(false)
const avatarUploading = ref(false)
const changingPassword = ref(false)
const sendingEmailCode = ref(false)
const changingEmail = ref(false)
const message = ref('')
const messageType = ref<'success' | 'error'>('success')
const homeInfo = ref<UserHomeInfo | null>(null)
const activeSecurityPanel = ref<'password' | 'email' | null>(null)
const heatmapLoading = ref(false)
const heatmapData = ref<Array<{ date: string; count: number }>>([])
const heatmapEndDate = ref(dayjs().format('YYYY-MM-DD'))

const profileForm = reactive({
  nickname: '',
  realname: '',
  signature: '',
  school: '',
  number: '',
  blog: '',
  github: '',
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
})

const emailForm = reactive({
  newEmail: '',
  code: '',
  password: '',
})

const solvedCount = computed(() => homeInfo.value?.solvedList?.length ?? userStore.user?.solved ?? 0)
const submitCount = computed(() => homeInfo.value?.total ?? userStore.user?.submit ?? 0)
const getAcceptRate = computed(() => {
  if (!submitCount.value) return 0
  return Math.round((solvedCount.value / submitCount.value) * 100)
})
const heatmapTotal = computed(() => heatmapData.value.reduce((sum, item) => sum + item.count, 0))
const heatmapDays = computed(() => {
  const countMap = new Map(heatmapData.value.map((item) => [item.date, item.count]))
  const end = dayjs(heatmapEndDate.value || undefined)
  const start = end.subtract(370, 'day')
  return Array.from({ length: 371 }, (_, index) => {
    const date = start.add(index, 'day').format('YYYY-MM-DD')
    return {
      date,
      count: countMap.get(date) ?? 0,
    }
  })
})

const registerTime = computed(() => {
  return userStore.user?.create_time || userStore.user?.gmtCreate || userStore.user?.gmt_create || ''
})

const userRoleText = computed(() => {
  const roles = userStore.user?.roleList ?? (userStore.user?.role ? [userStore.user.role] : [])
  if (roles.includes('root')) return '超级管理员'
  if (roles.includes('admin')) return '管理员'
  return getRoleText(roles[0] || 'user')
})

const getRoleText = (role: string) => {
  const roles: Record<string, string> = {
    root: '超级管理员',
    admin: '管理员',
    default_user: '普通用户',
    user: '普通用户',
    vip: 'VIP用户',
  }
  return roles[role] || '普通用户'
}

const formatDate = (date: string) => {
  if (!date) return '未知'
  return dayjs(date).format('YYYY-MM-DD')
}

const fillForm = () => {
  const user = userStore.user
  profileForm.nickname = user?.nickname || ''
  profileForm.realname = user?.realname || ''
  profileForm.signature = user?.signature || ''
  profileForm.school = user?.school || ''
  profileForm.number = user?.number || ''
  profileForm.blog = user?.blog || ''
  profileForm.github = user?.github || ''
}

const toggleEdit = () => {
  editing.value = !editing.value
  message.value = ''
  if (editing.value) fillForm()
}

const toggleSecurityPanel = (panel: 'password' | 'email') => {
  activeSecurityPanel.value = activeSecurityPanel.value === panel ? null : panel
  message.value = ''
}

const loadUserHomeInfo = async () => {
  try {
    const response = await authApi.getUserHomeInfo()
    if (isSuccess(response.data)) {
      homeInfo.value = response.data.data
    }
  } catch {
    homeInfo.value = null
  }
}

const loadUserCalendarHeatmap = async () => {
  heatmapLoading.value = true
  try {
    const response = await authApi.getUserCalendarHeatmap()
    if (isSuccess(response.data)) {
      heatmapEndDate.value = response.data.data?.endDate || dayjs().format('YYYY-MM-DD')
      heatmapData.value = (response.data.data?.dataList ?? [])
        .filter((item) => item.date)
        .map((item) => ({
          date: String(item.date),
          count: Number(item.count ?? 0),
        }))
    } else {
      heatmapData.value = []
    }
  } catch {
    heatmapData.value = []
  } finally {
    heatmapLoading.value = false
  }
}

const getHeatmapClass = (count: number) => {
  if (count <= 0) return 'bg-secondary'
  if (count <= 2) return 'bg-success/30'
  if (count <= 5) return 'bg-success/50'
  if (count <= 10) return 'bg-success/70'
  return 'bg-success'
}

const saveProfile = async () => {
  saving.value = true
  message.value = ''
  try {
    const response = await authApi.updateProfile({
      nickname: profileForm.nickname.trim(),
      realname: profileForm.realname.trim(),
      signature: profileForm.signature.trim(),
      school: profileForm.school.trim(),
      number: profileForm.number.trim(),
      blog: profileForm.blog.trim(),
      github: profileForm.github.trim(),
      gender: userStore.user?.gender || 'secrecy',
    })
    if (isSuccess(response.data)) {
      userStore.setUser(response.data.data)
      await userStore.fetchProfile()
      await loadUserHomeInfo()
      fillForm()
      editing.value = false
      messageType.value = 'success'
      message.value = '资料已更新'
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '保存失败'
    }
  } catch {
    messageType.value = 'error'
    message.value = '保存失败，请检查登录状态或后端服务'
  } finally {
    saving.value = false
  }
}

const changePassword = async () => {
  message.value = ''
  if (!passwordForm.oldPassword || !passwordForm.newPassword) {
    messageType.value = 'error'
    message.value = '请输入当前密码和新密码'
    return
  }
  if (passwordForm.newPassword.length < 6 || passwordForm.newPassword.length > 20) {
    messageType.value = 'error'
    message.value = '新密码长度需要为 6 到 20 位'
    return
  }
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    messageType.value = 'error'
    message.value = '两次新密码输入不一致'
    return
  }

  changingPassword.value = true
  try {
    const response = await authApi.changePassword({
      old_password: passwordForm.oldPassword,
      new_password: passwordForm.newPassword,
    })
    const result = response.data.data
    if (isSuccess(response.data) && result?.code === 200) {
      messageType.value = 'success'
      message.value = result.msg || '修改密码成功，请重新登录'
      passwordForm.oldPassword = ''
      passwordForm.newPassword = ''
      passwordForm.confirmPassword = ''
      activeSecurityPanel.value = null
      setTimeout(() => {
        userStore.logout()
        window.location.href = '/login'
      }, 1500)
    } else {
      messageType.value = 'error'
      message.value = result?.msg || response.data.msg || '修改密码失败'
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = err.response?.data?.msg || err.response?.data?.message || '修改密码失败'
  } finally {
    changingPassword.value = false
  }
}

const sendChangeEmailCode = async () => {
  message.value = ''
  const email = emailForm.newEmail.trim()
  if (!email) {
    messageType.value = 'error'
    message.value = '请输入新邮箱'
    return
  }

  sendingEmailCode.value = true
  try {
    const response = await authApi.getChangeEmailCode(email)
    messageType.value = isSuccess(response.data) ? 'success' : 'error'
    message.value = isSuccess(response.data) ? '验证码已发送，请查收邮箱' : response.data.msg || '发送验证码失败'
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = err.response?.data?.msg || err.response?.data?.message || '发送验证码失败'
  } finally {
    sendingEmailCode.value = false
  }
}

const changeEmail = async () => {
  message.value = ''
  if (!emailForm.newEmail || !emailForm.code || !emailForm.password) {
    messageType.value = 'error'
    message.value = '请输入新邮箱、验证码和当前密码'
    return
  }

  changingEmail.value = true
  try {
    const response = await authApi.changeEmail({
      newEmail: emailForm.newEmail.trim(),
      code: emailForm.code.trim(),
      password: emailForm.password,
    })
    const result = response.data.data
    if (isSuccess(response.data) && result?.code === 200) {
      if (result.userInfo) userStore.setUser(result.userInfo)
      await userStore.fetchProfile()
      await loadUserHomeInfo()
      emailForm.newEmail = ''
      emailForm.code = ''
      emailForm.password = ''
      activeSecurityPanel.value = null
      messageType.value = 'success'
      message.value = result.msg || '修改邮箱成功'
    } else {
      messageType.value = 'error'
      message.value = result?.msg || response.data.msg || '修改邮箱失败'
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = err.response?.data?.msg || err.response?.data?.message || '修改邮箱失败'
  } finally {
    changingEmail.value = false
  }
}

const handleAvatarChange = async (event: Event) => {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  input.value = ''
  if (!file) return

  avatarUploading.value = true
  message.value = ''
  try {
    const response = await authApi.uploadAvatar(file)
    if (isSuccess(response.data)) {
      userStore.setUser(response.data.data)
      messageType.value = 'success'
      message.value = '头像已更新'
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '头像上传失败'
    }
  } catch {
    messageType.value = 'error'
    message.value = '头像上传失败，请检查图片格式或登录状态'
  } finally {
    avatarUploading.value = false
  }
}

onMounted(() => {
  userStore.fetchProfile()
  loadUserHomeInfo()
  loadUserCalendarHeatmap()
})
</script>
