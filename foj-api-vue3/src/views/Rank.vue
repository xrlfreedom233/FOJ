<template>
  <div class="max-w-5xl mx-auto px-4 py-8">
    <Card no-padding>
      <template #header>
        <div class="flex items-center justify-between">
          <h1 class="text-xl font-bold">排行榜</h1>
          <span class="text-sm text-muted-foreground">共 {{ total }} 名用户</span>
        </div>
      </template>

      <Loading v-if="loading" />

      <div v-else-if="users.length === 0">
        <Empty title="暂无排名数据" description="快去刷题上榜吧！" />
      </div>

      <div v-else>
        <!-- Table Header -->
        <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 bg-secondary/50 text-sm font-medium text-muted-foreground border-b border-border">
          <div class="col-span-1">排名</div>
          <div class="col-span-5">用户</div>
          <div class="col-span-2">已通过</div>
          <div class="col-span-4">通过率</div>
        </div>

        <!-- User Items -->
        <div
          v-for="user in users"
          :key="user.uid"
          class="grid grid-cols-12 gap-4 px-6 py-4 items-center border-b border-border last:border-b-0 hover:bg-secondary/30 transition-colors"
        >
          <!-- Rank -->
          <div class="col-span-1">
            <span
              :class="[
                'inline-flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold',
                user.rank === 1 ? 'bg-yellow-500/20 text-yellow-500' :
                user.rank === 2 ? 'bg-gray-400/20 text-gray-400' :
                user.rank === 3 ? 'bg-amber-600/20 text-amber-600' :
                'bg-secondary text-muted-foreground',
              ]"
            >
              {{ user.rank }}
            </span>
          </div>

          <!-- User -->
          <div class="col-span-5 flex items-center gap-3">
            <div class="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center overflow-hidden">
              <img
                v-if="user.avatar"
                :src="user.avatar"
                :alt="user.username"
                class="w-full h-full object-cover"
              />
              <span v-else class="text-primary font-medium">
                {{ user.username.charAt(0).toUpperCase() }}
              </span>
            </div>
            <div>
              <div class="font-medium">{{ user.nickname || user.username }}</div>
              <div class="text-sm text-muted-foreground">@{{ user.username }}</div>
            </div>
          </div>

          <!-- Solved -->
          <div class="col-span-2">
            <span class="font-medium text-primary">{{ user.solved }}</span>
            <span class="text-muted-foreground"> / {{ user.submit }}</span>
          </div>

          <!-- Accept Rate -->
          <div class="col-span-4">
            <div class="flex items-center gap-2">
              <div class="flex-1 h-2 bg-secondary rounded-full overflow-hidden">
                <div
                  class="h-full bg-primary rounded-full transition-all"
                  :style="{ width: `${getAcceptRate(user)}%` }"
                ></div>
              </div>
              <span class="text-sm text-muted-foreground w-12">{{ getAcceptRate(user) }}%</span>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <div v-if="totalPages > 1" class="flex justify-center">
          <Pagination
            :current-page="currentPage"
            :total-pages="totalPages"
            @change="handlePageChange"
          />
        </div>
      </template>
    </Card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { rankApi } from '@/api/rank'
import { getPageRecords, getPageTotal, isSuccess, mapRankUser } from '@/api/adapter'
import type { RankUser } from '@/types'
import Card from '@/components/ui/Card.vue'
import Pagination from '@/components/ui/Pagination.vue'
import Loading from '@/components/ui/Loading.vue'
import Empty from '@/components/ui/Empty.vue'

const users = ref<RankUser[]>([])
const total = ref(0)
const loading = ref(false)
const currentPage = ref(1)
const pageSize = 50

const totalPages = computed(() => Math.ceil(total.value / pageSize))

const getAcceptRate = (user: RankUser) => {
  if (user.submit === 0) return 0
  return Math.round((user.solved / user.submit) * 100)
}

const fetchRank = async () => {
  loading.value = true
  try {
    const response = await rankApi.getList({
      page: currentPage.value,
      page_size: pageSize,
    })
    if (isSuccess(response.data)) {
      users.value = getPageRecords(response.data.data).map((user, index) =>
        mapRankUser(user, index, currentPage.value, pageSize)
      )
      total.value = getPageTotal(response.data.data)
    } else {
      users.value = []
      total.value = 0
    }
  } catch {
    users.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  fetchRank()
}

onMounted(fetchRank)
</script>
