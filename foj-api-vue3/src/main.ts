import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import './styles/main.css'

const STALE_CHUNK_RELOAD_KEY = 'foj:stale-chunk-reloaded'

router.onError((error) => {
  const message = String(error?.message || error)
  const isStaleChunk = /loading dynamically imported module|Failed to fetch dynamically imported module|Importing a module script failed/i.test(message)

  if (isStaleChunk && sessionStorage.getItem(STALE_CHUNK_RELOAD_KEY) !== '1') {
    sessionStorage.setItem(STALE_CHUNK_RELOAD_KEY, '1')
    window.location.reload()
  }
})

router.afterEach(() => {
  sessionStorage.removeItem(STALE_CHUNK_RELOAD_KEY)
})

const savedTheme = localStorage.getItem('theme') === 'dark' ? 'dark' : 'light'
document.documentElement.classList.toggle('theme-dark', savedTheme === 'dark')
document.documentElement.dataset.theme = savedTheme

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
