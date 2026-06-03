import api from './index'
import type { ApiResponse, PaginationParams } from '@/types'
import { toBackendPageParams } from './adapter'

export const adminApi = {
  logout() {
    return api.get<ApiResponse>('/admin/logout')
  },

  getDashboardInfo() {
    return api.get<ApiResponse<Record<string, number>>>('/admin/dashboard/get-dashboard-info')
  },

  getRecentSession() {
    return api.post<ApiResponse<Record<string, string>>>('/admin/dashboard/get-sessions')
  },

  getServiceInfo() {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/config/get-service-info')
  },

  getJudgeServiceInfo() {
    return api.get<ApiResponse<Array<Record<string, unknown>>>>('/admin/config/get-judge-service-info')
  },

  getUserList(params?: PaginationParams & { keyword?: string; onlyAdmin?: boolean }) {
    return api.get<ApiResponse<unknown>>('/admin/user/get-user-list', {
      params: toBackendPageParams(params),
    })
  },

  editUser(data: unknown) {
    return api.put<ApiResponse>('/admin/user/edit-user', data)
  },

  deleteUsers(ids: string[]) {
    return api.delete<ApiResponse>('/admin/user/delete-user', {
      data: { ids },
    })
  },

  importUsers(users: string[][]) {
    return api.post<ApiResponse>('/admin/user/insert-batch-user', { users })
  },

  generateUsers(data: Record<string, unknown>) {
    return api.post<ApiResponse<Record<string, unknown>>>('/admin/user/generate-user', data)
  },

  generateUsersExcel(data: Record<string, unknown>) {
    return api.post<Blob>('/admin/user/generate-user-excel', data, {
      responseType: 'blob',
      timeout: 120000,
    })
  },

  getAnnouncementList(params?: PaginationParams & { cid?: number }) {
    const backendParams = toBackendPageParams(params)
    const url = params?.cid ? '/admin/contest/announcement' : '/admin/announcement'
    return api.get<ApiResponse<unknown>>(url, { params: backendParams })
  },

  createAnnouncement(data: unknown, cid?: number) {
    return api.post<ApiResponse>(cid ? '/admin/contest/announcement' : '/admin/announcement', cid ? { announcement: data, cid } : data)
  },

  updateAnnouncement(data: unknown, cid?: number) {
    return api.put<ApiResponse>(cid ? '/admin/contest/announcement' : '/admin/announcement', cid ? { announcement: data, cid } : data)
  },

  deleteAnnouncement(aid: number, cid?: number) {
    return api.delete<ApiResponse>(cid ? '/admin/contest/announcement' : '/admin/announcement', {
      params: { aid },
    })
  },

  getWebConfig() {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/config/get-web-config')
  },

  setWebConfig(data: unknown) {
    return api.put<ApiResponse>('/admin/config/set-web-config', data)
  },

  getEmailConfig() {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/config/get-email-config')
  },

  setEmailConfig(data: unknown) {
    return api.put<ApiResponse>('/admin/config/set-email-config', data)
  },

  testEmail(email: string) {
    return api.post<ApiResponse>('/admin/config/test-email', { email })
  },

  deleteHomeCarousel(id: number) {
    return api.delete<ApiResponse>('/admin/config/home-carousel', { params: { id } })
  },

  getDbAndRedisConfig() {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/config/get-db-and-redis-config')
  },

  setDbAndRedisConfig(data: unknown) {
    return api.put<ApiResponse>('/admin/config/set-db-and-redis-config', data)
  },

  getSwitchConfig() {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/switch/info')
  },

  setSwitchConfig(data: unknown) {
    return api.put<ApiResponse>('/admin/switch/update', data)
  },

  getProblemList(params?: PaginationParams & { keyword?: string; auth?: number; oj?: string; cid?: number; problemType?: number }) {
    const backendParams = toBackendPageParams(params)
    const url = params?.cid ? '/admin/contest/get-problem-list' : '/admin/problem/get-problem-list'
    return api.get<ApiResponse<unknown>>(url, {
      params: backendParams,
    })
  },

  getProblem(pid: number, cid?: number) {
    return api.get<ApiResponse<Record<string, unknown>>>(cid ? '/admin/contest/problem' : '/admin/problem', {
      params: { pid },
    })
  },

  createProblem(data: unknown, cid?: number) {
    return api.post<ApiResponse>(cid ? '/admin/contest/problem' : '/admin/problem', data)
  },

  updateProblem(data: unknown, cid?: number) {
    return api.put<ApiResponse>(cid ? '/admin/contest/problem' : '/admin/problem', data)
  },

  deleteProblem(pid: number, cid?: number) {
    return api.delete<ApiResponse>(cid ? '/admin/contest/problem' : '/admin/problem', {
      params: { pid, cid },
    })
  },

  changeProblemAuth(data: unknown) {
    return api.put<ApiResponse>('/admin/problem/change-problem-auth', data)
  },

  getProblemCases(pid: number, isUpload = true) {
    return api.get<ApiResponse<unknown[]>>('/admin/problem/get-problem-cases', {
      params: { pid, isUpload },
    })
  },

  compileSpj(data: unknown) {
    return api.post<ApiResponse>('/admin/problem/compile-spj', data)
  },

  compileInteractive(data: unknown) {
    return api.post<ApiResponse>('/admin/problem/compile-interactive', data)
  },

  getAllProblemTags(oj = 'ALL') {
    return api.get<ApiResponse<unknown[]>>('/get-all-problem-tags', { params: { oj } })
  },

  getProblemTagsAndClassification(oj = 'ME') {
    return api.get<ApiResponse<unknown[]>>('/get-problem-tags-and-classification', { params: { oj } })
  },

  getProblemTags(pid: number) {
    return api.get<ApiResponse<unknown[]>>('/get-problem-tags', { params: { pid } })
  },

  addTag(data: unknown) {
    return api.post<ApiResponse>('/admin/tag', data)
  },

  updateTag(data: unknown) {
    return api.put<ApiResponse>('/admin/tag', data)
  },

  deleteTag(tid: number) {
    return api.delete<ApiResponse>('/admin/tag', { params: { tid } })
  },

  getTagClassification(oj = 'ME') {
    return api.get<ApiResponse<unknown[]>>('/admin/tag/classification', { params: { oj } })
  },

  addTagClassification(data: unknown) {
    return api.post<ApiResponse>('/admin/tag/classification', data)
  },

  updateTagClassification(data: unknown) {
    return api.put<ApiResponse>('/admin/tag/classification', data)
  },

  deleteTagClassification(tcid: number) {
    return api.delete<ApiResponse>('/admin/tag/classification', { params: { tcid } })
  },

  getContestList(params?: PaginationParams & { keyword?: string }) {
    return api.get<ApiResponse<unknown>>('/admin/contest/get-contest-list', {
      params: toBackendPageParams(params),
    })
  },

  getContest(cid: number) {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/contest', { params: { cid } })
  },

  createContest(data: unknown) {
    return api.post<ApiResponse>('/admin/contest', data)
  },

  updateContest(data: unknown) {
    return api.put<ApiResponse>('/admin/contest', data)
  },

  deleteContest(cid: number) {
    return api.delete<ApiResponse>('/admin/contest', { params: { cid } })
  },

  cloneContest(cid: number) {
    return api.get<ApiResponse>('/admin/contest/clone', { params: { cid } })
  },

  changeContestVisible(cid: number, visible: boolean, uid: string) {
    return api.put<ApiResponse>('/admin/contest/change-contest-visible', null, {
      params: { cid, visible, uid },
    })
  },

  getContestProblemInfo(pid: number, cid: number) {
    return api.get<ApiResponse<Record<string, unknown>>>('/admin/contest/contest-problem', {
      params: { pid, cid },
    })
  },

  setContestProblemInfo(data: unknown) {
    return api.put<ApiResponse>('/admin/contest/contest-problem', data)
  },

  addContestProblemFromPublic(data: unknown) {
    return api.post<ApiResponse>('/admin/contest/add-problem-from-public', data)
  },

  uploadProblemArchive(kind: 'foj' | 'qduoj' | 'fps' | 'hydro', file: File) {
    const urlMap = {
      foj: '/file/import-problem',
      qduoj: '/file/import-qdoj-problem',
      fps: '/file/import-fps-problem',
      hydro: '/file/import-hydro-problem',
    }
    const formData = new FormData()
    formData.append('file', file)
    return api.post<ApiResponse>(urlMap[kind], formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      timeout: 120000,
    })
  },

  exportProblemZip(pids: number[]) {
    return api.get<Blob>('/file/export-problem', {
      params: { pid: pids },
      paramsSerializer: { indexes: null },
      responseType: 'blob',
      timeout: 120000,
    })
  },

  downloadGeneratedUsers(key: string) {
    return api.get<Blob>('/file/generate-user-excel', {
      params: { key },
      responseType: 'blob',
      timeout: 120000,
    })
  },

  rejudge(submitId: number) {
    return api.get<ApiResponse>('/admin/judge/rejudge', { params: { submitId } })
  },

  rejudgeContestProblem(cid: number, pid: number) {
    return api.get<ApiResponse>('/admin/judge/rejudge-contest-problem', { params: { cid, pid } })
  },

  manualJudge(submitId: number, status: number, score?: number) {
    return api.get<ApiResponse>('/admin/judge/manual-judge', { params: { submitId, status, score } })
  },

  cancelJudge(submitId: number) {
    return api.get<ApiResponse>('/admin/judge/cancel-judge', { params: { submitId } })
  },
}
