--- The prompts, and the reader's ability to change them.
---
--- Each of the three commands has a system prompt — what the model is, and the
--- rules it works under — and a user prompt, which carries the text. Both are
--- settings: a model that keeps mistranslating a particular kind of document,
--- or keeps rewriting in a register you did not ask for, is fixed by saying so
--- in the prompt, and nobody can do that from outside the plugin.
---
--- `{{text}}` is where the source goes and `{{language}}` what was chosen. A
--- template that forgets `{{text}}` gets the source appended, because a prompt
--- with nothing to work on in it is worse than an untidy one.

local M = {}

--- Ideas offered as chips when asking what to write. Not a cage: anything
--- typed instead is used as it stands.
M.WRITING_IDEAS = {
  "Make it clearer",
  "Make it shorter",
  "More formal",
  "More conversational",
  "Expand with detail",
  "Turn into a list",
}

M.DEFAULT_WRITING_SYSTEM = table.concat({
  "You rewrite Markdown to a brief the reader gives you.",
  "",
  "Rules:",
  "- Follow the brief. It is the whole of what was asked for.",
  "- Preserve every Markdown construct: headings, lists, tables, links,",
  "  images, footnotes, block quotes and front matter.",
  "- Do not touch code inside fences or inline code, URLs or file paths.",
  "- Write in the language the text is already in, unless told otherwise.",
  "- Return only the rewritten Markdown: no preamble, no explanation, and no",
  "  fence wrapped around the whole answer.",
}, "\n")

M.DEFAULT_WRITING_USER = table.concat({
  "Brief: {{instruction}}",
  "",
  "Text:",
  "{{text}}",
}, "\n")

M.DEFAULT_PROOFREADING_SYSTEM = table.concat({
  "You correct Markdown: spelling, typing slips, grammar and punctuation.",
  "",
  "Rules:",
  "- Correct mistakes. Do not rewrite anything that is merely not how you",
  "  would have put it — the voice is the author's.",
  "- Preserve every Markdown construct, and the block order.",
  "- Do not touch code inside fences or inline code, URLs or file paths.",
  "- Keep the language the text is written in.",
  "- Return only the corrected Markdown: no preamble, no list of what you",
  "  changed, and no fence wrapped around the whole answer.",
}, "\n")

M.DEFAULT_PROOFREADING_USER = "Text:\n{{text}}"

M.DEFAULT_TRANSLATION_SYSTEM = table.concat({
  "You translate Markdown into {{language}}.",
  "",
  "Rules:",
  "- Preserve every Markdown construct exactly: headings, lists, tables,",
  "  links, images, footnotes, block quotes and front matter.",
  "- Do not translate code inside fences or inline code, URLs, file paths,",
  "  or HTML tag names.",
  "- Keep the same block order and the same number of blocks.",
  "- Return only the translated Markdown, with no preamble and no fence",
  "  wrapped around the whole answer.",
}, "\n")

M.DEFAULT_TRANSLATION_USER = "Document:\n{{text}}"

--- Every occurrence of `needle` replaced with `value`.
---
--- Written with find and sub rather than gsub: the replacement is a document,
--- and gsub reads `%` in a replacement as an escape. A paragraph containing
--- "100%" would come out mangled, or raise.
local function replace(subject, needle, value)
  local out, pos = "", 1
  while true do
    local at, stop = subject:find(needle, pos, true)
    if at == nil then
      return out .. subject:sub(pos)
    end
    out = out .. subject:sub(pos, at - 1) .. value
    pos = stop + 1
  end
end

local function setting(key, fallback)
  local written = storage.get(key)
  if written == nil or written == "" then return fallback end
  return written
end

--- A system prompt and a user prompt, joined the way a single-string API
--- takes them.
---
--- The editor's AI service sends one string, so the system prompt goes first
--- and the text follows. Kept as two settings even so, because they are two
--- different things to change: what the model is, and what it is being given.
local function build(system, user, values)
  local prompt = system .. "\n\n" .. user
  for key, value in pairs(values) do
    prompt = replace(prompt, "{{" .. key .. "}}", value)
  end
  -- A template that forgot where the text goes still gets the text.
  if values.text ~= nil and user:find("{{text}}", 1, true) == nil
      and system:find("{{text}}", 1, true) == nil then
    prompt = prompt .. "\n\n" .. values.text
  end
  return prompt
end

function M.writing(text, instruction)
  return build(
    setting("writingSystem", M.DEFAULT_WRITING_SYSTEM),
    setting("writingUser", M.DEFAULT_WRITING_USER),
    { text = text, instruction = instruction }
  )
end

function M.proofreading(text)
  return build(
    setting("proofreadingSystem", M.DEFAULT_PROOFREADING_SYSTEM),
    setting("proofreadingUser", M.DEFAULT_PROOFREADING_USER),
    { text = text }
  )
end

function M.translation(text, language)
  return build(
    setting("translationSystem", M.DEFAULT_TRANSLATION_SYSTEM),
    setting("translationUser", M.DEFAULT_TRANSLATION_USER),
    { text = text, language = language }
  )
end

return M
