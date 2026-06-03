import api from './index'
import type {
  ProblemListResponse,
  ProblemDetailResponse,
  PaginationParams,
  ApiResponse,
} from '@/types'
import { toBackendPageParams } from './adapter'

export interface ProblemQueryParams extends PaginationParams {
  keyword?: string
  difficulty?: number
  tagId?: number
  status?: number
}

export interface ProblemTag {
  id?: number
  tid?: number
  name: string
  color?: string
  oj?: string
  tcid?: number
}

export interface ProblemLanguage {
  id?: number
  name?: string
  description?: string
  codeTemplate?: string
  oj?: string
}

export interface FullScreenProblem {
  pid: number
  problemId: string
  title: string
  status?: number
  score?: number
}

export const problemApi = {
  getList(params?: ProblemQueryParams) {
    return api.get<ProblemListResponse>('/get-problem-list', {
      params: toBackendPageParams(params),
    })
  },

  getDetail(problemId: string) {
    return api.get<ProblemDetailResponse>('/get-problem-detail', {
      params: { problemId },
    })
  },

  getUserProblemStatus(pidList: number[]) {
    return api.post<ApiResponse<Record<string, { status?: number; score?: number }>>>('/get-user-problem-status', {
      pidList,
      isContestProblemList: false,
    })
  },

  getProblemLanguages(pid: number) {
    return api.get<ApiResponse<ProblemLanguage[]>>('/get-problem-languages', {
      params: { pid },
    })
  },

  getLanguages(all = false, pid?: number) {
    return api.get<ApiResponse<ProblemLanguage[]>>('/languages', {
      params: { all, pid },
    })
  },

  getProblemCodeTemplate(pid: number) {
    return api.get<ApiResponse<Array<{ lid?: number; language?: string; code?: string; sourceCode?: string; template?: string }>>>('/get-problem-code-template', {
      params: { pid },
    })
  },

  getLastAcceptedCode(pid: number, cid = 0) {
    return api.get<ApiResponse<{ code?: string; language?: string }>>('/get-last-ac-code', {
      params: { pid, cid },
    })
  },

  getTags(oj = 'ME') {
    return api.get<ApiResponse<ProblemTag[]>>('/get-all-problem-tags', {
      params: { oj },
    })
  },

  getRandomProblem() {
    return api.get<ApiResponse<{ problemId: string }>>('/get-random-problem')
  },

  getFullScreenProblemList(params: { tid?: number; cid?: number }) {
    return api.get<ApiResponse<FullScreenProblem[]>>('/get-full-screen-problem-list', { params })
  },
}
