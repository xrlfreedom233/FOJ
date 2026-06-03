<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
      <div>
        <h1 class="text-2xl font-bold">{{ title }}</h1>
        <p class="text-muted-foreground mt-1">读取和保存后端配置</p>
      </div>
      <div class="flex gap-2">
        <Button variant="secondary" :loading="loading" @click="load">刷新</Button>
        <Button :loading="saving" @click="save">保存</Button>
      </div>
    </div>

    <Card>
      <div v-if="configType === 'web'" class="flex flex-wrap gap-2 mb-4">
        <button
          v-for="section in sections"
          :key="section.value"
          class="px-3 py-1.5 rounded-lg text-sm transition-colors"
          :class="activeSection === section.value ? 'bg-primary text-primary-foreground' : 'bg-secondary hover:bg-secondary/80'"
          @click="activeSection = section.value"
        >
          {{ section.label }}
        </button>
      </div>

      <div v-if="activeSection === 'email'" class="flex gap-2 mb-4">
        <input
          v-model="testEmail"
          type="email"
          placeholder="测试收件邮箱"
          class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <Button variant="secondary" :loading="testingEmail" @click="handleTestEmail">测试邮件</Button>
      </div>

      <div v-if="message" class="mb-4 p-3 rounded-lg text-sm" :class="messageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
        {{ message }}
      </div>

      <div v-if="currentRequestKey === 'switch'" class="space-y-5">
        <div
          v-for="field in switchFields"
          :key="field.key"
          class="flex flex-col md:flex-row md:items-center justify-between gap-3 p-4 bg-secondary/30 rounded-lg"
        >
          <div>
            <div class="font-medium">{{ field.label }}</div>
            <div class="text-sm text-muted-foreground mt-1">{{ field.description }}</div>
          </div>

          <label v-if="field.type === 'boolean'" class="inline-flex items-center cursor-pointer">
            <input
              v-model="formData[field.key]"
              type="checkbox"
              class="sr-only peer"
            />
            <span class="relative w-11 h-6 bg-muted rounded-full peer peer-checked:bg-primary after:content-[''] after:absolute after:top-0.5 after:left-0.5 after:w-5 after:h-5 after:bg-white after:rounded-full after:transition-transform peer-checked:after:translate-x-5"></span>
          </label>

          <input
            v-else
            v-model.number="formData[field.key]"
            type="number"
            min="0"
            class="w-32 h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
        </div>
      </div>

      <div v-else class="space-y-4">
        <div
          v-for="field in visibleFormFields"
          :key="field.key"
          class="grid md:grid-cols-[220px_1fr] gap-3 items-start"
        >
          <label class="text-sm font-medium pt-2">{{ field.label }}</label>
          <label v-if="field.type === 'boolean'" class="inline-flex items-center h-10 cursor-pointer">
            <input v-model="formData[field.key]" type="checkbox" class="sr-only peer" />
            <span class="relative w-11 h-6 bg-muted rounded-full peer peer-checked:bg-primary after:content-[''] after:absolute after:top-0.5 after:left-0.5 after:w-5 after:h-5 after:bg-white after:rounded-full after:transition-transform peer-checked:after:translate-x-5"></span>
          </label>
          <input
            v-else-if="field.type === 'number'"
            v-model.number="formData[field.key]"
            type="number"
            class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <input
            v-else
            v-model="formData[field.key]"
            :type="field.type === 'password' ? 'password' : 'text'"
            class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
        </div>

      </div>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { adminApi } from '@/api/admin'
import { isSuccess } from '@/api/adapter'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'

const route = useRoute()
const formData = ref<Record<string, any>>({})
const loading = ref(false)
const saving = ref(false)
const message = ref('')
const messageType = ref<'success' | 'error'>('success')

const configType = computed(() => String(route.meta.adminConfig || 'web'))
const activeSection = ref<'web' | 'email' | 'database'>('web')
const testEmail = ref('')
const testingEmail = ref(false)
const title = computed(() => configType.value === 'switch' ? '系统开关' : '系统配置')

const sections = [
  { value: 'web', label: '网站配置' },
  { value: 'email', label: '邮件配置' },
  { value: 'database', label: '数据库/Redis' },
] as const

type Field = {
  key: string
  label: string
  type: 'text' | 'password' | 'number' | 'boolean'
  description?: string
}

const switchFields: Field[] = [
  { key: 'openPublicJudge', label: '公开题目提交', type: 'boolean', description: '允许普通题目提交到判题队列' },
  { key: 'openContestJudge', label: '比赛题目提交', type: 'boolean', description: '允许比赛内提交到判题队列' },
  { key: 'hideNonContestSubmissionCode', label: '隐藏非比赛提交代码', type: 'boolean', description: '提交详情中隐藏普通题目代码内容' },
  { key: 'defaultSubmitInterval', label: '默认提交间隔', type: 'number', description: '同一用户两次提交之间的默认间隔，单位秒' },
]

const fieldMap: Record<string, Field[]> = {
  web: [
    { key: 'baseUrl', label: '网站地址', type: 'text' },
    { key: 'name', label: '网站名称', type: 'text' },
    { key: 'shortName', label: '简称', type: 'text' },
    { key: 'description', label: '网站描述', type: 'text' },
    { key: 'register', label: '允许注册', type: 'boolean' },
    { key: 'registerEmailBypass', label: '未配置邮箱时允许开发验证码', type: 'boolean' },
  ],
  email: [
    { key: 'emailUsername', label: '邮箱账号', type: 'text' },
    { key: 'emailPassword', label: '邮箱密码', type: 'password' },
    { key: 'emailHost', label: 'SMTP 主机', type: 'text' },
    { key: 'emailPort', label: 'SMTP 端口', type: 'number' },
    { key: 'emailBGImg', label: '邮件背景图', type: 'text' },
    { key: 'emailSsl', label: '启用 SSL', type: 'boolean' },
  ],
  database: [
    { key: 'mysqlHost', label: 'MySQL 主机', type: 'text' },
    { key: 'mysqlPort', label: 'MySQL 端口', type: 'number' },
    { key: 'mysqlUsername', label: 'MySQL 用户名', type: 'text' },
    { key: 'mysqlPassword', label: 'MySQL 密码', type: 'password' },
    { key: 'mysqlDatabaseName', label: '数据库名', type: 'text' },
    { key: 'redisHost', label: 'Redis 主机', type: 'text' },
    { key: 'redisPort', label: 'Redis 端口', type: 'number' },
    { key: 'redisPassword', label: 'Redis 密码', type: 'password' },
  ],
}

const hiddenWebConfigKeys = new Set(['recordName', 'recordUrl', 'projectName', 'projectUrl'])

const visibleFormFields = computed(() => {
  const fields = fieldMap[currentRequestKey.value] ?? []
  const keys = new Set(Object.keys(formData.value))
  const knownKeys = new Set(fields.map((field) => field.key))
  const extraFields = [...keys]
    .filter((key) => !knownKeys.has(key) && (currentRequestKey.value !== 'web' || !hiddenWebConfigKeys.has(key)))
    .map<Field>((key) => ({
      key,
      label: key,
      type: typeof formData.value[key] === 'boolean' ? 'boolean' : typeof formData.value[key] === 'number' ? 'number' : 'text',
    }))
  return [...fields.filter((field) => keys.has(field.key)), ...extraFields]
})

const requestMap = {
  web: {
    get: adminApi.getWebConfig,
    set: adminApi.setWebConfig,
  },
  email: {
    get: adminApi.getEmailConfig,
    set: adminApi.setEmailConfig,
  },
  database: {
    get: adminApi.getDbAndRedisConfig,
    set: adminApi.setDbAndRedisConfig,
  },
  switch: {
    get: adminApi.getSwitchConfig,
    set: adminApi.setSwitchConfig,
  },
}

const currentRequestKey = computed(() => configType.value === 'switch' ? 'switch' : activeSection.value)

const load = async () => {
  loading.value = true
  message.value = ''
  try {
    const request = requestMap[currentRequestKey.value]
    const response = await request.get()
    if (isSuccess(response.data)) {
      const data = { ...(response.data.data as Record<string, any>) }
      if (currentRequestKey.value === 'web') {
        hiddenWebConfigKeys.forEach((key) => delete data[key])
      }
      formData.value = data
    } else {
      messageType.value = 'error'
      message.value = response.data.msg || '加载失败'
    }
  } finally {
    loading.value = false
  }
}

const save = async () => {
  saving.value = true
  message.value = ''
  try {
    const payload = { ...formData.value }
    if (currentRequestKey.value === 'web') {
      hiddenWebConfigKeys.forEach((key) => delete payload[key])
    }
    const request = requestMap[currentRequestKey.value]
    const response = await request.set(payload)
    messageType.value = isSuccess(response.data) ? 'success' : 'error'
    message.value = isSuccess(response.data) ? '保存成功' : response.data.msg || '保存失败'
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string; message?: string } } }
    messageType.value = 'error'
    message.value = error instanceof SyntaxError
      ? 'JSON 格式不正确'
      : err.response?.data?.msg || err.response?.data?.message || '保存失败'
  } finally {
    saving.value = false
  }
}

const handleTestEmail = async () => {
  if (!testEmail.value) {
    messageType.value = 'error'
    message.value = '请输入测试邮箱'
    return
  }
  testingEmail.value = true
  try {
    const response = await adminApi.testEmail(testEmail.value)
    messageType.value = isSuccess(response.data) ? 'success' : 'error'
    message.value = isSuccess(response.data) ? '测试邮件已发送' : response.data.msg || '测试失败'
  } finally {
    testingEmail.value = false
  }
}

onMounted(load)
watch(configType, load)
watch(activeSection, load)
</script>
