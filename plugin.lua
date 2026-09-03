--- AI Translate for MarkText Plus.
---
--- The prompt and the flow live here, in the plugin. The editor supplies the
--- model the reader configured and never hands over the API key: this script
--- asks for a completion and gets text back.
local sdk = require("lib.marktext-plus")

--- Offered as chips above the box. A shortcut, not a cage: whatever is typed
--- instead is used as it stands, so a language not on this list costs nothing
--- but typing it.
local COMMON_LANGUAGES = {
  "English",
  "简体中文",
  "繁體中文",
  "日本語",
  "한국어",
  "Français",
  "Deutsch",
  "Español",
  "Русский",
  "Português",
}

local function source_for(ctx)
  if ctx.command == "translate.document" then
    return ctx.document
  end
  return ctx.selection
end

local function build_prompt(text, language)
  return table.concat({
    "Translate the Markdown below into " .. language .. ".",
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
    text,
  }, "\n")
end

function on_command(ctx)
  local text = source_for(ctx)
  if text == nil or text == "" then
    return sdk.notify(sdk.t("error.empty"))
  end

  -- Ask once, then remember: the reader who translates into Japanese today is
  -- usually translating into Japanese tomorrow.
  if ctx.answer == nil then
    return sdk.ask(sdk.t("ask.language"), {
      default = sdk.storage.get("targetLanguage") or "English",
      choices = COMMON_LANGUAGES,
    })
  end
  sdk.storage.set("targetLanguage", ctx.answer)

  return sdk.ai(build_prompt(text, ctx.answer))
end

function on_result(ctx, result)
  local language = ctx.answer or ""

  -- A whole document goes beside the document, not on top of it: the reader is
  -- comparing it against what is on screen. A selection is a few lines, and a
  -- panel for a few lines is more furniture than answer.
  if ctx.command == "translate.document" then
    return sdk.panel(result, language)
  end
  return sdk.show(result, language)
end
