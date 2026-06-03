<template>
  <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center p-4">
    <Card class="w-full max-w-md">
      <template #header>
        <div class="text-center">
          <h1 class="text-2xl font-bold">欢迎回来</h1>
          <p class="text-muted-foreground mt-1">登录您的 FOJ 账号</p>
        </div>
      </template>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <Input
          id="username"
          v-model="form.username"
          label="用户名"
          placeholder="请输入用户名"
          :error="errors.username"
          required
        />

        <Input
          id="password"
          v-model="form.password"
          type="password"
          label="密码"
          placeholder="请输入密码"
          :error="errors.password"
          required
        />

        <div v-if="errorMessage" class="p-3 bg-destructive/10 border border-destructive/20 rounded-lg text-destructive text-sm">
          {{ errorMessage }}
        </div>

        <Button type="submit" class="w-full" :loading="loading">
          登录
        </Button>
      </form>

      <template #footer>
        <div class="flex items-center justify-between gap-4 text-sm">
          <RouterLink to="/reset-password" class="text-muted-foreground hover:text-primary">
            忘记密码
          </RouterLink>
          <p class="text-muted-foreground">
            还没有账号？
            <RouterLink to="/register" class="text-primary hover:underline">
              立即注册
            </RouterLink>
          </p>
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
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
  password: '',
})

const errors = reactive({
  username: '',
  password: '',
})

const loading = ref(false)
const errorMessage = ref('')

const validate = () => {
  let isValid = true
  errors.username = ''
  errors.password = ''

  if (!form.username.trim()) {
    errors.username = '请输入用户名'
    isValid = false
  }

  if (!form.password) {
    errors.password = '请输入密码'
    isValid = false
  }

  return isValid
}

const handleLogin = async () => {
  if (!validate()) return

  loading.value = true
  errorMessage.value = ''

  const result = await userStore.login(form.username, form.password)

  loading.value = false

  if (result.success) {
    const redirect = route.query.redirect as string
    router.push(redirect || '/')
  } else {
    errorMessage.value = result.message || '登录失败，请检查用户名和密码'
  }
}
</script>
