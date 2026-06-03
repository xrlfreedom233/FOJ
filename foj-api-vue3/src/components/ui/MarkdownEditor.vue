<template>
  <div class="markdown-editor">
    <div class="markdown-editor__bar">
      <span class="text-sm font-medium">{{ label }}</span>
      <div class="markdown-editor__tabs">
        <button
          type="button"
          class="markdown-editor__tab"
          :class="{ 'markdown-editor__tab--active': mode === 'edit' }"
          @click="mode = 'edit'"
        >
          编辑
        </button>
        <button
          type="button"
          class="markdown-editor__tab"
          :class="{ 'markdown-editor__tab--active': mode === 'preview' }"
          @click="mode = 'preview'"
        >
          预览
        </button>
      </div>
    </div>
    <textarea
      v-if="mode === 'edit'"
      :value="modelValue"
      class="markdown-editor__textarea"
      :rows="rows"
      spellcheck="false"
      @input="$emit('update:modelValue', ($event.target as HTMLTextAreaElement).value)"
    />
    <div v-else class="markdown-preview markdown-editor__preview" v-html="previewHtml"></div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { renderMarkdown } from '@/utils/markdown'

const props = withDefaults(defineProps<{
  modelValue: string
  label: string
  rows?: number
}>(), {
  rows: 6,
})

defineEmits<{
  'update:modelValue': [value: string]
}>()

const mode = ref<'edit' | 'preview'>('edit')
const previewHtml = computed(() => renderMarkdown(props.modelValue || ''))
</script>

<style scoped>
.markdown-editor {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
}

.markdown-editor__bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
}

.markdown-editor__tabs {
  display: inline-flex;
  overflow: hidden;
  border: 1px solid theme('colors.border');
  border-radius: 0.5rem;
  background: theme('colors.input');
}

.markdown-editor__tab {
  min-width: 3.5rem;
  padding: 0.375rem 0.625rem;
  font-size: 0.8125rem;
  color: theme('colors.muted-foreground');
}

.markdown-editor__tab--active {
  background: theme('colors.primary');
  color: theme('colors.primary-foreground');
}

.markdown-editor__textarea,
.markdown-editor__preview {
  width: 100%;
  min-height: 10rem;
  border-radius: 0.5rem;
  border: 1px solid theme('colors.border');
  background: theme('colors.input');
  padding: 0.75rem;
  outline: none;
}

.markdown-editor__textarea {
  resize: vertical;
}

.markdown-editor__textarea:focus {
  box-shadow: 0 0 0 2px theme('colors.ring');
}

.markdown-editor__preview {
  overflow: auto;
}
</style>
