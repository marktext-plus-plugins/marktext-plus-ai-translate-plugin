--- The prompts, and the reader's ability to change them.
---
--- Each of the three commands has a system prompt — what the model is, and the
--- rules it works under — and a user prompt, which carries the text. Both are
--- settings: a model that keeps mistranslating a particular kind of document,
--- or keeps rewriting in a register you did not ask for, is fixed by saying so
--- in the prompt, and nobody can do that from outside the plugin.
---
--- `{{text}}` is where the source goes, `{{instruction}}` the brief that was
--- typed and `{{language}}` the one that was chosen. A template that forgets
--- any of the three gets it appended rather than dropped: a prompt missing
--- what it was meant to work on is worse than an untidy one, and the model
--- answers either way — so nothing looks wrong while the answer is to a
--- question nobody asked.

local M = {}

--- Ideas offered as chips when asking what to write. Not a cage: anything
--- typed instead is used as it stands.
---
--- Keys rather than sentences: these are shown to the reader, and the reader
--- is not necessarily reading English. Every other string this plugin shows
--- goes through `locales`; these were the ones that did not.
M.WRITING_IDEA_KEYS = {
  "idea.clearer",
  "idea.shorter",
  "idea.formal",
  "idea.conversational",
  "idea.expand",
  "idea.list",
}

--- The ideas in the reader's language. `t` is the SDK's translator.
function M.writing_ideas(t)
  local out = {}
  for i, key in ipairs(M.WRITING_IDEA_KEYS) do
    out[i] = t(key)
  end
  return out
end

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

--- The template with every `{{key}}` it names replaced, in one pass.
---
--- One pass is the whole point. Filling the placeholders one key at a time
--- means each replacement is scanned again by the next, so a `{{language}}`
--- **in the reader's own document** was replaced along with the one in the
--- template — and a `{{instruction}}` in it was replaced by the brief they had
--- just typed. Measured: a document reading `A: {{instruction}}` reached the
--- model as `A: MAKE-IT-SHORT`, the rewrite came back with the corruption in
--- it, and Apply wrote that into the document. Anyone writing about Jinja,
--- Handlebars, Vue or this plugin's own prompts writes `{{...}}` all day.
---
--- Which key won depended on the order `pairs` happened to give — so the same
--- command on the same document could differ between runs, and only one of the
--- three commands showed it. Walking the template instead settles both: a
--- value goes into the output and is never looked at again.
---
--- Written with find and sub rather than gsub: the value is a document, and
--- gsub reads `%` in a replacement as an escape, so a paragraph containing
--- "100%" would come out mangled or raise.
---
--- A `{{name}}` the caller has no value for is left as it stands. The prompts
--- are the reader's to edit and the braces may be theirs.
local function fill(template, values)
  local out, pos = "", 1
  while true do
    local at = template:find("{{", pos, true)
    if at == nil then return out .. template:sub(pos) end
    local stop = template:find("}}", at + 2, true)
    if stop == nil then return out .. template:sub(pos) end
    local value = values[template:sub(at + 2, stop - 1)]
    out = out .. template:sub(pos, at - 1)
    if value ~= nil then
      out = out .. value
    else
      out = out .. template:sub(at, stop + 1)
    end
    pos = stop + 2
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
--- What to call a value that has to be appended because its placeholder is
--- gone. Ordered, so a prompt reads the same way every time: `pairs` gives no
--- order, and two runs of the same command should not differ.
---
--- `text` is not here — it is appended last and unlabelled, being the bulk of
--- the message rather than a field of it.
local APPENDED = {
  { key = "instruction", label = "Brief" },
  { key = "language", label = "Target language" },
}

--- Whether neither prompt mentions `{{key}}`.
---
--- Both are checked because they are joined before substitution: a reader who
--- moved `{{language}}` from the user prompt into the system one has not lost
--- it.
local function absent(system, user, key)
  local needle = "{{" .. key .. "}}"
  return user:find(needle, 1, true) == nil
      and system:find(needle, 1, true) == nil
end

local function build(system, user, values)
  local prompt = fill(system .. "\n\n" .. user, values)
  -- A template that forgot where something goes still gets it.
  --
  -- These prompts are the reader's to edit, and an edit that drops a
  -- placeholder drops the reader's own input: the brief they typed a second
  -- ago, the language they picked from a list. Silently sending a prompt
  -- without them is worse than sending an untidy one — the model answers, so
  -- nothing looks wrong, and the answer is to a question nobody asked.
  --
  -- The `text` half of this existed first. Its two siblings did not, which is
  -- the shape this repository keeps finding: a rule applied to the branch
  -- somebody was looking at.
  for _, field in ipairs(APPENDED) do
    local value = values[field.key]
    if value ~= nil and value ~= "" and absent(system, user, field.key) then
      prompt = prompt .. "\n\n" .. field.label .. ": " .. value
    end
  end
  if values.text ~= nil and absent(system, user, "text") then
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
