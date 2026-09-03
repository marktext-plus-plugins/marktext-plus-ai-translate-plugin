-- AI Translate for MarkText Plus.
--
-- The prompt and the flow live here, in the plugin. The editor supplies the
-- model the reader configured and never hands over the API key: this script
-- asks for a completion and gets text back.

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
    return { notify = t("error.empty") }
  end

  -- Ask once, then remember: the reader who translates into Japanese today
  -- is usually translating into Japanese tomorrow.
  if ctx.answer == nil then
    return {
      ask = t("ask.language"),
      default = storage.get("targetLanguage") or "English",
    }
  end
  storage.set("targetLanguage", ctx.answer)

  return { ai = build_prompt(text, ctx.answer) }
end

function on_result(ctx, result)
  -- Side by side, never written back: a translation the reader has not read
  -- is not an edit they asked for.
  return { diff = { original = source_for(ctx), result = result } }
end
