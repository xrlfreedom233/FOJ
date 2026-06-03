import api from './index'
import type { RankListResponse, PaginationParams } from '@/types'
import { toBackendPageParams } from './adapter'

export const rankApi = {
  getList(params?: PaginationParams) {
    return api.get<RankListResponse>('/get-rank-list', {
      params: {
        ...toBackendPageParams(params),
        type: 0,
      },
    })
  },
}
