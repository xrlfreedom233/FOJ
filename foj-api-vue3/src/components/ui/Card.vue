<template>
  <div
    class="bg-card border border-border rounded-xl overflow-hidden"
    :class="[hover && 'card-hover cursor-pointer', className]"
  >
    <div v-if="$slots.header" class="px-6 py-4 border-b border-border">
      <slot name="header" />
    </div>
    <div :class="['px-6 py-4', noPadding && 'p-0']">
      <slot />
    </div>
    <div v-if="$slots.footer" class="px-6 py-4 border-t border-border bg-secondary/30">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  hover?: boolean
  noPadding?: boolean
  className?: string
}

withDefaults(defineProps<Props>(), {
  hover: false,
  noPadding: false,
})
</script>
