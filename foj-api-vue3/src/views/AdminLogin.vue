<template>
  <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center p-4">
    <Card class="w-full max-w-md">
      <template #header>
        <div class="text-center">
          <h1 class="text-2xl font-bold">管理端登录</h1>
          <p class="text-muted-foreground mt-1">使用管理员账号进入后台</p>
        </div>
      </template>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <Input
          id="admin-username"
          v-model="form.username"
          label="用户名"
          placeholder="请输入管理员用户名"
          :error="errors.username"
          required
        />

        <Input
          id="admin-password"
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
          登录后台
        </Button>
      </form>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import Card from '@/components/ui/Card.vue'
import Input from '@/components/ui/Input.vue'
import Button from '@/components/ui/Button.vue'

const route = useRoute()
const router = useRouter()
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

  const result = await userStore.adminLogin(form.username, form.password)
  loading.value = false

  if (result.success) {
    router.push((route.query.redirect as string) || '/admin')
  } else {
    errorMessage.value = result.message || '管理员登录失败'
  }
}
</script>
