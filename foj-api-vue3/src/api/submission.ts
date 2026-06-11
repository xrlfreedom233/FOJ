import api from './index'
import type {
  SubmissionListResponse,
  SubmissionDetailResponse,
  SubmitRequest,
  ApiResponse,
  PaginationParams,
} from '@/types'
import { toBackendPageParams } from './adapter'

export interface SubmissionQueryParams extends PaginationParams {
  pid?: number
  uid?: string
  username?: string
  language?: string
  status?: number
}

export const submissionApi = {
  getList(params?: SubmissionQueryParams) {
    const backendParams = toBackendPageParams(params)
    if (backendParams?.pid) {
      backendParams.problemID = String(backendParams.pid)
      delete backendParams.pid
    }
    if (backendParams?.uid) {
      backendParams.onlyMine = true
      delete backendParams.uid
    }
    return api.get<SubmissionListResponse>('/get-submission-list', { params: backendParams })
  },

  getDetail(sid: number) {
    return api.get<SubmissionDetailResponse>('/get-submission-detail', {
      params: { submitId: sid },
    })
  },

  checkStatuses(submitIds: number[]) {
    return api.post<ApiResponse<Record<number, unknown>>>('/check-submissions-status', {
      submitIds,
    })
  },

  checkContestStatuses(cid: number, submitIds: number[]) {
    return api.post<ApiResponse<Record<number, unknown>>>('/check-contest-submissions-status', {
      cid,
      submitIds,
    })
  },

  submit(data: SubmitRequest) {
    return api.post<ApiResponse<{ submitId?: number; sid?: number }>>('/submit-problem-judge', {
      ...data,
      pid: String(data.pid),
      cid: 0,
    })
  },

  // For contest submissions
  contestSubmit(cid: number, data: SubmitRequest) {
    return api.post<ApiResponse<{ submitId?: number; sid?: number }>>('/submit-problem-judge', {
      ...data,
      pid: String(data.pid),
      cid,
    })
  },
}
