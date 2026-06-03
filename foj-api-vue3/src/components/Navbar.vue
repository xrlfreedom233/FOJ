<template>
  <nav class="sticky top-0 z-50 bg-card/95 backdrop-blur-sm border-b border-border">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <RouterLink to="/" class="flex items-center gap-3 group" aria-label="FOJ 首页">
          <svg
            class="h-10 w-10 shrink-0 transition-transform duration-200 group-hover:-translate-y-0.5"
            viewBox="0 0 40 40"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            aria-hidden="true"
          >
            <rect width="40" height="40" rx="10" fill="#0F172A" />
            <path d="M10.4 15.8L6.4 20L10.4 24.2" stroke="#22D3EE" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M29.6 15.8L33.6 20L29.6 24.2" stroke="#22D3EE" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round" />
            <path d="M22.4 10.2L17.6 29.8" stroke="#F8FAFC" stroke-width="3.8" stroke-linecap="round" />
            <path d="M13.2 10.5H27.2" stroke="#F59E0B" stroke-width="2.8" stroke-linecap="round" />
            <path d="M12.8 29.5H26.8" stroke="#F59E0B" stroke-width="2.8" stroke-linecap="round" />
          </svg>
          <span class="flex items-baseline gap-1 text-2xl font-black tracking-normal leading-none">
            <span class="text-cyan-400">F</span>
            <span class="text-emerald-400">O</span>
            <span class="text-amber-400">J</span>
          </span>
        </RouterLink>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center gap-1">
          <RouterLink
            v-for="link in navLinks"
            :key="link.path"
            :to="link.path"
            class="px-4 py-2 rounded-lg text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
            :class="{ 'text-primary bg-primary/10': isActive(link.activePath || link.path) }"
          >
            {{ link.name }}
          </RouterLink>
        </div>

        <!-- User Menu -->
        <div class="flex items-center gap-3">
          <button
            class="h-9 px-3 rounded-lg border border-border bg-secondary/50 text-xs font-medium text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
            :title="theme === 'dark' ? '切换明亮模式' : '切换暗色模式'"
            @click="toggleTheme"
          >
            {{ theme === 'dark' ? '明亮' : '暗色' }}
          </button>

          <template v-if="userStore.isLoggedIn">
            <div class="relative" ref="dropdownRef">
              <button
                @click="showDropdown = !showDropdown"
                class="flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-secondary transition-colors"
              >
                <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center overflow-hidden">
                  <img
                    v-if="userStore.user?.avatar"
                    :src="userStore.user.avatar"
                    :alt="displayName"
                    class="w-full h-full object-cover"
                  />
                  <span v-else class="text-primary font-medium">
                    {{ displayName.charAt(0).toUpperCase() }}
                  </span>
                </div>
                <span class="hidden sm:block text-sm font-medium">
                  {{ displayName }}
                </span>
                <svg
                  class="w-4 h-4 text-muted-foreground transition-transform"
                  :class="{ 'rotate-180': showDropdown }"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              <!-- Dropdown Menu -->
              <Transition
                enter-active-class="transition ease-out duration-100"
                enter-from-class="transform opacity-0 scale-95"
                enter-to-class="transform opacity-100 scale-100"
                leave-active-class="transition ease-in duration-75"
                leave-from-class="transform opacity-100 scale-100"
                leave-to-class="transform opacity-0 scale-95"
              >
                <div
                  v-if="showDropdown"
                  class="absolute right-0 mt-2 w-48 bg-card rounded-lg shadow-lg border border-border py-1"
                >
                  <RouterLink
                    to="/profile"
                    class="block px-4 py-2 text-sm text-foreground hover:bg-secondary"
                    @click="showDropdown = false"
                  >
                    个人中心
                  </RouterLink>
                  <RouterLink
                    to="/submissions?mine=1"
                    class="block px-4 py-2 text-sm text-foreground hover:bg-secondary"
                    @click="showDropdown = false"
                  >
                    我的提交
                  </RouterLink>
                  <RouterLink
                    v-if="userStore.isAdmin"
                    to="/admin"
                    class="block px-4 py-2 text-sm text-foreground hover:bg-secondary"
                    @click="showDropdown = false"
                  >
                    管理后台
                  </RouterLink>
                  <hr class="my-1 border-border" />
                  <button
                    @click="handleLogout"
                    class="block w-full text-left px-4 py-2 text-sm text-destructive hover:bg-secondary"
                  >
                    退出登录
                  </button>
                </div>
              </Transition>
            </div>
          </template>
          <template v-else>
            <RouterLink
              to="/login"
              class="px-4 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
            >
              登录
            </RouterLink>
            <RouterLink
              to="/admin/login"
              class="px-4 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
            >
              管理端
            </RouterLink>
            <RouterLink
              to="/register"
              class="px-4 py-2 bg-primary text-primary-foreground text-sm font-medium rounded-lg hover:bg-primary/90 transition-colors"
            >
              注册
            </RouterLink>
          </template>

          <!-- Mobile Menu Button -->
          <button
            @click="showMobile = !showMobile"
            class="md:hidden p-2 rounded-lg hover:bg-secondary"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                v-if="!showMobile"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"
              />
              <path
                v-else
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M6 18L18 6M6 6l12 12"
              />
            </svg>
          </button>
        </div>
      </div>

      <!-- Mobile Navigation -->
      <Transition
        enter-active-class="transition ease-out duration-200"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition ease-in duration-150"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div v-if="showMobile" class="md:hidden pb-4">
          <RouterLink
            v-for="link in navLinks"
            :key="link.path"
            :to="link.path"
            class="block px-4 py-2 rounded-lg text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-secondary"
            :class="{ 'text-primary bg-primary/10': isActive(link.activePath || link.path) }"
            @click="showMobile = false"
          >
            {{ link.name }}
          </RouterLink>
        </div>
      </Transition>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { onClickOutside } from '@vueuse/core'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const showDropdown = ref(false)
const showMobile = ref(false)
const dropdownRef = ref<HTMLElement | null>(null)
const theme = ref<'light' | 'dark'>('light')
const displayName = computed(() => userStore.user?.username || userStore.user?.nickname || '用户')

const navLinks = computed(() => [
  { name: '首页', path: '/' },
  { name: '题库', path: '/problems' },
  { name: '比赛', path: '/contests' },
  { name: '提交记录', path: userStore.isLoggedIn ? '/submissions?mine=1' : '/submissions', activePath: '/submissions' },
  { name: '排行榜', path: '/rank' },
])

const isActive = (path: string) => {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}

const handleLogout = () => {
  userStore.logout()
  showDropdown.value = false
  router.push('/')
}

const applyTheme = (nextTheme: 'light' | 'dark') => {
  theme.value = nextTheme
  document.documentElement.classList.toggle('theme-dark', nextTheme === 'dark')
  document.documentElement.dataset.theme = nextTheme
  localStorage.setItem('theme', nextTheme)
}

const toggleTheme = () => {
  applyTheme(theme.value === 'dark' ? 'light' : 'dark')
}

onMounted(() => {
  const savedTheme = localStorage.getItem('theme') === 'dark' ? 'dark' : 'light'
  applyTheme(savedTheme)
})

onClickOutside(dropdownRef, () => {
  showDropdown.value = false
})
</script>
