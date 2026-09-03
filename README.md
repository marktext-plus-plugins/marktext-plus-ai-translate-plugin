# MarkText Plus AI Translate Plugin

Main application: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[简体中文](docs/i18n/README_zh-CN.md) | [日本語](docs/i18n/README_ja-JP.md) | [한국어](docs/i18n/README_ko-KR.md) | [Deutsch](docs/i18n/README_de-DE.md) | [Français](docs/i18n/README_fr-FR.md) | [Italiano](docs/i18n/README_it-IT.md) | [Русский](docs/i18n/README_ru-RU.md) | [Español](docs/i18n/README_es-ES.md) | [Português](docs/i18n/README_pt-PT.md) | [العربية](docs/i18n/README_ar-SA.md) | [Português (Brasil)](docs/i18n/README_pt-BR.md)

Translates the selection, or the whole document, through whichever model you
have configured in MarkText Plus. Requires MarkText Plus 1.6.1 or newer.

This repository is intentionally unverified by MarkText Plus. Read the source
before you install it — it is three short files.

**Every release here is a pre-release.** It stays at 0.x, and it changes when
it needs to; nothing about it is settled yet.

## What it does

Right-click in the editor. With text selected you are offered **Translate
selection**; with nothing selected, **Translate document**. Each appears only
when it applies, so you are never offered the one you did not mean.

It asks once which language you want — the usual ones are there to press, and
anything you type instead is used as it stands — and remembers your answer for
next time.

A translated selection comes back in a small window with a copy button.

A whole document is translated a paragraph at a time and appears a paragraph at
a time, in a pane beside your text — so you see the first one while the rest
are still arriving, and a failure costs one paragraph rather than the file. It
is drawn the way you are reading: as source beside the source view, rendered
beside the preview.

Nothing is written into your document: a translation you have not read yet is
not an edit you asked for.

## How it works

Three files: [`plugin.lua`](plugin.lua), the SDK's API module
[`lib/marktext-plus.lua`](lib/marktext-plus.lua), and
[`lib/blocks.lua`](lib/blocks.lua), which splits a document into paragraphs.
`plugin.lua` loads both with `require`. No build, no dependencies, the same on
Windows, macOS and Linux. It runs inside the editor in a sandbox with no file
system, no network and no `os` library — `require` reaches only inside this
plugin's own directory.

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
