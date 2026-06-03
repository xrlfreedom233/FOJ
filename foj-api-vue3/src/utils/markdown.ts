const escapeHtml = (value: string) =>
  value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')

const escapeAttribute = (value: string) => escapeHtml(value).replace(/`/g, '&#96;')

const renderInline = (value: string) => {
  const parts = value.split(/(`[^`]+`)/g)

  return parts.map((part) => {
    if (part.startsWith('`') && part.endsWith('`')) {
      return `<code>${escapeHtml(part.slice(1, -1))}</code>`
    }

    return escapeHtml(part)
      .replace(/\[([^\]]+)]\((https?:\/\/[^)\s]+)\)/g, (_match, text, url) => {
        return `<a href="${escapeAttribute(url)}" target="_blank" rel="noopener noreferrer">${text}</a>`
      })
      .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
      .replace(/\*([^*]+)\*/g, '<em>$1</em>')
      .replace(/\$\$([^$]+)\$\$/g, '<code class="math">$1</code>')
      .replace(/\$([^$]+)\$/g, '<code class="math">$1</code>')
  }).join('')
}

export const renderMarkdown = (content: string) => {
  if (!content) return ''

  const lines = content.replace(/\r\n/g, '\n').split('\n')
  const html: string[] = []
  let paragraph: string[] = []
  let listType: 'ul' | 'ol' | null = null
  let inCodeBlock = false
  let codeLanguage = ''
  let codeLines: string[] = []

  const closeList = () => {
    if (listType) {
      html.push(`</${listType}>`)
      listType = null
    }
  }

  const flushParagraph = () => {
    if (paragraph.length) {
      html.push(`<p>${renderInline(paragraph.join('\n')).replace(/\n/g, '<br>')}</p>`)
      paragraph = []
    }
  }

  const openList = (type: 'ul' | 'ol') => {
    if (listType !== type) {
      closeList()
      html.push(`<${type}>`)
      listType = type
    }
  }

  for (const line of lines) {
    const fence = line.match(/^```(\w*)\s*$/)
    if (fence) {
      if (inCodeBlock) {
        html.push(`<pre><code${codeLanguage ? ` class="language-${escapeAttribute(codeLanguage)}"` : ''}>${escapeHtml(codeLines.join('\n'))}</code></pre>`)
        codeLines = []
        codeLanguage = ''
        inCodeBlock = false
      } else {
        flushParagraph()
        closeList()
        inCodeBlock = true
        codeLanguage = fence[1] || ''
      }
      continue
    }

    if (inCodeBlock) {
      codeLines.push(line)
      continue
    }

    if (!line.trim()) {
      flushParagraph()
      closeList()
      continue
    }

    const heading = line.match(/^(#{1,6})\s+(.+)$/)
    if (heading) {
      flushParagraph()
      closeList()
      const level = heading[1].length
      html.push(`<h${level}>${renderInline(heading[2])}</h${level}>`)
      continue
    }

    const unordered = line.match(/^\s*[-*]\s+(.+)$/)
    if (unordered) {
      flushParagraph()
      openList('ul')
      html.push(`<li>${renderInline(unordered[1])}</li>`)
      continue
    }

    const ordered = line.match(/^\s*\d+\.\s+(.+)$/)
    if (ordered) {
      flushParagraph()
      openList('ol')
      html.push(`<li>${renderInline(ordered[1])}</li>`)
      continue
    }

    const quote = line.match(/^>\s?(.+)$/)
    if (quote) {
      flushParagraph()
      closeList()
      html.push(`<blockquote>${renderInline(quote[1])}</blockquote>`)
      continue
    }

    paragraph.push(line)
  }

  if (inCodeBlock) {
    html.push(`<pre><code${codeLanguage ? ` class="language-${escapeAttribute(codeLanguage)}"` : ''}>${escapeHtml(codeLines.join('\n'))}</code></pre>`)
  }

  flushParagraph()
  closeList()

  return html.join('')
}
