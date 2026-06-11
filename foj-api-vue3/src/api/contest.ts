import api from './index'
import type {
  ContestListResponse,
  ContestDetailResponse,
  ContestRankResponse,
  PaginationParams,
  ApiResponse,
} from '@/types'
import { toBackendPageParams } from './adapter'

export interface ContestQueryParams extends PaginationParams {
  keyword?: string
  status?: number
  type?: number
}

export interface ContestSubmissionQueryParams extends PaginationParams {
  onlyMine?: boolean
  problemID?: string
  status?: number
  language?: string
  username?: string
}

export const contestApi = {
  getList(params?: ContestQueryParams) {
    const backendParams = toBackendPageParams(params)
    if (typeof backendParams?.status === 'number') {
      backendParams.status = backendParams.status === 0 ? -1 : backendParams.status === 1 ? 0 : 1
    }
    return api.get<ContestListResponse>('/get-contest-list', { params: backendParams })
  },

  getDetail(cid: number) {
    return api.get<ContestDetailResponse>('/get-contest-info', { params: { cid } })
  },

  getProblems(cid: number) {
    return api.get<ApiResponse<unknown[]>>('/get-contest-problem', { params: { cid } })
  },

  getRank(cid: number, params?: PaginationParams) {
    return api.post<ContestRankResponse>('/get-contest-rank', {
      cid,
      currentPage: params?.page ?? 1,
      limit: params?.page_size ?? 50,
      forceRefresh: false,
    })
  },

  getAnnouncements(cid: number, params?: PaginationParams) {
    return api.get<ApiResponse<unknown>>('/get-contest-announcement', {
      params: toBackendPageParams({
        page: params?.page ?? 1,
        page_size: params?.page_size ?? 20,
        cid,
      }),
    })
  },

  register(cid: number, password?: string) {
    return api.post<ApiResponse>('/register-contest', { cid, password })
  },

  getAccess(cid: number) {
    return api.get<ApiResponse<{ access: boolean }>>('/get-contest-access', { params: { cid } })
  },

  getProblem(cid: number, index: string) {
    return api.get<ApiResponse>('/get-contest-problem-details', {
      params: { cid, displayId: index },
    })
  },

  getSubmissions(cid: number, params?: ContestSubmissionQueryParams) {
    const backendParams = toBackendPageParams({
      ...params,
      contestID: cid,
      beforeContestSubmit: false,
      completeProblemID: true,
      containsEnd: true,
    })
    return api.get<ApiResponse<unknown>>('/contest-submissions', { params: backendParams })
  },
}
