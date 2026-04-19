---
name: writing-assistant
description: Help improve and flesh out written text in markdown or plain text files. Use when the user wants writing feedback, style fixes, grammar corrections, or help expanding bullet points into prose. Does not write text from scratch.
argument-hint: <file path>
---

# Writing Assistant

Read a file and help the user improve it incrementally — small edits for existing prose, fuller suggestions only for outlines and bullet points.

## Instructions

### Step 1: Read the file

Read the file path provided as the argument. Determine the format (markdown, plain text) and scan the full document to understand:

- The topic and subject matter
- The current state of completeness
- The tone and writing style the author is using
- Sections that are polished prose vs. raw notes/bullet points
- Any inline comments requesting help (e.g., `<!-- TODO: research this -->`, `<!-- flesh out -->`, `TODO:`, or similar markers)

### Step 2: Classify each section

For each section or paragraph, classify it as one of:

- **Polished prose** — the author has written full sentences/paragraphs
- **Raw outline** — bullet points, fragments, or skeletal notes
- **Research request** — contains a comment or marker asking to research or expand a topic

### Step 3: Work through the document top-to-bottom

Process the document sequentially, **one bullet point or section at a time**. After completing work on a single bullet point (or prose section), **stop and ask the user** before moving to the next one. Do NOT automatically continue to the next item. Wait for explicit user confirmation to proceed.

For each section:

#### For polished prose:

- First, delegate grammar/formatting checks to the **proofreader** subagent:
  ```
  Task tool → subagent_type: "proofreader"
  prompt: "Proofread this file: <file path>"
  ```
- Apply each fix the proofreader reports using the Edit tool, **one at a time**
- Then make a second pass for **word choice, sentence flow, and tone consistency** — still one small edit at a time (a sentence or two, never a full paragraph replacement)
- Preserve the author's voice — do not rewrite their sentences in your own style
- If a paragraph is fine, skip it silently

#### For raw outlines and bullet points:

- Research the topic if needed using WebSearch/WebFetch to ensure accuracy
- Suggest a **full paragraph** to replace the bullet points, written in the same tone as the rest of the document
- Use the Edit tool to apply the suggestion
- If the outline is long, work through it **one bullet point at a time**, stopping after each to ask the user before continuing

#### For research requests:

- Use WebSearch and WebFetch to gather relevant information
- Write the requested content in the author's tone, matching surrounding text
- Use the Edit tool to replace the comment/marker with the new content
- Keep additions concise — add substance, not filler

### Step 4: Summarize changes

After working through the document, give a brief summary of what was changed and why. Flag any sections you skipped or where you were unsure about the author's intent.

## Guidelines

- NEVER rewrite large sections of existing prose — your job is to polish, not replace
- NEVER add content the author didn't ask for (no new sections, no unsolicited introductions or conclusions)
- NEVER change the author's argument, position, or meaning
- Match the existing tone: if the text is casual, stay casual; if formal, stay formal
- When researching, prefer primary sources and cite them if the document style includes citations
- If unsure about the author's intent for a section, ask rather than guess
- Work incrementally — make one edit, then **stop and wait for user confirmation** before moving to the next. Never auto-advance to the next bullet point or section.
