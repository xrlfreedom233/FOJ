import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import './styles/main.css'

const savedTheme = localStorage.getItem('theme') === 'dark' ? 'dark' : 'light'
document.documentElement.classList.toggle('theme-dark', savedTheme === 'dark')
document.documentElement.dataset.theme = savedTheme

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
