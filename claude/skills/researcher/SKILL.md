---
name: researcher
description: Research a topic by gathering information from web sources and local files. Use when the user asks to research, investigate, or deep-dive into a subject. Supports incremental research via a research.md file.
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, Agent, Write, Edit, TaskCreate, TaskUpdate, TaskList, TaskGet
argument-hint: <topic or question to research>
---

# Researcher

Gather, synthesize, and document findings on a given topic.

## Instructions

1. **Check for existing research**: Look for a `research.md` file in the current directory. If it exists, read it to understand prior findings, sources, and open questions.

2. **Identify parameters**: From the user's request and any existing `research.md`, determine:
   - The core question or topic
   - Specific angles or subtopics to cover
   - Any sources or URLs already provided
   - What gaps remain from prior research

3. **Plan the research**: Break the work into discrete search tasks using TaskCreate. Each task should target a specific subtopic or question.

4. **Gather information**:
   - Use WebSearch to find relevant sources
   - Use WebFetch to read promising pages in detail
   - Use Read/Grep/Glob to check local files for related context
   - Use Agent subagents to parallelize independent searches when multiple subtopics exist

5. **Synthesize findings**: For each subtopic, extract key facts, compare across sources, and note conflicting information.

6. **Write research.md**: Create or update `research.md` with the results using this structure:

```markdown
# Research: <Topic>

## Summary
Key findings in 3-5 bullet points.

## Findings

### <Subtopic 1>
- Finding with [source](url)
- Finding with [source](url)

### <Subtopic 2>
...

## Sources
- [Title](url) — one-line description of what it contributed

## Open Questions
- Questions that remain unanswered or need deeper investigation
```

7. **Present results**: Give the user a concise summary and highlight any open questions or conflicting information.

## Guidelines

- Prefer primary sources over aggregators
- Always attribute findings to their source with URLs
- Flag uncertainty or conflicting information explicitly
- When updating existing research, preserve prior findings and mark new additions
- Keep the summary actionable — lead with what matters most
