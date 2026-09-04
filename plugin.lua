--- AI Translate for MarkText Plus.
---
--- The prompt and the flow live here, in the plugin. The editor supplies the
--- model the reader configured and never hands over the API key: this script
--- asks for a completion and gets text back.
local sdk = require("lib.marktext-plus")
local blocks = require("lib.blocks")

--- Offered as chips above the box. A shortcut, not a cage: whatever is typed
--- instead is used as it stands.
local COMMON_LANGUAGES = {
  "English", "简体中文", "繁體中文", "日本語", "한국어",
  "Français", "Deutsch", "Español", "Русский", "Português",
}

--- The prompt used when the reader has not written one of their own.
local DEFAULT_PROMPT = table.concat({
  "Translate the Markdown below into {{language}}.",
  "",
  "Rules:",
  "- Preserve every Markdown construct exactly: headings, lists, tables,",
  "  links, images, footnotes, block quotes and front matter.",
  "- Do not translate code inside fences or inline code, URLs, file paths,",
  "  or HTML tag names.",
  "- Keep the same block order and the same number of blocks.",
  "- Return only the translated Markdown, with no preamble and no fence",
  "  wrapped around the whole answer.",
  "",
  "Document:",
  "{{text}}",
}, "\n")

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

--- The prompt for one batch, from the reader's template.
---
--- The template is theirs to change — a model that keeps mistranslating a
--- particular kind of document is fixed by saying so in the prompt, and
--- nobody can do that from outside the plugin. `{{text}}` is where the source
--- goes; a template that forgets it gets the source appended, because a
--- prompt with nothing to translate in it is worse than an untidy one.
local function build_prompt(text, language)
  local template = storage.get("prompt")
  if template == nil or template == "" then
    template = DEFAULT_PROMPT
  end
  local prompt = replace(template, "{{language}}", language)
  if prompt:find("{{text}}", 1, true) == nil then
    return prompt .. "\n\n" .. text
  end
  return replace(prompt, "{{text}}", text)
end

--- The blocks of the document being translated, kept between calls.
---
--- Storage holds strings, so they travel as one string separated by a marker
--- no Markdown produces. Built with string.char so the escape is unambiguous:
--- "\1" in a Lua literal is a numeric escape, not a backslash and a one.
local SEPARATOR = string.char(1)

local function remember(list)
  storage.set("blocks", table.concat(list, SEPARATOR))
  storage.set("at", "1")
end

--- The nth remembered block, or nil past the end.
---
--- Walked with find and sub: this editor's Lua returns nothing at all for
--- `gmatch("(.-)sep")`, which failed silently and made every document look
--- like a single block.
local function block_at(index)
  local saved = storage.get("blocks") or ""
  local pos, n = 1, 0
  while true do
    local at = saved:find(SEPARATOR, pos, true)
    n = n + 1
    if at == nil then
      if n == index then return saved:sub(pos) end
      return nil
    end
    if n == index then return saved:sub(pos, at - 1) end
    pos = at + 1
  end
end

function on_command(ctx)
  local whole = ctx.command == "translate.document"
  local text = whole and ctx.document or ctx.selection
  if text == nil or text == "" then
    return sdk.notify(sdk.t("error.empty"))
  end

  -- Ask once, then remember.
  if ctx.answer == nil then
    return sdk.ask(sdk.t("ask.language"), {
      default = storage.get("targetLanguage") or "English",
      choices = COMMON_LANGUAGES,
    })
  end
  storage.set("targetLanguage", ctx.answer)

  if not whole then
    return sdk.ai(build_prompt(text, ctx.answer))
  end

  -- A block at a time. The whole document in one request is slow, may exceed
  -- what the model will take, and loses everything when it fails.
  -- Split into paragraphs, then grouped back into requests: a paragraph is the
  -- smallest thing worth translating on its own, but one request per paragraph
  -- is dozens of round trips for a document that would fit in a handful.
  local list = blocks.batch(blocks.split(text))
  remember(list)
  storage.set("mode", ctx.view == "source" and "source" or "preview")

  -- The pane opens empty, before the first request rather than after it. The
  -- editor reads `pane` ahead of `ai`, so it puts the pane up and then makes
  -- the call — and an empty pane with a request outstanding is what the
  -- editor draws as "working". Asking first meant nothing happened on screen
  -- until the first block came back, which for a long paragraph is several
  -- seconds of a menu item that appeared to do nothing.
  return {
    pane = "",
    title = ctx.answer,
    slot = "right",
    as = storage.get("mode") or "preview",
    ai = build_prompt(list[1] or text, ctx.answer),
  }
end

function on_result(ctx, result)
  local language = ctx.answer or ""

  if ctx.command ~= "translate.document" then
    return sdk.show(result, language)
  end

  local at = tonumber(storage.get("at") or "1")
  local next_block = block_at(at + 1)
  storage.set("at", tostring(at + 1))

  -- Drawn the way the reader is reading: a translation shown as raw Markdown
  -- beside a rendered preview cannot be compared with what it sits beside.
  local pane = {
    pane = result,
    title = language,
    slot = "right",
    as = storage.get("mode") or "preview",
    append = at > 1,
  }
  if next_block ~= nil then
    pane.ai = build_prompt(next_block, language)
  end
  return pane
end
