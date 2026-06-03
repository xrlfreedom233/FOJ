<template>
  <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center p-4">
    <Card class="w-full max-w-md">
      <template #header>
        <div class="text-center">
          <h1 class="text-2xl font-bold">创建账号</h1>
          <p class="text-muted-foreground mt-1">加入 FOJ 开始编程之旅</p>
        </div>
      </template>

      <form @submit.prevent="handleRegister" class="space-y-4">
        <Input
          id="username"
          v-model="form.username"
          label="用户名"
          placeholder="请输入用户名"
          :error="errors.username"
          hint="4-16位字母、数字或下划线"
          required
        />

        <Input
          id="email"
          v-model="form.email"
          type="email"
          label="邮箱"
          placeholder="请输入邮箱地址"
          :error="errors.email"
          required
        />

        <div>
          <label for="code" class="block text-sm font-medium text-foreground mb-1.5">
            邮箱验证码 <span class="text-destructive">*</span>
          </label>
          <div class="flex gap-2">
            <input
              id="code"
              v-model="form.code"
              type="text"
              placeholder="请输入验证码"
              required
              class="flex-1 h-10 px-3 bg-input border border-border rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent transition-colors"
              :class="{ 'border-destructive focus:ring-destructive': errors.code }"
            />
            <Button type="button" :loading="sendingCode" :disabled="codeCountdown > 0" @click="handleSendCode">
              {{ codeCountdown > 0 ? `${codeCountdown}s` : '获取验证码' }}
            </Button>
          </div>
          <p v-if="errors.code" class="text-sm text-destructive mt-1.5">{{ errors.code }}</p>
          <p v-else-if="devCode" class="text-sm text-muted-foreground mt-1.5">
            开发验证码：{{ devCode }}
          </p>
        </div>

        <Input
          id="nickname"
          v-model="form.nickname"
          label="昵称"
          placeholder="请输入昵称（可选）"
        />

        <Input
          id="password"
          v-model="form.password"
          type="password"
          label="密码"
          placeholder="请输入密码"
          :error="errors.password"
          hint="至少6位字符"
          required
        />

        <Input
          id="confirmPassword"
          v-model="form.confirmPassword"
          type="password"
          label="确认密码"
          placeholder="请再次输入密码"
          :error="errors.confirmPassword"
          required
        />

        <div v-if="errorMessage" class="p-3 bg-destructive/10 border border-destructive/20 rounded-lg text-destructive text-sm">
          {{ errorMessage }}
        </div>

        <Button type="submit" class="w-full" :loading="loading">
          注册
        </Button>
      </form>

      <template #footer>
        <p class="text-center text-sm text-muted-foreground">
          已有账号？
          <RouterLink to="/login" class="text-primary hover:underline">
            立即登录
          </RouterLink>
        </p>
      </template>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted } from 'vue'
import { RouterLink, useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import Card from '@/components/ui/Card.vue'
import Input from '@/components/ui/Input.vue'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const form = reactive({
  username: '',
  email: '',
  code: '',
  nickname: '',
  password: '',
  confirmPassword: '',
})

const errors = reactive({
  username: '',
  email: '',
  code: '',
  password: '',
  confirmPassword: '',
})

const loading = ref(false)
const sendingCode = ref(false)
const codeCountdown = ref(0)
const devCode = ref('')
const errorMessage = ref('')
let countdownTimer: ReturnType<typeof setInterval> | null = null

const validate = () => {
  let isValid = true
  errors.username = ''
  errors.email = ''
  errors.code = ''
  errors.password = ''
  errors.confirmPassword = ''

  if (!form.username.trim()) {
    errors.username = '请输入用户名'
    isValid = false
  } else if (!/^[a-zA-Z0-9_]{4,16}$/.test(form.username)) {
    errors.username = '用户名格式不正确'
    isValid = false
  }

  if (!form.code.trim()) {
    errors.code = '请输入邮箱验证码'
    isValid = false
  }

  if (!form.email.trim()) {
    errors.email = '请输入邮箱'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = '邮箱格式不正确'
    isValid = false
  }

  if (!form.password) {
    errors.password = '请输入密码'
    isValid = false
  } else if (form.password.length < 6) {
    errors.password = '密码至少6位字符'
    isValid = false
  }

  if (form.password !== form.confirmPassword) {
    errors.confirmPassword = '两次密码输入不一致'
    isValid = false
  }

  return isValid
}

const validateEmail = () => {
  errors.email = ''
  if (!form.email.trim()) {
    errors.email = '请输入邮箱'
    return false
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    errors.email = '邮箱格式不正确'
    return false
  }
  return true
}

const startCountdown = (seconds: number) => {
  codeCountdown.value = seconds
  if (countdownTimer) clearInterval(countdownTimer)
  countdownTimer = setInterval(() => {
    codeCountdown.value -= 1
    if (codeCountdown.value <= 0 && countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
  }, 1000)
}

const handleSendCode = async () => {
  if (!validateEmail() || codeCountdown.value > 0) return

  sendingCode.value = true
  errorMessage.value = ''
  devCode.value = ''

  const result = await userStore.requestRegisterCode(form.email)
  sendingCode.value = false

  if (result.success) {
    devCode.value = result.data?.code || ''
    startCountdown(60)
  } else {
    errorMessage.value = result.message || '验证码发送失败'
  }
}

const handleRegister = async () => {
  if (!validate()) return

  loading.value = true
  errorMessage.value = ''

  const result = await userStore.register(
    form.username,
    form.password,
    form.email,
    form.code,
    form.nickname || undefined
  )

  if (result.success) {
    const loginResult = await userStore.login(form.username, form.password)
    loading.value = false

    if (loginResult.success) {
      const redirect = route.query.redirect as string
      router.push(redirect || '/')
    } else {
      errorMessage.value = loginResult.message || '注册成功，自动登录失败，请手动登录'
    }
  } else {
    loading.value = false
    errorMessage.value = result.message || '注册失败，请稍后重试'
  }
}

onUnmounted(() => {
  if (countdownTimer) clearInterval(countdownTimer)
})
</script>
