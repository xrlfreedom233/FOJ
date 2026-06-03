<template>
  <div class="flex flex-col items-center justify-center py-12 text-center">
    <div class="w-16 h-16 mb-4 text-muted-foreground">
      <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="1.5"
          d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
        />
      </svg>
    </div>
    <h3 class="text-lg font-medium text-foreground mb-2">{{ title }}</h3>
    <p class="text-muted-foreground">{{ description }}</p>
    <slot />
  </div>
</template>

<script setup lang="ts">
interface Props {
  title?: string
  description?: string
}

withDefaults(defineProps<Props>(), {
  title: '暂无数据',
  description: '这里什么都没有',
})
</script>
