import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 3000,
    allowedHosts: ['sb-6scf8zqb7arv.vercel.run'],
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:6688',
        changeOrigin: true,
      },
    },
  },
})
