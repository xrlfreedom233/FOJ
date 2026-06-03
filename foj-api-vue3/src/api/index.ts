import axios, { type AxiosInstance, type AxiosResponse, type InternalAxiosRequestConfig } from 'axios'
import { useUserStore } from '@/stores/user'

const api: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const userStore = useUserStore()
    if (userStore.token) {
      config.headers.Authorization = userStore.token
    }
    config.headers['Url-Type'] = config.url?.startsWith('/admin') ? 'admin' : 'general'
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor
api.interceptors.response.use(
  (response: AxiosResponse) => {
    const refreshedToken = response.headers['authorization']
    if (response.headers['refresh-token'] && refreshedToken) {
      const userStore = useUserStore()
      userStore.setToken(refreshedToken)
    }
    return response
  },
  (error) => {
    const refreshedToken = error.response?.headers?.['authorization']
    if (error.response?.headers?.['refresh-token'] && refreshedToken) {
      const userStore = useUserStore()
      userStore.setToken(refreshedToken)
    }
    if (error.response?.status === 401) {
      const userStore = useUserStore()
      userStore.logout()
      window.location.href = error.config?.headers?.['Url-Type'] === 'admin' ? '/admin/login' : '/login'
    }
    return Promise.reject(error)
  }
)

export default api
