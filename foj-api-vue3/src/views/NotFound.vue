<template>
  <div class="min-h-[calc(100vh-4rem)] flex items-center justify-center p-4">
    <div class="text-center">
      <h1 class="text-6xl font-bold text-primary mb-4">404</h1>
      <h2 class="text-2xl font-semibold mb-4">页面未找到</h2>
      <p class="text-muted-foreground mb-8">抱歉，您访问的页面不存在</p>
      <RouterLink
        to="/"
        class="inline-block px-6 py-3 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors"
      >
        返回首页
      </RouterLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { RouterLink } from 'vue-router'
</script>
