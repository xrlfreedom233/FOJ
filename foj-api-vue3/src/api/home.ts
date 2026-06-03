import api from './index'
import type { ApiResponse, PaginationParams } from '@/types'
import { toBackendPageParams } from './adapter'

export interface Announcement {
  id: number
  title: string
  content: string
  username?: string
  status: number
  gmtCreate?: string
  gmtModified?: string
}

export const homeApi = {
  getCommonAnnouncements(params?: PaginationParams) {
    return api.get<ApiResponse<{
      records?: Announcement[]
      list?: Announcement[]
      total?: number
    }>>('/get-common-announcement', {
      params: toBackendPageParams(params),
    })
  },
}
