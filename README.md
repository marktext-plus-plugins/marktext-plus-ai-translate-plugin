# MarkText Plus AI Translate Plugin

Main application: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

Translates the selection, or the whole document, through whichever model you
have configured in MarkText Plus. Requires MarkText Plus 1.7.0 or newer.

This repository is intentionally unverified by MarkText Plus. Read the source
before you install it — it is one file.

## What it does

Right-click in the editor and pick **Translate selection** or **Translate
document**. It asks once which language you want, remembers the answer, and
shows the translation beside the original. Nothing is written into your
document: a translation you have not read yet is not an edit you asked for.

## How it works

The whole plugin is [`plugin.lua`](plugin.lua) — one file, no build, no
dependencies, the same on Windows, macOS and Linux. It runs inside the editor
in a sandbox with no file system, no network and no `os` library.

**The prompt lives here, in the plugin**, and it is what actually keeps
Markdown intact:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

The editor holds your API key and makes the request; the plugin never sees it,
and never writes anything to the network itself. What the model is asked is
exactly the text above with your document appended.

## What it asks for

| Permission | Why |
|---|---|
| `document.read` | the text to translate |
| `ai.chat` | to ask your configured model |
| `storage.local` | to remember your target language |
| `ui.contextMenu` | the two right-click entries |
| `ui.settings` | its settings page |
| `ui.notifications` | to say when nothing is selected |

It does not ask for `document.write`, so it cannot change your document even
if it tried, and it does not ask for `network.request`, so it cannot send your
text anywhere the editor did not send it.

## Settings

One field, on the plugin's own settings page: the default target language,
which it fills in for you and updates each time you pick a different one.

## Languages

The menu entries and prompts ship in English, 简体中文, 日本語, Deutsch and
Français. Adding another is a few lines in `locales` in
[`manifest.json`](manifest.json) — pull requests welcome.

## Install

Download the release ZIP and use **Plugins → Install from ZIP** in MarkText
Plus, or find it through **Discover**: this repository carries the GitHub topic
`marktext-plus-plugin`.

MIT licensed.
