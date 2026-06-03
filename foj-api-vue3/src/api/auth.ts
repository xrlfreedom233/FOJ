import api from './index'
import type {
  LoginRequest,
  RegisterRequest,
  AuthResponse,
  User,
  UserHomeInfo,
  ApiResponse,
} from '@/types'

export const authApi = {
  login(data: LoginRequest) {
    return api.post<AuthResponse>('/login', data)
  },

  adminLogin(data: LoginRequest) {
    return api.post<AuthResponse>('/admin/login', data)
  },

  register(data: RegisterRequest) {
    return api.post<AuthResponse>('/register', data)
  },

  getRegisterCode(email: string) {
    return api.get<ApiResponse<{ email: string; expire: number; code?: string }>>('/get-register-code', {
      params: { email },
    })
  },

  getCaptcha() {
    return api.get<ApiResponse<{ img: string; captchaKey: string }>>('/captcha')
  },

  applyResetPassword(data: { email: string; captcha: string; captchaKey: string }) {
    return api.post<ApiResponse>('/apply-reset-password', data)
  },

  resetPassword(data: { username: string; password: string; code: string }) {
    return api.post<ApiResponse>('/reset-password', data)
  },

  logout() {
    return api.get<ApiResponse>('/logout')
  },

  getProfile() {
    return api.get<ApiResponse<User>>('/get-user-auth-info')
  },

  getUserHomeInfo(params?: { uid?: string; username?: string }) {
    return api.get<ApiResponse<UserHomeInfo>>('/get-user-home-info', { params })
  },

  getUserCalendarHeatmap(params?: { uid?: string; username?: string }) {
    return api.get<ApiResponse<{
      endDate?: string
      dataList?: Array<{ date?: string; count?: number }>
    }>>('/get-user-calendar-heatmap', { params })
  },

  updateProfile(data: Partial<User>) {
    return api.post<ApiResponse<User>>('/change-userInfo', data)
  },

  checkUsername(username: string) {
    return api.post<ApiResponse<{ username?: boolean; email?: boolean }>>('/check-username-or-email', {
      username,
    })
  },

  uploadAvatar(file: File) {
    const formData = new FormData()
    formData.append('image', file)
    return api.post<ApiResponse<User>>('/file/upload-avatar', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
  },

  changePassword(data: { old_password: string; new_password: string }) {
    return api.post<ApiResponse<{ code?: number; msg?: string }>>('/change-password', {
      oldPassword: data.old_password,
      newPassword: data.new_password,
    })
  },

  getChangeEmailCode(email: string) {
    return api.get<ApiResponse>('/get-change-email-code', {
      params: { email },
    })
  },

  changeEmail(data: { password: string; newEmail: string; code: string }) {
    return api.post<ApiResponse<{ code?: number; msg?: string; userInfo?: User }>>('/change-email', data)
  },
}
