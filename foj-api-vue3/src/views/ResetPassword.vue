<template>
  <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center p-4">
    <Card class="w-full max-w-md">
      <template #header>
        <div class="text-center">
          <h1 class="text-2xl font-bold">{{ hasResetToken ? '重置密码' : '找回密码' }}</h1>
          <p class="text-muted-foreground mt-1">
            {{ hasResetToken ? '设置新的登录密码' : '通过绑定邮箱接收重置链接' }}
          </p>
        </div>
      </template>

      <form v-if="!hasResetToken" class="space-y-4" @submit.prevent="handleApplyReset">
        <Input
          id="email"
          v-model="applyForm.email"
          type="email"
          label="邮箱"
          placeholder="请输入绑定邮箱"
          :error="errors.email"
          required
        />

        <div>
          <label for="captcha" class="block text-sm font-medium text-foreground mb-1.5">
            图形验证码 <span class="text-destructive">*</span>
          </label>
          <div class="grid grid-cols-[1fr_104px] gap-2">
            <input
              id="captcha"
              v-model="applyForm.captcha"
              placeholder="请输入验证码"
              class="h-10 px-3 bg-input border border-border rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent transition-colors"
              :class="{ 'border-destructive focus:ring-destructive': errors.captcha }"
            />
            <button
              type="button"
              class="h-10 border border-border rounded-lg bg-secondary overflow-hidden"
              title="点击刷新验证码"
              @click="loadCaptcha"
            >
              <img v-if="captchaImg" :src="captchaImg" alt="验证码" class="w-full h-full object-cover" />
            </button>
          </div>
          <p v-if="errors.captcha" class="text-sm text-destructive mt-1.5">{{ errors.captcha }}</p>
        </div>

        <div v-if="message" class="p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
          {{ message }}
        </div>

        <Button type="submit" class="w-full" :loading="loading">
          发送重置邮件
        </Button>
      </form>

      <form v-else class="space-y-4" @submit.prevent="handleResetPassword">
        <Input
          id="username"
          v-model="resetForm.username"
          label="用户名"
          disabled
        />

        <Input
          id="password"
          v-model="resetForm.password"
          type="password"
          label="新密码"
          placeholder="请输入新密码"
          hint="6-20位字符"
          :error="errors.password"
          required
        />

        <Input
          id="confirmPassword"
          v-model="resetForm.confirmPassword"
          type="password"
          label="确认新密码"
          placeholder="请再次输入新密码"
          :error="errors.confirmPassword"
          required
        />

        <div v-if="message" class="p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
          {{ message }}
        </div>

        <Button type="submit" class="w-full" :loading="loading">
          重置密码
        </Button>
      </form>

      <template #footer>
        <p class="text-center text-sm text-muted-foreground">
          想起密码了？
          <RouterLink to="/login" class="text-primary hover:underline">
            返回登录
          </RouterLink>
        </p>
      </template>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { authApi } from '@/api/auth'
import { isSuccess } from '@/api/adapter'
import Card from '@/components/ui/Card.vue'
import Input from '@/components/ui/Input.vue'
import Button from '@/components/ui/Button.vue'

const route = useRoute()
const router = useRouter()

const applyForm = reactive({
  email: '',
  captcha: '',
  captchaKey: '',
})

const resetForm = reactive({
  username: String(route.query.username || ''),
  code: String(route.query.code || ''),
  password: '',
  confirmPassword: '',
})

const errors = reactive({
  email: '',
  captcha: '',
  password: '',
  confirmPassword: '',
})

const loading = ref(false)
const captchaImg = ref('')
const message = ref('')
const messageType = ref<'success' | 'error'>('success')

const hasResetToken = computed(() => Boolean(resetForm.username && resetForm.code))

const loadCaptcha = async () => {
  try {
    const response = await authApi.getCaptcha()
    if (isSuccess(response.data)) {
      captchaImg.value = response.data.data.img
      applyForm.captchaKey = response.data.data.captchaKey
      applyForm.captcha = ''
    }
  } catch {
    captchaImg.value = ''
  }
}

const validateApply = () => {
  let valid = true
  errors.email = ''
  errors.captcha = ''

  if (!applyForm.email.trim()) {
    errors.email = '请输入邮箱'
    valid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(applyForm.email)) {
    errors.email = '邮箱格式不正确'
    valid = false
  }

  if (!applyForm.captcha.trim()) {
    errors.captcha = '请输入图形验证码'
    valid = false
  }

  return valid
}

const validateReset = () => {
  let valid = true
  errors.password = ''
  errors.confirmPassword = ''

  if (!resetForm.password) {
    errors.password = '请输入新密码'
    valid = false
  } else if (resetForm.password.length < 6 || resetForm.password.length > 20) {
    errors.password = '新密码长度需要为6到20位'
    valid = false
  }

  if (resetForm.password !== resetForm.confirmPassword) {
    errors.confirmPassword = '两次密码输入不一致'
    valid = false
  }

  return valid
}

const handleApplyReset = async () => {
  if (!validateApply()) return

  loading.value = true
  message.value = ''
  try {
    const response = await authApi.applyResetPassword({
      email: applyForm.email.trim(),
      captcha: applyForm.captcha.trim(),
      captchaKey: applyForm.captchaKey,
    })
    if (isSuccess(response.data)) {
      messageType.value = 'success'
      message.value = '重置链接已发送，请在10分钟内查收邮箱'
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '发送重置邮件失败'
      await loadCaptcha()
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = err.response?.data?.msg || err.response?.data?.message || '发送重置邮件失败'
    await loadCaptcha()
  } finally {
    loading.value = false
  }
}

const handleResetPassword = async () => {
  if (!validateReset()) return

  loading.value = true
  message.value = ''
  try {
    const response = await authApi.resetPassword({
      username: resetForm.username,
      password: resetForm.password,
      code: resetForm.code,
    })
    if (isSuccess(response.data)) {
      messageType.value = 'success'
      message.value = '密码已重置，请重新登录'
      setTimeout(() => router.push('/login'), 1200)
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '重置密码失败'
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = err.response?.data?.msg || err.response?.data?.message || '重置密码失败'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  if (!hasResetToken.value) {
    loadCaptcha()
  }
})
</script>
