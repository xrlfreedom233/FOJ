<template>
  <div>
    <div class="admin-page-header">
      <div>
        <h1 class="admin-page-title">{{ config.title }}</h1>
        <p class="admin-page-description">{{ config.description }}</p>
      </div>
      <div class="admin-toolbar">
        <label v-if="resource === 'users'" class="inline-flex items-center gap-2 text-sm text-muted-foreground">
          <input v-model="onlyAdmin" type="checkbox" @change="handleSearch" />
          只看管理员
        </label>
        <input
          v-if="config.searchable"
          v-model="keyword"
          type="text"
          placeholder="搜索"
          class="h-10 px-3 bg-input border border-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          @keyup.enter="handleSearch"
        />
        <Button v-if="config.searchable" variant="secondary" @click="handleSearch">搜索</Button>
        <Button
          v-if="resource === 'users'"
          variant="secondary"
          :disabled="selectedUserIds.length === 0"
          @click="handleBatchDeleteUsers"
        >
          批量删除<span v-if="selectedUserIds.length"> {{ selectedUserIds.length }}</span>
        </Button>
        <Button v-if="canCreate" variant="secondary" @click="handleCreate">新增</Button>
        <Button v-if="resource === 'contest-problems'" variant="secondary" @click="openPublicProblemDialog">从公开题库添加</Button>
        <Button :loading="loading" @click="fetchData">刷新</Button>
      </div>
    </div>

    <Loading v-if="loading" />

    <Card v-else no-padding>
      <div v-if="errorMessage" class="p-4 text-sm text-destructive border-b border-border bg-destructive/10">
        {{ errorMessage }}
      </div>

      <div v-if="rows.length === 0" class="p-8">
        <Empty :title="`${config.title}暂无数据`" />
      </div>

      <div v-else class="overflow-x-auto">
        <table class="admin-table">
          <thead>
            <tr>
              <th v-if="resource === 'users'" class="w-10">
                <input
                  type="checkbox"
                  :checked="isAllCurrentUsersSelected"
                  :disabled="visibleUserIds.length === 0"
                  @change="toggleCurrentPageUsers"
                />
              </th>
              <th v-for="column in columns" :key="column.key">
                {{ column.label }}
              </th>
              <th class="admin-actions-header">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in rows" :key="getRowKey(row)">
              <td v-if="resource === 'users'" class="whitespace-nowrap">
                <input
                  type="checkbox"
                  :checked="selectedUserIds.includes(getUserId(row))"
                  :disabled="Boolean(deleteDisabledReason(row))"
                  :title="deleteDisabledReason(row)"
                  @click="toggleUserSelection(row, $event)"
                />
              </td>
              <td v-for="column in columns" :key="column.key" class="whitespace-nowrap">
                {{ formatValue(row, column.key) }}
              </td>
              <td class="admin-actions-cell">
                <div class="admin-actions">
                  <RouterLink
                    v-if="resource === 'contests'"
                    :to="`/admin/contest/${row.id}/problems`"
                    class="text-primary hover:underline"
                  >
                    题目
                  </RouterLink>
                  <RouterLink
                    v-if="resource === 'contests'"
                    :to="`/admin/contest/${row.id}/announcement`"
                    class="text-primary hover:underline"
                  >
                    公告
                  </RouterLink>
                  <RouterLink
                    v-if="config.editPath"
                    :to="config.editPath(row)"
                    class="text-primary hover:underline"
                  >
                    编辑
                  </RouterLink>
                  <button
                    v-if="config.formType"
                    class="text-primary hover:underline"
                    @click="openEditDialog(row)"
                  >
                    编辑
                  </button>
                  <button
                    v-if="config.deleteAction"
                    class="text-destructive hover:underline disabled:cursor-not-allowed disabled:text-muted-foreground disabled:hover:no-underline"
                    :disabled="Boolean(deleteDisabledReason(row))"
                    :title="deleteDisabledReason(row)"
                    @click="handleDelete(row)"
                  >
                    删除
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <template #footer>
        <div class="flex items-center justify-between gap-4">
          <span class="text-sm text-muted-foreground">
            共 {{ total }} 条
            <template v-if="resource === 'users' && selectedUserIds.length">，已选 {{ selectedUserIds.length }} 个用户</template>
          </span>
          <Pagination
            v-if="totalPages > 1"
            :current-page="currentPage"
            :total-pages="totalPages"
            @change="handlePageChange"
          />
        </div>
      </template>
    </Card>

    <div v-if="resource === 'users'" class="grid lg:grid-cols-2 gap-4 mt-6">
      <Card class-name="h-full">
        <div class="flex items-center justify-between gap-3 mb-3">
          <h2 class="font-semibold">批量导入用户</h2>
          <Button variant="secondary" @click="downloadUserImportTemplate">下载模板</Button>
        </div>
        <p class="text-sm text-muted-foreground mb-4">选择 CSV 文件后先预览，确认无误再上传。用户名和密码必填，其他字段可以留空。</p>
        <div class="rounded-lg border border-border overflow-hidden mb-4">
          <div class="grid grid-cols-3 bg-secondary/60 px-3 py-2 text-xs font-semibold text-muted-foreground">
            <span>列</span>
            <span>含义</span>
            <span>要求</span>
          </div>
          <div
            v-for="column in csvColumns"
            :key="column.key"
            class="grid grid-cols-3 px-3 py-2 text-sm border-t border-border"
          >
            <span class="font-mono text-xs text-muted-foreground">{{ column.key }}</span>
            <span>{{ column.label }}</span>
            <span :class="column.required ? 'text-warning' : 'text-muted-foreground'">{{ column.required ? '必填' : '可留空' }}</span>
          </div>
        </div>
        <div class="mb-4 rounded-lg bg-secondary/40 px-3 py-2 text-xs text-muted-foreground">
          示例：<span class="font-mono text-foreground">{{ sampleCsvLine }}</span>
        </div>
        <input type="file" accept=".csv,text/csv" class="block w-full text-sm" @change="handleCsvFile" />
        <div v-if="uploadUsers.length" class="mt-4">
          <div class="text-sm text-muted-foreground mb-2">待导入 {{ uploadUsers.length }} 个用户</div>
          <div class="max-h-56 overflow-auto border border-border rounded-lg">
            <table class="w-full text-sm">
              <thead class="bg-secondary/60 text-muted-foreground">
                <tr>
                  <th class="px-3 py-2 text-left font-medium">用户名</th>
                  <th class="px-3 py-2 text-left font-medium">邮箱</th>
                  <th class="px-3 py-2 text-left font-medium">真实姓名</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(user, index) in uploadUsers.slice(0, 20)" :key="index" class="border-t border-border first:border-t-0">
                  <td class="px-3 py-2">{{ user[0] }}</td>
                  <td class="px-3 py-2">{{ user[2] || '-' }}</td>
                  <td class="px-3 py-2">{{ user[3] || '-' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="flex gap-2 mt-4">
            <Button :loading="importingUsers" @click="importUsers">上传全部</Button>
            <Button variant="secondary" @click="uploadUsers = []">清空</Button>
          </div>
        </div>
      </Card>

      <Card class-name="h-full">
        <div class="flex items-center justify-between gap-3 mb-3">
          <h2 class="font-semibold">生成用户</h2>
          <span class="admin-status-pill">Batch</span>
        </div>
        <div class="grid md:grid-cols-2 gap-4">
          <label class="space-y-1.5">
            <span class="text-sm font-medium">前缀</span>
            <input v-model="generateForm.prefix" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">后缀</span>
            <input v-model="generateForm.suffix" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">起始编号</span>
            <input v-model.number="generateForm.number_from" type="number" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">结束编号</span>
            <input v-model.number="generateForm.number_to" type="number" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">密码长度</span>
            <input v-model.number="generateForm.password_length" type="number" min="6" max="25" class="input" />
          </label>
        </div>
        <p class="text-sm text-muted-foreground mt-3">
          示例：{{ generateForm.prefix }}{{ generateForm.number_from }}{{ generateForm.suffix }}
          <template v-if="generateForm.number_from < generateForm.number_to">, {{ generateForm.prefix }}{{ generateForm.number_from + 1 }}{{ generateForm.suffix }} ... {{ generateForm.prefix }}{{ generateForm.number_to }}{{ generateForm.suffix }}</template>
        </p>
        <Button class="mt-4" :loading="generatingUsers" @click="generateUsers">生成并下载</Button>
      </Card>
    </div>

    <div v-if="showPublicProblemDialog" class="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4 overflow-hidden">
      <div class="w-[calc(100vw-2rem)] max-w-5xl bg-card border border-border rounded-lg p-5 shadow-xl max-h-[90vh] overflow-y-auto overflow-x-hidden">
        <div class="grid gap-4 lg:grid-cols-[minmax(0,1fr)_minmax(0,560px)] lg:items-center mb-4">
          <div class="min-w-0">
            <h2 class="text-lg font-semibold">从公开题库添加</h2>
            <p class="text-sm text-muted-foreground mt-1">选择公开题目并设置比赛内展示 ID</p>
          </div>
          <div class="grid min-w-0 grid-cols-[minmax(0,1fr)_80px_80px] gap-2">
            <input v-model="publicProblemKeyword" class="input min-w-0 w-full" placeholder="搜索题目" @keyup.enter="loadPublicProblems(1)" />
            <Button class="shrink-0 min-w-16" variant="secondary" @click="loadPublicProblems(1)">搜索</Button>
            <Button class="shrink-0 min-w-16" variant="ghost" @click="showPublicProblemDialog = false">关闭</Button>
          </div>
        </div>

        <Loading v-if="publicProblemLoading" />
        <div v-else class="border border-border rounded-lg overflow-hidden">
          <table class="admin-table table-fixed">
            <thead>
              <tr>
                <th class="w-32">ID</th>
                <th>标题</th>
                <th class="w-48">比赛展示 ID</th>
                <th class="w-28 text-right">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in publicProblems" :key="row.id">
                <td class="truncate">{{ row.problemId || row.id }}</td>
                <td class="truncate">{{ row.title }}</td>
                <td>
                  <input v-model="publicProblemDisplayIds[row.id]" class="input w-full" :placeholder="row.problemId || String(row.id)" />
                </td>
                <td class="text-right">
                  <Button size="sm" :loading="addingPublicProblemId === Number(row.id)" @click="addPublicProblem(row)">添加</Button>
                </td>
              </tr>
              <tr v-if="publicProblems.length === 0">
                <td colspan="4" class="px-4 py-8">
                  <Empty title="暂无可添加题目" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="flex justify-end mt-4">
          <Pagination v-if="publicProblemTotalPages > 1" :current-page="publicProblemPage" :total-pages="publicProblemTotalPages" @change="loadPublicProblems" />
        </div>
      </div>
    </div>

    <div v-if="showDialog" class="fixed inset-0 z-50 bg-black/40 flex items-center justify-center p-4">
      <div class="w-full max-w-2xl bg-card border border-border rounded-lg p-5 shadow-xl max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-semibold">{{ dialogTitle }}</h2>
          <button class="text-muted-foreground hover:text-foreground" @click="showDialog = false">关闭</button>
        </div>

        <div v-if="dialogMessage" class="mb-4 p-3 rounded-lg text-sm" :class="dialogMessageType === 'error' ? 'bg-destructive/10 text-destructive' : 'bg-success/10 text-success'">
          {{ dialogMessage }}
        </div>

        <div v-if="activeFormType === 'announcement'" class="space-y-4">
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">标题</span>
            <input v-model="formData.title" class="input" />
          </label>
          <label class="space-y-1.5 block">
            <span class="text-sm font-medium">内容</span>
            <textarea v-model="formData.content" class="textarea" rows="12" />
          </label>
          <label class="inline-flex items-center gap-2 text-sm">
            <input v-model.number="formData.status" type="checkbox" :true-value="0" :false-value="1" />
            显示公告
          </label>
        </div>

        <div v-else-if="activeFormType === 'user'" class="grid md:grid-cols-2 gap-4">
          <label class="space-y-1.5">
            <span class="text-sm font-medium">用户名</span>
            <input v-model="formData.username" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">真实姓名</span>
            <input v-model="formData.realname" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">邮箱</span>
            <input v-model="formData.email" type="email" class="input" />
          </label>
          <label class="space-y-1.5">
            <span class="text-sm font-medium">用户类型</span>
            <select v-model.number="formData.type" class="input">
              <option :value="1000">超级管理员</option>
              <option :value="1001">普通管理员</option>
              <option :value="1002">普通用户</option>
            </select>
          </label>
          <label class="inline-flex items-center gap-2 text-sm">
            <input v-model="formData.setNewPwd" type="checkbox" />
            设置新密码
          </label>
          <label v-if="formData.setNewPwd" class="space-y-1.5">
            <span class="text-sm font-medium">新密码</span>
            <input v-model="formData.password" class="input" />
          </label>
          <label class="inline-flex items-center gap-2 text-sm">
            <input v-model.number="formData.status" type="checkbox" :true-value="0" :false-value="1" />
            账号正常
          </label>
        </div>

        <div class="flex justify-end gap-2 pt-5 mt-5 border-t border-border">
          <Button variant="secondary" @click="showDialog = false">取消</Button>
          <Button :loading="savingForm" @click="saveForm">保存</Button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import dayjs from 'dayjs'
import { adminApi } from '@/api/admin'
import { getPageRecords, getPageTotal, isSuccess } from '@/api/adapter'
import { useUserStore } from '@/stores/user'
import Card from '@/components/ui/Card.vue'
import Button from '@/components/ui/Button.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'
import Pagination from '@/components/ui/Pagination.vue'

type Column = {
  key: string
  label: string
}

type Row = Record<string, any>

type ResourceConfig = {
  title: string
  description: string
  searchable?: boolean
  columns: Column[]
  fetch: (params: { page: number; pageSize: number; keyword?: string }) => Promise<unknown>
  getRows?: (data: unknown) => Row[]
  getTotal?: (data: unknown) => number
  rowKey: (row: Row) => string | number
  createPath?: string
  editPath?: (row: Row) => string
  deleteAction?: (row: Row) => Promise<unknown>
  formType?: 'announcement' | 'user'
}

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const rows = ref<Row[]>([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = 15
const keyword = ref('')
const onlyAdmin = ref(false)
const loading = ref(false)
const errorMessage = ref('')
const showDialog = ref(false)
const savingForm = ref(false)
const importingUsers = ref(false)
const generatingUsers = ref(false)
const dialogMode = ref<'create' | 'edit'>('create')
const activeFormType = ref<'announcement' | 'user' | ''>('')
const formData = ref<Row>({})
const dialogMessage = ref('')
const dialogMessageType = ref<'success' | 'error'>('success')
const uploadUsers = ref<string[][]>([])
const selectedUserIds = ref<string[]>([])
const lastSelectedUserId = ref('')
const showPublicProblemDialog = ref(false)
const publicProblemLoading = ref(false)
const publicProblemKeyword = ref('')
const publicProblemPage = ref(1)
const publicProblemPageSize = 10
const publicProblemTotal = ref(0)
const publicProblems = ref<Row[]>([])
const publicProblemDisplayIds = ref<Record<string, string>>({})
const addingPublicProblemId = ref(0)
const generateForm = ref({
  prefix: 'user',
  suffix: '',
  number_from: 1,
  number_to: 10,
  password_length: 6,
})
const csvColumns = [
  { key: 'username', label: '用户名', required: true },
  { key: 'password', label: '初始密码', required: true },
  { key: 'email', label: '邮箱', required: false },
  { key: 'realname', label: '真实姓名', required: false },
  { key: 'gender', label: '性别', required: false },
  { key: 'nickname', label: '昵称', required: false },
  { key: 'school', label: '学校', required: false },
]
const sampleCsvLine = 'alice,Passw0rd!,alice@example.com,张三,女,alice,FOJ University'
const userImportTemplateRows = [
  csvColumns.map((column) => column.key),
  sampleCsvLine.split(','),
]

const resource = computed(() => String(route.meta.adminResource || 'users'))
const roleLabels: Record<string, string> = {
  root: '超级管理员',
  admin: '管理员',
  default_user: '普通用户',
  user: '普通用户',
}
const userStatusLabels: Record<string, string> = {
  '0': '正常',
  '1': '禁用',
}
const problemAuthLabels: Record<string, string> = {
  '1': '公开',
  '2': '隐藏',
  '3': '比赛',
}
const contestAuthLabels: Record<string, string> = {
  '0': '公开',
  '1': '私有',
  '2': '保护',
}
const contestStatusLabels: Record<string, string> = {
  '-1': '未开始',
  '0': '进行中',
  '1': '已结束',
}

const configs: Record<string, ResourceConfig> = {
  users: {
    title: '用户管理',
    description: '查询、筛选和维护用户账号',
    searchable: true,
    columns: [
      { key: 'uid', label: 'UID' },
      { key: 'username', label: '用户名' },
      { key: 'nickname', label: '昵称' },
      { key: 'email', label: '邮箱' },
      { key: 'roles', label: '角色' },
      { key: 'status', label: '状态' },
    ],
    fetch: ({ page, pageSize, keyword }) => adminApi.getUserList({ page, page_size: pageSize, keyword, onlyAdmin: onlyAdmin.value }),
    rowKey: (row) => row.uid || row.username,
    formType: 'user',
    deleteAction: (row) => adminApi.deleteUsers([String(row.uid)]),
  },
  announcements: {
    title: '公告管理',
    description: '维护站点公告',
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'title', label: '标题' },
      { key: 'author', label: '作者' },
      { key: 'gmtCreate', label: '创建时间' },
    ],
    fetch: ({ page, pageSize }) => adminApi.getAnnouncementList({ page, page_size: pageSize }),
    rowKey: (row) => row.id,
    formType: 'announcement',
    deleteAction: (row) => adminApi.deleteAnnouncement(Number(row.id)),
  },
  'contest-announcements': {
    title: '比赛公告',
    description: '维护当前比赛公告',
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'title', label: '标题' },
      { key: 'author', label: '作者' },
      { key: 'gmtCreate', label: '创建时间' },
    ],
    fetch: ({ page, pageSize }) => adminApi.getAnnouncementList({
      page,
      page_size: pageSize,
      cid: Number(route.params.contestId),
    }),
    rowKey: (row) => row.id,
    formType: 'announcement',
    deleteAction: (row) => adminApi.deleteAnnouncement(Number(row.id), Number(route.params.contestId)),
  },
  problems: {
    title: '题目管理',
    description: '查看、创建、编辑和删除题目',
    searchable: true,
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'problemId', label: '展示ID' },
      { key: 'title', label: '标题' },
      { key: 'author', label: '作者' },
      { key: 'auth', label: '权限' },
      { key: 'gmtModified', label: '更新时间' },
    ],
    fetch: ({ page, pageSize, keyword }) => adminApi.getProblemList({ page, page_size: pageSize, keyword }),
    rowKey: (row) => row.id,
    editPath: (row) => `/admin/problem/edit/${row.id}`,
    deleteAction: (row) => adminApi.deleteProblem(Number(row.id)),
  },
  contests: {
    title: '比赛管理',
    description: '查看、创建、编辑和删除比赛',
    searchable: true,
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'title', label: '标题' },
      { key: 'author', label: '作者' },
      { key: 'auth', label: '权限' },
      { key: 'startTime', label: '开始时间' },
      { key: 'endTime', label: '结束时间' },
    ],
    fetch: ({ page, pageSize, keyword }) => adminApi.getContestList({ page, page_size: pageSize, keyword }),
    rowKey: (row) => row.id,
    createPath: '/admin/contest/create',
    editPath: (row) => `/admin/contest/${row.id}/edit`,
    deleteAction: (row) => adminApi.deleteContest(Number(row.id)),
  },
  'contest-problems': {
    title: '比赛题目',
    description: '维护当前比赛题目列表',
    searchable: true,
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'problemId', label: '展示ID' },
      { key: 'title', label: '标题' },
      { key: 'author', label: '作者' },
      { key: 'auth', label: '权限' },
      { key: 'gmtModified', label: '更新时间' },
    ],
    fetch: ({ page, pageSize, keyword }) => adminApi.getProblemList({
      page,
      page_size: pageSize,
      keyword,
      cid: Number(route.params.contestId),
    }),
    getRows: (data) => getPageRecords((data as { problemList?: unknown }).problemList),
    getTotal: (data) => getPageTotal((data as { problemList?: unknown }).problemList),
    rowKey: (row) => row.id,
    createPath: `/admin/contest/${route.params.contestId}/problem/create`,
    editPath: (row) => `/admin/contest/${route.params.contestId}/problem/${row.id}/edit`,
    deleteAction: (row) => adminApi.deleteProblem(Number(row.id), Number(route.params.contestId)),
  },
  tags: {
    title: '标签管理',
    description: '维护题目标签和标签分类',
    columns: [
      { key: 'id', label: 'ID' },
      { key: 'name', label: '名称' },
      { key: 'color', label: '颜色' },
      { key: 'oj', label: 'OJ' },
      { key: 'gmtModified', label: '更新时间' },
    ],
    fetch: () => adminApi.getAllProblemTags('ALL'),
    getRows: (data) => Array.isArray(data) ? data as Row[] : [],
    getTotal: (data) => Array.isArray(data) ? data.length : 0,
    rowKey: (row) => row.id,
    deleteAction: (row) => adminApi.deleteTag(Number(row.id)),
  },
}

const config = computed(() => configs[resource.value] ?? configs.users)
const columns = computed(() => config.value.columns)
const totalPages = computed(() => Math.ceil(total.value / pageSize))
const canCreate = computed(() => config.value.formType === 'announcement' || Boolean(config.value.createPath))
const dialogTitle = computed(() => `${dialogMode.value === 'create' ? '新增' : '编辑'}${activeFormType.value === 'user' ? '用户' : '公告'}`)
const publicProblemTotalPages = computed(() => Math.ceil(publicProblemTotal.value / publicProblemPageSize))
const visibleUserIds = computed(() => {
  if (resource.value !== 'users') return []
  return rows.value
    .filter((row) => !deleteDisabledReason(row))
    .map((row) => getUserId(row))
    .filter(Boolean)
})
const isAllCurrentUsersSelected = computed(() =>
  visibleUserIds.value.length > 0 && visibleUserIds.value.every((id) => selectedUserIds.value.includes(id))
)

const getRowKey = (row: Row) => config.value.rowKey(row)

const getUserId = (row: Row) => String(row.uid ?? row.uuid ?? row.id ?? '')

const normalizeRows = (data: unknown) => config.value.getRows?.(data) ?? getPageRecords(data) as Row[]
const normalizeTotal = (data: unknown) => config.value.getTotal?.(data) ?? getPageTotal(data)

const formatValue = (row: Row, key: string) => {
  const value = row[key]
  if (Array.isArray(value)) {
    return value.map((item) => {
      const label = item.role || item.name || item.title || item
      return roleLabels[String(label)] || label
    }).join(', ')
  }
  if (resource.value === 'users' && key === 'status') {
    return userStatusLabels[String(value)] || (value ?? '-')
  }
  if (resource.value === 'users' && key === 'roles') {
    return roleLabels[String(value)] || value || '-'
  }
  if ((resource.value === 'problems' || resource.value === 'contest-problems') && key === 'auth') {
    return problemAuthLabels[String(value)] || (value ?? '-')
  }
  if (resource.value === 'contests' && key === 'auth') {
    return contestAuthLabels[String(value)] || (value ?? '-')
  }
  if (resource.value === 'contests' && key === 'status') {
    return contestStatusLabels[String(value)] || (value ?? '-')
  }
  if (key.toLowerCase().includes('time') || key.startsWith('gmt')) {
    return value ? dayjs(value).format('YYYY-MM-DD HH:mm') : '-'
  }
  if (typeof value === 'boolean') {
    return value ? '是' : '否'
  }
  return value ?? '-'
}

const fetchData = async () => {
  loading.value = true
  errorMessage.value = ''
  try {
    const response = await config.value.fetch({
      page: currentPage.value,
      pageSize,
      keyword: keyword.value || undefined,
    }) as { data?: any }

    if (response.data && isSuccess(response.data)) {
      rows.value = normalizeRows(response.data.data)
      total.value = normalizeTotal(response.data.data)
    } else {
      rows.value = []
      total.value = 0
      errorMessage.value = response.data?.msg || '加载失败'
    }
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string } } }
    rows.value = []
    total.value = 0
    errorMessage.value = err.response?.data?.msg || '加载失败'
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  router.push({ query: { ...route.query, page: undefined, keyword: keyword.value || undefined } })
  fetchData()
}

const getRoleId = (roles: unknown) => {
  if (!Array.isArray(roles) || !roles.length) return 1002
  const roleId = Number((roles[0] as Row).id)
  return [1000, 1001, 1002].includes(roleId) ? roleId : 1002
}

const deleteDisabledReason = (row: Row) => {
  if (resource.value !== 'users') return ''
  const rowUid = getUserId(row)
  const currentUid = String(userStore.user?.uid ?? '')
  return rowUid && currentUid && rowUid === currentUid ? '不能删除当前登录账号' : ''
}

const openCreateDialog = () => {
  if (!config.value.formType) return
  dialogMode.value = 'create'
  activeFormType.value = config.value.formType
  dialogMessage.value = ''
  if (config.value.formType === 'announcement') {
    formData.value = {
      id: null,
      title: '',
      content: '',
      status: 0,
      uid: userStore.user?.uid || '',
      username: userStore.user?.username || '',
    }
  }
  showDialog.value = true
}

const handleCreate = () => {
  if (config.value.createPath) {
    router.push(config.value.createPath)
    return
  }
  openCreateDialog()
}

const openEditDialog = (row: Row) => {
  if (!config.value.formType) return
  dialogMode.value = 'edit'
  activeFormType.value = config.value.formType
  dialogMessage.value = ''
  if (config.value.formType === 'user') {
    formData.value = {
      uid: row.uid,
      username: row.username || '',
      realname: row.realname || '',
      email: row.email || '',
      password: '',
      type: getRoleId(row.roles),
      status: row.status ?? 0,
      setNewPwd: false,
    }
  } else {
    formData.value = { ...row }
  }
  showDialog.value = true
}

const saveForm = async () => {
  if (!activeFormType.value) return
  savingForm.value = true
  dialogMessage.value = ''
  try {
    const cid = Number(route.params.contestId || 0)
    const response = activeFormType.value === 'user'
      ? await adminApi.editUser(formData.value)
      : dialogMode.value === 'edit'
        ? await adminApi.updateAnnouncement(formData.value, cid || undefined)
        : await adminApi.createAnnouncement(formData.value, cid || undefined)

    if (isSuccess((response as { data: any }).data)) {
      showDialog.value = false
      fetchData()
    } else {
      dialogMessageType.value = 'error'
      dialogMessage.value = (response as { data: any }).data?.msg || '保存失败'
    }
  } finally {
    savingForm.value = false
  }
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  router.push({ query: { ...route.query, page: String(page) } })
  fetchData()
}

const handleDelete = async (row: Row) => {
  if (!config.value.deleteAction) return
  const disabledReason = deleteDisabledReason(row)
  if (disabledReason) {
    errorMessage.value = disabledReason
    return
  }
  if (!window.confirm('确认删除该记录？')) return
  try {
    await config.value.deleteAction(row)
    fetchData()
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string } } }
    errorMessage.value = err.response?.data?.msg || '删除失败'
  }
}

const toggleCurrentPageUsers = () => {
  if (isAllCurrentUsersSelected.value) {
    const pageIds = new Set(visibleUserIds.value)
    selectedUserIds.value = selectedUserIds.value.filter((id) => !pageIds.has(id))
    return
  }
  selectedUserIds.value = [...new Set([...selectedUserIds.value, ...visibleUserIds.value])]
}

const toggleUserSelection = (row: Row, event: MouseEvent) => {
  const id = getUserId(row)
  if (!id || deleteDisabledReason(row)) return

  const ids = visibleUserIds.value
  const isSelected = selectedUserIds.value.includes(id)
  const shouldSelect = !isSelected

  if (event.shiftKey && lastSelectedUserId.value) {
    const start = ids.indexOf(lastSelectedUserId.value)
    const end = ids.indexOf(id)
    if (start !== -1 && end !== -1) {
      const range = ids.slice(Math.min(start, end), Math.max(start, end) + 1)
      selectedUserIds.value = shouldSelect
        ? [...new Set([...selectedUserIds.value, ...range])]
        : selectedUserIds.value.filter((userId) => !range.includes(userId))
      lastSelectedUserId.value = id
      return
    }
  }

  selectedUserIds.value = shouldSelect
    ? [...selectedUserIds.value, id]
    : selectedUserIds.value.filter((userId) => userId !== id)
  lastSelectedUserId.value = id
}

const handleBatchDeleteUsers = async () => {
  if (!selectedUserIds.value.length) return
  if (!window.confirm(`确认删除选中的 ${selectedUserIds.value.length} 个用户？`)) return
  try {
    await adminApi.deleteUsers(selectedUserIds.value)
    selectedUserIds.value = []
    fetchData()
  } catch (error: unknown) {
    const err = error as { response?: { data?: { msg?: string } } }
    errorMessage.value = err.response?.data?.msg || '批量删除失败'
  }
}

const parseCsvLine = (line: string) => {
  const result: string[] = []
  let current = ''
  let quoted = false
  for (let index = 0; index < line.length; index += 1) {
    const char = line[index]
    const next = line[index + 1]
    if (char === '"' && quoted && next === '"') {
      current += '"'
      index += 1
    } else if (char === '"') {
      quoted = !quoted
    } else if (char === ',' && !quoted) {
      result.push(current.trim())
      current = ''
    } else {
      current += char
    }
  }
  result.push(current.trim())
  return result
}

const escapeCsvCell = (value: string) => {
  if (/[",\r\n]/.test(value)) {
    return `"${value.replace(/"/g, '""')}"`
  }
  return value
}

const downloadUserImportTemplate = () => {
  const csvText = userImportTemplateRows
    .map((row) => row.map((cell) => escapeCsvCell(cell)).join(','))
    .join('\r\n')
  downloadBlob(new Blob([`\uFEFF${csvText}\r\n`], { type: 'text/csv;charset=utf-8' }), 'foj-user-import-template.csv')
}

const handleCsvFile = async (event: Event) => {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const text = await file.text()
  const rows = text
    .split(/\r?\n/)
    .map((line) => parseCsvLine(line))
    .filter((row, index) => index !== 0 || row[0]?.toLowerCase() !== 'username')
    .filter((row) => row[0] && row[1])
  uploadUsers.value = rows
}

const importUsers = async () => {
  if (!uploadUsers.value.length) return
  importingUsers.value = true
  const response = await adminApi.importUsers(uploadUsers.value)
  importingUsers.value = false
  if (isSuccess(response.data)) {
    uploadUsers.value = []
    fetchData()
  } else {
    errorMessage.value = response.data.msg || '导入用户失败'
  }
}

const downloadBlob = (blob: Blob, filename: string) => {
  if (!blob || blob.size === 0) {
    errorMessage.value = '下载文件为空，请重新生成后再下载'
    return
  }
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  link.remove()
  window.setTimeout(() => URL.revokeObjectURL(url), 1000)
}

const getBlobErrorMessage = async (error: unknown) => {
  const responseData = (error as Row)?.response?.data
  if (responseData instanceof Blob) {
    const text = await responseData.text()
    if (text) {
      try {
        const data = JSON.parse(text)
        return data?.msg || data?.message || text
      } catch {
        return text
      }
    }
  }
  return (error as Row)?.response?.data?.msg || (error as Error)?.message || '生成用户失败'
}

const generateUsers = async () => {
  if (!generateForm.value.prefix && !generateForm.value.suffix) {
    errorMessage.value = '请填写前缀或后缀，避免生成纯数字用户名'
    return
  }
  if (generateForm.value.number_to < generateForm.value.number_from) {
    errorMessage.value = '结束编号不能小于起始编号'
    return
  }
  if (generateForm.value.password_length < 6 || generateForm.value.password_length > 25) {
    errorMessage.value = '密码长度需要在 6 到 25 之间'
    return
  }
  generatingUsers.value = true
  try {
    const response = await adminApi.generateUsersExcel(generateForm.value)
    downloadBlob(response.data, `users-${dayjs().format('YYYYMMDD-HHmmss')}.xlsx`)
    fetchData()
  } catch (error) {
    errorMessage.value = await getBlobErrorMessage(error)
  } finally {
    generatingUsers.value = false
  }
}

const openPublicProblemDialog = async () => {
  showPublicProblemDialog.value = true
  await loadPublicProblems(1)
}

const loadPublicProblems = async (page = 1) => {
  publicProblemPage.value = page
  publicProblemLoading.value = true
  try {
    const contestResponse = await adminApi.getContest(Number(route.params.contestId))
    const contest = isSuccess(contestResponse.data) ? contestResponse.data.data as Row : {}
    const problemType = typeof contest.type === 'number' ? contest.type : undefined
    if (problemType === undefined) {
      errorMessage.value = contestResponse.data?.msg || '无法获取比赛赛制，公开题库筛选失败'
      publicProblems.value = []
      publicProblemTotal.value = 0
      return
    }
    const response = await adminApi.getProblemList({
      page,
      page_size: publicProblemPageSize,
      keyword: publicProblemKeyword.value || undefined,
      problemType,
      cid: Number(route.params.contestId),
    })
    if (isSuccess(response.data)) {
      const data = response.data.data as Row
      const pageData = data.problemList ?? data
      publicProblems.value = getPageRecords(pageData) as Row[]
      publicProblemTotal.value = getPageTotal(pageData)
      publicProblemDisplayIds.value = Object.fromEntries(publicProblems.value.map((row) => [String(row.id), row.problemId || String(row.id)]))
    }
  } finally {
    publicProblemLoading.value = false
  }
}

const addPublicProblem = async (row: Row) => {
  addingPublicProblemId.value = Number(row.id)
  try {
    const response = await adminApi.addContestProblemFromPublic({
      pid: row.id,
      cid: Number(route.params.contestId),
      displayId: publicProblemDisplayIds.value[String(row.id)] || row.problemId || String(row.id),
    })
    if (isSuccess(response.data)) {
      await loadPublicProblems(publicProblemPage.value)
      fetchData()
    } else {
      errorMessage.value = response.data.msg || '添加失败'
    }
  } finally {
    addingPublicProblemId.value = 0
  }
}

onMounted(() => {
  currentPage.value = Number(route.query.page || 1)
  keyword.value = String(route.query.keyword || '')
  fetchData()
})

watch(resource, () => {
  rows.value = []
  total.value = 0
  currentPage.value = 1
  keyword.value = ''
  onlyAdmin.value = false
  fetchData()
})
</script>

<style scoped>
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

.admin-actions-header {
  width: 14rem;
  text-align: center !important;
}

.admin-actions-cell {
  width: 14rem;
  white-space: nowrap;
}

.admin-actions {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
}
</style>
