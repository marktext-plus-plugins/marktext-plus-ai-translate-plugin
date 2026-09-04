--- AI Assistant for MarkText Plus: writing, proofreading, translation.
---
--- The prompts and the flow live here, in the plugin. The editor supplies the
--- model the reader configured and never hands over the API key: this script
--- asks for a completion and gets text back.
---
--- Writing and proofreading show their result in a pane with an Apply button
--- rather than writing it straight into the document. What a model returns is
--- worth reading before it lands in what you were writing, and Apply goes
--- through the editor's history, so one press of undo takes it back.
local sdk = require("lib.marktext-plus")
local blocks = require("lib.blocks")
local prompts = require("lib.prompts")

--- Offered as chips above the box. A shortcut, not a cage: whatever is typed
--- instead is used as it stands.
local COMMON_LANGUAGES = {
  "English", "简体中文", "繁體中文", "日本語", "한국어",
  "Français", "Deutsch", "Español", "Русский", "Português",
}

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

--- What the command works on: the selection if there is one, else the whole
--- document.
local function subject(ctx)
  local selection = ctx.selection
  if selection ~= nil and selection ~= "" then return selection, selection end
  -- The second value is what Apply would replace; empty means everything.
  return ctx.document or "", ""
end

local function view_of(ctx)
  return ctx.view == "source" and "source" or "preview"
end

-- ---------------------------------------------------------------- writing --

local function start_writing(ctx)
  if ctx.answer == nil then
    return sdk.ask(sdk.t("ask.instruction"), { choices = prompts.WRITING_IDEAS })
  end
  local text, replaces = subject(ctx)
  storage.set("replaces", replaces)
  storage.set("mode", view_of(ctx))
  -- An empty document is a blank page: the instruction is the whole request.
  return {
    pane = "",
    title = sdk.t("menu.write"),
    slot = "right",
    as = view_of(ctx),
    ai = prompts.writing(text, ctx.answer),
  }
end

-- ------------------------------------------------------------ proofreading --

local function start_proofreading(ctx)
  local text, replaces = subject(ctx)
  if text == "" then return sdk.notify(sdk.t("error.empty")) end
  storage.set("replaces", replaces)
  storage.set("mode", view_of(ctx))
  return {
    pane = "",
    title = sdk.t("menu.proofread"),
    slot = "right",
    as = view_of(ctx),
    ai = prompts.proofreading(text),
  }
end

-- -------------------------------------------------------------- translation --

local function start_translation(ctx)
  local whole = ctx.command == "translate.document"
  local text = whole and (ctx.document or "") or (ctx.selection or "")
  if text == "" then return sdk.notify(sdk.t("error.empty")) end

  -- Ask once, then remember.
  if ctx.answer == nil then
    return sdk.ask(sdk.t("ask.language"), {
      default = storage.get("targetLanguage") or "English",
      choices = COMMON_LANGUAGES,
    })
  end
  storage.set("targetLanguage", ctx.answer)

  if not whole then
    return sdk.ai(prompts.translation(text, ctx.answer))
  end

  -- A block at a time. The whole document in one request is slow, may exceed
  -- what the model will take, and loses everything when it fails. Grouped back
  -- into batches, because one request per paragraph is dozens of round trips
  -- for a document that would fit in a handful.
  local list = blocks.batch(blocks.split(text))
  remember(list)
  storage.set("mode", view_of(ctx))

  -- The pane opens empty, before the first request rather than after it. The
  -- editor reads `pane` ahead of `ai`, so it puts the pane up and then makes
  -- the call — and an empty pane with a request outstanding is what the
  -- editor draws as "working".
  return {
    pane = "",
    title = ctx.answer,
    slot = "right",
    as = view_of(ctx),
    ai = prompts.translation(list[1] or text, ctx.answer),
  }
end

-- ------------------------------------------------------------------ entry --

function on_command(ctx)
  local command = ctx.command
  if command == "ai.write" then return start_writing(ctx) end
  if command == "ai.proofread" then return start_proofreading(ctx) end
  return start_translation(ctx)
end

function on_result(ctx, result)
  local command = ctx.command

  -- Writing and proofreading offer to replace what they were looking at.
  if command == "ai.write" or command == "ai.proofread" then
    return {
      pane = result,
      title = command == "ai.write" and sdk.t("menu.write")
        or sdk.t("menu.proofread"),
      slot = "right",
      as = storage.get("mode") or "preview",
      apply = true,
      replaces = storage.get("replaces") or "",
    }
  end

  local language = ctx.answer or ""
  if command ~= "translate.document" then
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
    pane.ai = prompts.translation(next_block, language)
  end
  return pane
end
