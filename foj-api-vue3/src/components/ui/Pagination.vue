<template>
  <nav class="flex items-center justify-center gap-1">
    <button
      @click="$emit('change', 1)"
      :disabled="currentPage === 1"
      class="p-2 rounded-lg hover:bg-secondary disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" />
      </svg>
    </button>
    <button
      @click="$emit('change', currentPage - 1)"
      :disabled="currentPage === 1"
      class="p-2 rounded-lg hover:bg-secondary disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
    </button>

    <template v-for="page in displayPages" :key="page">
      <span v-if="page === '...'" class="px-3 py-2 text-muted-foreground">...</span>
      <button
        v-else
        @click="$emit('change', Number(page))"
        :class="[
          'min-w-[40px] h-10 px-3 rounded-lg text-sm font-medium transition-colors',
          page === currentPage
            ? 'bg-primary text-primary-foreground'
            : 'hover:bg-secondary text-muted-foreground',
        ]"
      >
        {{ page }}
      </button>
    </template>

    <button
      @click="$emit('change', currentPage + 1)"
      :disabled="currentPage === totalPages"
      class="p-2 rounded-lg hover:bg-secondary disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
      </svg>
    </button>
    <button
      @click="$emit('change', totalPages)"
      :disabled="currentPage === totalPages"
      class="p-2 rounded-lg hover:bg-secondary disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
      </svg>
    </button>
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  currentPage: number
  totalPages: number
  maxVisible?: number
}

const props = withDefaults(defineProps<Props>(), {
  maxVisible: 5,
})

defineEmits<{
  change: [page: number]
}>()

const displayPages = computed(() => {
  const pages: (number | string)[] = []
  const total = props.totalPages
  const current = props.currentPage
  const maxVisible = props.maxVisible

  if (total <= maxVisible + 2) {
    for (let i = 1; i <= total; i++) {
      pages.push(i)
    }
  } else {
    pages.push(1)

    if (current <= 3) {
      for (let i = 2; i <= Math.min(maxVisible, total - 1); i++) {
        pages.push(i)
      }
      pages.push('...')
    } else if (current >= total - 2) {
      pages.push('...')
      for (let i = total - maxVisible + 1; i < total; i++) {
        pages.push(i)
      }
    } else {
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) {
        pages.push(i)
      }
      pages.push('...')
    }

    pages.push(total)
  }

  return pages
})
</script>
