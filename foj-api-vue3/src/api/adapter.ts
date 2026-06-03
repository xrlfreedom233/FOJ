import type {
  ApiResponse,
  Contest,
  ContestDetail,
  ContestProblem,
  ContestRankProblem,
  ContestRankUser,
  JudgeInfo,
  Problem,
  ProblemDetail,
  RankUser,
  Sample,
  Submission,
  SubmissionDetail,
} from '@/types'

const SUCCESS_STATUS = 200

type BackendPage<T = unknown> = {
  records?: T[]
  total?: number
  current?: number
  size?: number
}

type BackendTag = {
  name?: string
}

type BackendProblemCount = {
  total?: number
  ac?: number
}

type BackendProblem = {
  pid?: number
  id?: number
  problemId?: string
  title?: string
  difficulty?: number
  tags?: Array<string | BackendTag>
  total?: number
  ac?: number
  gmtCreate?: string
  description?: string
  input?: string
  output?: string
  examples?: string
  hint?: string
  timeLimit?: number
  memoryLimit?: number
  source?: string
}

type BackendProblemInfo = {
  problem?: BackendProblem
  tags?: Array<string | BackendTag>
  problemCount?: BackendProblemCount
  codeTemplate?: Record<string, string>
}

type BackendContest = {
  id?: number
  title?: string
  description?: string
  startTime?: string
  endTime?: string
  type?: number
  auth?: number
  status?: number
  count?: number
  gmtCreate?: string
}

type BackendContestProblem = {
  displayId?: string
  pid?: number
  displayTitle?: string
  ac?: number
  total?: number
}

type BackendJudge = {
  submitId?: number
  pid?: number
  uid?: number | string
  username?: string
  title?: string
  displayPid?: string
  language?: string
  status?: number
  time?: number
  memory?: number
  length?: number
  submitTime?: string
  code?: string
  errorMessage?: string
  compileInfo?: string
  judgeCases?: BackendJudgeCase[]
}

type BackendSubmissionInfo = {
  submission?: BackendJudge
  displayPid?: string
  title?: string
}

type BackendJudgeCase = {
  id?: number
  caseId?: number
  status?: number
  time?: number
  memory?: number
}

type BackendRankUser = {
  uid?: number | string
  username?: string
  nickname?: string
  avatar?: string
  total?: number
  ac?: number
  rating?: number
}

type BackendContestRank = {
  rank?: number
  uid?: number | string
  username?: string
  nickname?: string
  totalTime?: number
  ac?: number
  submissionInfo?: Record<string, BackendContestRankProblem>
}

type BackendContestRankProblem = {
  isAC?: boolean
  ac?: boolean
  errorNum?: number
  time?: number
}

export const isSuccess = <T>(response: ApiResponse<T>) => response.status === SUCCESS_STATUS

export const toBackendPageParams = <T extends { page?: number; page_size?: number }>(params?: T) => {
  if (!params) return undefined

  const { page, page_size, ...rest } = params
  const backendParams: Record<string, unknown> = {
    ...rest,
    currentPage: page,
    limit: page_size,
  }

  Object.keys(backendParams).forEach((key) => {
    const value = backendParams[key]
    if (value === undefined || value === null || value === '') {
      delete backendParams[key]
    }
  })

  return backendParams
}

export const getPageRecords = <T>(value: unknown): T[] => {
  const data = value as BackendPage<T> | undefined
  return data?.records ?? []
}

export const getPageTotal = (value: unknown) => {
  const data = value as BackendPage | undefined
  return data?.total ?? 0
}

const normalizeStatus = (status?: number) => {
  if (status === 0) return 1
  if (status === 1) return 2
  if (status === -1) return 0
  return status ?? 0
}

const normalizeTags = (tags?: Array<string | BackendTag>) =>
  (tags ?? []).map((tag) => (typeof tag === 'string' ? tag : tag.name)).filter(Boolean) as string[]

const parseSamples = (examples?: string): Sample[] => {
  if (!examples) return []
  try {
    const parsed = JSON.parse(examples)
    if (Array.isArray(parsed)) {
      return parsed.map((sample) => ({
        input: sample.input ?? sample.inputContent ?? '',
        output: sample.output ?? sample.outputContent ?? '',
      }))
    }
  } catch {
    return []
  }
  return []
}

export const mapProblem = (value: unknown): Problem => {
  const raw = value as BackendProblem
  return {
  pid: Number(raw.pid ?? raw.id ?? 0),
  problemId: raw.problemId ?? String(raw.pid ?? raw.id ?? ''),
  title: raw.title ?? '',
  difficulty: raw.difficulty ?? 0,
  tags: normalizeTags(raw.tags),
  accept_count: raw.ac ?? 0,
  submit_count: raw.total ?? 0,
  create_time: raw.gmtCreate ?? '',
  }
}

export const mapProblemDetail = (value: unknown): ProblemDetail => {
  const problemInfo = value as BackendProblemInfo
  const problem = problemInfo.problem ?? (value as BackendProblem)
  const count = problemInfo.problemCount

  return {
    ...mapProblem({
      ...problem,
      tags: problemInfo.tags ?? problem.tags,
      ac: count?.ac ?? problem.ac,
      total: count?.total ?? problem.total,
    }),
    description: problem.description ?? '',
    input_description: problem.input ?? '',
    output_description: problem.output ?? '',
    samples: parseSamples(problem.examples),
    hint: problem.hint ?? '',
    time_limit: problem.timeLimit ?? 0,
    memory_limit: problem.memoryLimit ?? 0,
    source: problem.source ?? '',
  }
}

export const mapContest = (value: unknown): Contest => {
  const raw = value as BackendContest
  return {
  cid: Number(raw.id ?? 0),
  title: raw.title ?? '',
  description: raw.description ?? '',
  start_time: raw.startTime ?? '',
  end_time: raw.endTime ?? '',
  type: raw.auth ?? 0,
  status: normalizeStatus(raw.status),
  participant_count: raw.count ?? 0,
  create_time: raw.gmtCreate ?? '',
  }
}

export const mapContestProblem = (value: unknown): ContestProblem => {
  const raw = value as BackendContestProblem
  return {
  index: raw.displayId ?? '',
  pid: raw.pid ?? 0,
  title: raw.displayTitle ?? '',
  accept_count: raw.ac ?? 0,
  submit_count: raw.total ?? 0,
  }
}

export const mapContestDetail = (
  contest: unknown,
  problems: unknown[] = []
): ContestDetail => ({
  ...mapContest(contest),
  problems: problems.map(mapContestProblem),
  rules: (contest as BackendContest).type === 1 ? 'OI' : 'ACM/ICPC',
})

export const mapSubmission = (value: unknown): Submission => {
  const raw = value as BackendJudge
  return {
  sid: Number(raw.submitId ?? 0),
  pid: Number(raw.pid ?? 0),
  problemId: raw.displayPid ?? String(raw.pid ?? ''),
  uid: String(raw.uid ?? ''),
  username: raw.username ?? '',
  problem_title: raw.title ?? raw.displayPid ?? '',
  language: raw.language ?? '',
  status: raw.status ?? 0,
  time_cost: raw.time ?? 0,
  memory_cost: raw.memory ?? 0,
  code_length: raw.length ?? 0,
  create_time: raw.submitTime ?? '',
  }
}

export const mapJudgeInfo = (value: unknown): JudgeInfo => {
  const raw = value as BackendJudgeCase
  return {
  case_id: raw.caseId ?? raw.id ?? 0,
  status: raw.status ?? 0,
  time_cost: raw.time ?? 0,
  memory_cost: raw.memory ?? 0,
  }
}

export const mapSubmissionDetail = (value: unknown): SubmissionDetail => {
  const submissionInfo = value as BackendSubmissionInfo
  const raw = submissionInfo.submission ?? (value as BackendJudge)
  const displayPid = raw.displayPid ?? submissionInfo.displayPid
  const title = raw.title ?? submissionInfo.title
  return {
  ...mapSubmission({ ...raw, displayPid, title }),
  code: raw.code ?? '',
  compile_info: raw.compileInfo ?? raw.errorMessage ?? '',
  judge_info: (raw.judgeCases ?? []).map(mapJudgeInfo),
  }
}

export const mapRankUser = (value: unknown, index: number, page = 1, pageSize = 50): RankUser => {
  const raw = value as BackendRankUser
  return {
  rank: (page - 1) * pageSize + index + 1,
  uid: String(raw.uid ?? ''),
  username: raw.username ?? '',
  nickname: raw.nickname ?? '',
  avatar: raw.avatar ?? '',
  solved: raw.ac ?? 0,
  submit: raw.total ?? 0,
  rating: raw.rating ?? 0,
  }
}

export const mapContestRankUser = (
  value: unknown,
  contestProblems: ContestProblem[],
  index: number
): ContestRankUser => {
  const raw = value as BackendContestRank
  return {
    rank: raw.rank ?? index + 1,
    uid: String(raw.uid ?? ''),
    username: raw.username ?? '',
    nickname: raw.nickname ?? '',
    total_time: raw.totalTime ?? 0,
    solved: raw.ac ?? 0,
    problems: contestProblems.map<ContestRankProblem>((problem) => {
      const item = raw.submissionInfo?.[problem.index]
      return {
        index: problem.index,
        status: item?.isAC || item?.ac ? 2 : 0,
        time: item?.time ?? 0,
        try_count: item?.errorNum ?? 0,
      }
    }),
  }
}
