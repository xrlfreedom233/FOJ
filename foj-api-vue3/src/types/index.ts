// User types
export interface User {
  uid: string
  username: string
  nickname: string
  avatar: string
  signature: string
  email: string
  realname?: string
  blog?: string
  github?: string
  school?: string
  number?: string
  gender?: string
  cfUsername?: string
  role: string
  solved: number
  submit: number
  rating: number
  create_time: string
  gmtCreate?: string
  gmt_create?: string
  roleList?: string[]
}

export interface UserHomeInfo {
  uid: string
  username: string
  nickname?: string
  avatar?: string
  signature?: string
  email?: string
  school?: string
  blog?: string
  github?: string
  total?: number
  rating?: number
  solvedList?: string[]
  recentLoginTime?: string
}

export interface LoginRequest {
  username: string
  password: string
}

export interface RegisterRequest {
  username: string
  password: string
  email: string
  nickname?: string
  code: string
}

export interface AuthResponse {
  code?: number
  status?: number
  msg: string
  data: User
}

// Problem types
export interface Problem {
  pid: number
  problemId: string
  title: string
  difficulty: number
  tags: string[]
  accept_count: number
  submit_count: number
  create_time: string
  status?: number // 0: not submitted, 1: accepted, 2: tried
}

export interface ProblemDetail extends Problem {
  description: string
  input_description: string
  output_description: string
  samples: Sample[]
  hint: string
  time_limit: number
  memory_limit: number
  source: string
}

export interface Sample {
  input: string
  output: string
}

export interface ProblemListResponse {
  code: number
  msg: string
  data: {
    list: Problem[]
    total: number
  }
}

export interface ProblemDetailResponse {
  code: number
  msg: string
  data: ProblemDetail
}

// Submission types
export interface Submission {
  sid: number
  pid: number
  problemId: string
  uid: string
  username: string
  problem_title: string
  language: string
  status: number
  time_cost: number
  memory_cost: number
  code_length: number
  create_time: string
}

export interface SubmissionDetail extends Submission {
  code: string
  compile_info: string
  judge_info: JudgeInfo[]
}

export interface JudgeInfo {
  case_id: number
  status: number
  time_cost: number
  memory_cost: number
}

export interface SubmitRequest {
  pid: number | string
  language: string
  code: string
}

export interface SubmissionListResponse {
  code: number
  msg: string
  data: {
    list: Submission[]
    total: number
  }
}

export interface SubmissionDetailResponse {
  code: number
  msg: string
  data: SubmissionDetail
}

// Contest types
export interface Contest {
  cid: number
  title: string
  description: string
  start_time: string
  end_time: string
  type: number // 0: public, 1: private, 2: protected
  status: number // 0: not started, 1: running, 2: ended
  participant_count: number
  create_time: string
}

export interface ContestDetail extends Contest {
  problems: ContestProblem[]
  rules: string
}

export interface ContestProblem {
  index: string
  pid: number
  title: string
  accept_count: number
  submit_count: number
}

export interface ContestListResponse {
  code: number
  msg: string
  data: {
    list: Contest[]
    total: number
  }
}

export interface ContestDetailResponse {
  code: number
  msg: string
  data: ContestDetail
}

// Rank types
export interface RankUser {
  rank: number
  uid: string
  username: string
  nickname: string
  avatar: string
  solved: number
  submit: number
}

export interface ContestRankUser {
  rank: number
  uid: string
  username: string
  nickname: string
  total_time: number
  solved: number
  problems: ContestRankProblem[]
}

export interface ContestRankProblem {
  index: string
  status: number
  time: number
  try_count: number
}

export interface RankListResponse {
  code: number
  msg: string
  data: {
    list: RankUser[]
    total: number
  }
}

export interface ContestRankResponse {
  code: number
  msg: string
  data: {
    list: ContestRankUser[]
    total: number
  }
}

// Common types
export interface ApiResponse<T = unknown> {
  code?: number
  status?: number
  msg: string
  data: T
}

export interface PaginationParams {
  page?: number
  page_size?: number
}

// Status constants
export const SUBMISSION_STATUS = {
  NOT_SUBMITTED: -10,
  SUBMITTED_UNKNOWN_RESULT: -5,
  CANCELLED: -4,
  PRESENTATION_ERROR: -3,
  COMPILE_ERROR: -2,
  WRONG_ANSWER: -1,
  ACCEPTED: 0,
  TIME_LIMIT_EXCEEDED: 1,
  MEMORY_LIMIT_EXCEEDED: 2,
  RUNTIME_ERROR: 3,
  SYSTEM_ERROR: 4,
  PENDING: 5,
  COMPILING: 6,
  JUDGING: 7,
  PARTIAL_ACCEPTED: 8,
  SUBMITTING: 9,
  SUBMITTED_FAILED: 10,
  NO_STATUS: 15,
} as const

export const SUBMISSION_STATUS_TEXT: Record<number, string> = {
  [-10]: 'Not Submitted',
  [-5]: 'Submitted Unknown Result',
  [-4]: 'Cancelled',
  [-3]: 'Presentation Error',
  [-2]: 'Compile Error',
  [-1]: 'Wrong Answer',
  0: 'Accepted',
  1: 'Time Limit Exceeded',
  2: 'Memory Limit Exceeded',
  3: 'Runtime Error',
  4: 'System Error',
  5: 'Pending',
  6: 'Compiling',
  7: 'Judging',
  8: 'Partial Accepted',
  9: 'Submitting',
  10: 'Submitted Failed',
  15: 'No Status',
}

export const SUBMISSION_STATUS_CLASS: Record<number, string> = {
  [-10]: 'status-pending',
  [-5]: 'status-pending',
  [-4]: 'status-wrong',
  [-3]: 'status-wrong',
  [-2]: 'status-wrong',
  [-1]: 'status-wrong',
  0: 'status-accepted',
  1: 'status-wrong',
  2: 'status-wrong',
  3: 'status-wrong',
  4: 'status-wrong',
  5: 'status-pending',
  6: 'status-running',
  7: 'status-running',
  8: 'status-accepted',
  9: 'status-pending',
  10: 'status-wrong',
  15: 'status-pending',
}

export const DIFFICULTY_TEXT: Record<number, string> = {
  0: '简单',
  1: '中等',
  2: '困难',
}

export const DIFFICULTY_CLASS: Record<number, string> = {
  0: 'difficulty-easy',
  1: 'difficulty-medium',
  2: 'difficulty-hard',
}

export const LANGUAGES = [
  { value: 'C', label: 'C' },
  { value: 'C++ 17', label: 'C++ 17' },
  { value: 'Java', label: 'Java' },
  { value: 'Python3', label: 'Python3' },
  { value: 'Golang', label: 'Golang' },
  { value: 'Rust', label: 'Rust' },
]
