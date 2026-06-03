import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User } from '@/types'
import { authApi } from '@/api/auth'

const readStoredUser = (): User | null => {
  try {
    const raw = localStorage.getItem('userInfo')
    return raw ? JSON.parse(raw) as User : null
  } catch {
    localStorage.removeItem('userInfo')
    return null
  }
}

export const useUserStore = defineStore('user', () => {
  const token = ref<string | null>(localStorage.getItem('token'))
  const user = ref<User | null>(readStoredUser())

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => {
    const roles = user.value?.roleList ?? (user.value?.role ? [user.value.role] : [])
    return roles.some((role) => ['root', 'admin'].includes(role))
  })
  const isSuperAdmin = computed(() => (user.value?.roleList ?? []).includes('root'))

  const setToken = (newToken: string) => {
    token.value = newToken
    localStorage.setItem('token', newToken)
  }

  const setUser = (newUser: User) => {
    const roleList = newUser.roleList ?? (newUser as unknown as { roles?: string[] }).roles ?? user.value?.roleList ?? []
    const mergedUser = {
      ...user.value,
      ...newUser,
      uid: newUser.uid === undefined || newUser.uid === null ? String(user.value?.uid ?? '') : String(newUser.uid),
      role: newUser.role ?? roleList[0] ?? 'user',
      roleList,
    }
    user.value = mergedUser
    localStorage.setItem('userInfo', JSON.stringify(mergedUser))
  }

  const login = async (username: string, password: string) => {
    try {
      const response = await authApi.login({ username, password })
      if (response.data.status === 200) {
        const token = response.headers.authorization
        if (token) {
          setToken(token)
        }
        setUser(response.data.data)
        return { success: true }
      }
      return { success: false, message: response.data.msg }
    } catch (error: unknown) {
      const err = error as { response?: { data?: { msg?: string } } }
      return { success: false, message: err.response?.data?.msg || '登录失败' }
    }
  }

  const register = async (username: string, password: string, email: string, code: string, nickname?: string) => {
    try {
      const response = await authApi.register({ username, password, email, code, nickname })
      if (response.data.status === 200) {
        return { success: true }
      }
      return { success: false, message: response.data.msg }
    } catch (error: unknown) {
      const err = error as { response?: { data?: { msg?: string } } }
      return { success: false, message: err.response?.data?.msg || '注册失败' }
    }
  }

  const adminLogin = async (username: string, password: string) => {
    try {
      const response = await authApi.adminLogin({ username, password })
      if (response.data.status === 200) {
        const token = response.headers.authorization
        if (token) {
          setToken(token)
        }
        setUser(response.data.data)
        return { success: true }
      }
      return { success: false, message: response.data.msg }
    } catch (error: unknown) {
      const err = error as { response?: { data?: { msg?: string } } }
      return { success: false, message: err.response?.data?.msg || '管理员登录失败' }
    }
  }

  const requestRegisterCode = async (email: string) => {
    try {
      const response = await authApi.getRegisterCode(email)
      if (response.data.status === 200) {
        return { success: true, data: response.data.data }
      }
      return { success: false, message: response.data.msg }
    } catch (error: unknown) {
      const err = error as { response?: { data?: { msg?: string } } }
      return { success: false, message: err.response?.data?.msg || '验证码发送失败' }
    }
  }

  const logout = () => {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  const fetchProfile = async () => {
    if (!token.value) return
    try {
      const response = await authApi.getProfile()
      if (response.data.status === 200) {
        const authInfo = response.data.data as unknown as { roles?: string[]; roleList?: string[]; avatar?: string; email?: string }
        const roles = authInfo.roles ?? authInfo.roleList
        if (roles) {
          setUser({
            ...response.data.data,
            roleList: roles,
            role: roles[0] ?? user.value?.role ?? 'user',
          })
          return
        }
        setUser(response.data.data)
      }
    } catch {
      logout()
    }
  }

  // Initialize user data if token exists
  if (token.value && !user.value) {
    fetchProfile()
  }

  return {
    token,
    user,
    isLoggedIn,
    isAdmin,
    isSuperAdmin,
    setToken,
    login,
    adminLogin,
    register,
    requestRegisterCode,
    logout,
    fetchProfile,
    setUser,
  }
})
