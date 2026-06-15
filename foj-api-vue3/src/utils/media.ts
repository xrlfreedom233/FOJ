const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || '/api'

const getApiOrigin = () => {
  if (typeof window === 'undefined') return ''
  try {
    return new URL(API_BASE_URL, window.location.origin).origin
  } catch {
    return window.location.origin
  }
}

export const resolveMediaUrl = (url?: string | null) => {
  if (!url) return ''
  if (/^(https?:)?\/\//i.test(url) || /^(data|blob):/i.test(url)) return url
  if (url.startsWith('/api/')) return `${getApiOrigin()}${url}`
  return url
}
