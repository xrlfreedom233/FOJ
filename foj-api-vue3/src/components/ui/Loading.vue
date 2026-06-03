<template>
  <div class="flex items-center justify-center py-12">
    <div class="flex flex-col items-center gap-4">
      <div class="relative">
        <div class="w-12 h-12 border-4 border-secondary rounded-full"></div>
        <div class="absolute top-0 left-0 w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
      </div>
      <p v-if="text" class="text-muted-foreground">{{ text }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  text?: string
}

withDefaults(defineProps<Props>(), {
  text: '加载中...',
})
</script>
