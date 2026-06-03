<template>
  <div class="admin-shell min-h-[calc(100vh-4rem)]">
    <div class="flex min-h-[calc(100vh-4rem)]">
      <aside class="hidden lg:flex w-72 shrink-0 flex-col border-r border-border bg-card/80">
        <div class="px-5 py-5 border-b border-border">
          <div class="text-xs font-semibold uppercase tracking-wider text-muted-foreground">FOJ Console</div>
          <div class="mt-1 text-xl font-bold">管理后台</div>
          <div class="mt-4 flex items-center gap-3">
            <div class="h-9 w-9 rounded-lg bg-primary/15 text-primary flex items-center justify-center font-semibold">
              {{ userInitial }}
            </div>
            <div class="min-w-0">
              <div class="truncate text-sm font-medium">{{ userStore.user?.username || '-' }}</div>
              <div class="text-xs text-muted-foreground">{{ roleText }}</div>
            </div>
          </div>
        </div>

        <nav class="flex-1 overflow-y-auto px-3 py-4">
          <div v-for="group in visibleNavGroups" :key="group.title" class="mb-5 last:mb-0">
            <div class="px-3 pb-2 text-xs font-semibold text-muted-foreground">{{ group.title }}</div>
            <div class="space-y-1">
              <RouterLink
                v-for="item in group.items"
                :key="item.path"
                :to="item.path"
                class="admin-nav-link"
                :class="isActive(item.path) ? 'admin-nav-link-active' : 'text-muted-foreground hover:text-foreground hover:bg-secondary/70'"
              >
                <span class="h-1.5 w-1.5 rounded-full" :class="isActive(item.path) ? 'bg-primary-foreground' : 'bg-muted-foreground/40'" />
                {{ item.title }}
              </RouterLink>
            </div>
          </div>
        </nav>
      </aside>

      <div class="flex-1 min-w-0">
        <div class="lg:hidden border-b border-border bg-card/80">
          <div class="px-4 py-3 flex items-center justify-between">
            <div>
              <div class="font-semibold">管理后台</div>
              <div class="text-xs text-muted-foreground">{{ userStore.user?.username || '-' }} · {{ roleText }}</div>
            </div>
            <select
              class="h-9 max-w-44 px-3 bg-input border border-border rounded-lg text-sm"
              :value="route.path"
              @change="router.push(($event.target as HTMLSelectElement).value)"
            >
              <option v-for="item in visibleNavItems" :key="item.path" :value="item.path">
                {{ item.title }}
              </option>
            </select>
          </div>
        </div>

        <main class="admin-main">
          <RouterView />
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { RouterLink, RouterView, useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const roleText = computed(() => {
  if (userStore.isSuperAdmin) return '超级管理员'
  return '管理员'
})

type NavItem = {
  title: string
  path: string
  superOnly?: boolean
}

const navGroups: Array<{ title: string; items: NavItem[] }> = [
  {
    title: '概览',
    items: [
      { title: '仪表盘', path: '/admin' },
      { title: '公告管理', path: '/admin/announcement' },
    ],
  },
  {
    title: '题库',
    items: [
      { title: '题目管理', path: '/admin/problems' },
      { title: '创建题目', path: '/admin/problem/create' },
      { title: '标签管理', path: '/admin/problem/tag' },
    ],
  },
  {
    title: '比赛',
    items: [
      { title: '比赛管理', path: '/admin/contest' },
      { title: '创建比赛', path: '/admin/contest/create' },
    ],
  },
  {
    title: '系统',
    items: [
      { title: '用户管理', path: '/admin/user', superOnly: true },
      { title: '系统配置', path: '/admin/conf', superOnly: true },
      { title: '系统开关', path: '/admin/switch', superOnly: true },
    ],
  },
]

const visibleNavGroups = computed(() =>
  navGroups
    .map((group) => ({
      ...group,
      items: group.items.filter((item) => !item.superOnly || userStore.isSuperAdmin),
    }))
    .filter((group) => group.items.length > 0)
)

const visibleNavItems = computed(() => visibleNavGroups.value.flatMap((group) => group.items))

const userInitial = computed(() => (userStore.user?.username || 'A').charAt(0).toUpperCase())

const isActive = (path: string) => {
  if (path === '/admin') return route.path === '/admin'
  return route.path.startsWith(path)
}
</script>
