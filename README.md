# MarkText Plus AI Assistant

Main application: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[简体中文](docs/i18n/README_zh-CN.md) | [日本語](docs/i18n/README_ja-JP.md) | [한국어](docs/i18n/README_ko-KR.md) | [Deutsch](docs/i18n/README_de-DE.md) | [Français](docs/i18n/README_fr-FR.md) | [Italiano](docs/i18n/README_it-IT.md) | [Русский](docs/i18n/README_ru-RU.md) | [Español](docs/i18n/README_es-ES.md) | [Português](docs/i18n/README_pt-PT.md) | [العربية](docs/i18n/README_ar-SA.md) | [Português (Brasil)](docs/i18n/README_pt-BR.md)

Writing, proofreading and translation, through whichever model you have
configured in MarkText Plus. Requires MarkText Plus 1.6.1 or newer.

This repository is intentionally unverified by MarkText Plus. Read the source
before you install it — it is four short files.

**Still 0.x.** The editor's plugin protocol is settling but not settled, and
this plugin follows it.

## What it does

Right-click in the editor.

| Entry | What it does |
|---|---|
| **AI writing** | Say what it should do — or take one of the usual answers — and it rewrites what you selected. With nothing selected it rewrites the document; with nothing in the document it writes from your brief alone |
| **AI proofreading** | Spelling, typing slips, grammar and punctuation, and nothing else. Nothing to answer: correcting mistakes is the whole brief |
| **Translate selection** | Offered only when something is selected |
| **Translate document** | Offered only when nothing is |

There is also an icon in the right side bar for writing, which is the way in
when there is nothing selected and nothing open.

**Writing and proofreading show you the result before it goes anywhere.** It
appears in a pane beside your text with an Apply button; applying goes through
the editor's history, so one press of undo takes it back. What a model returns
is worth reading before it lands in what you were writing.

**Translation offers nothing to apply.** Replacing a document with its
translation is not what anyone means by "translate", so it is shown to read
and to copy. A whole document is translated in batches and appears as it
arrives — you see the beginning while the end is still coming, and a failure
costs one batch rather than the file. It is drawn the way you are reading: as
source beside the source view, rendered beside the preview.

## How it works

Four files: [`plugin.lua`](plugin.lua), the SDK's API module
[`lib/marktext-plus.lua`](lib/marktext-plus.lua),
[`lib/prompts.lua`](lib/prompts.lua), which holds the prompts and your changes
to them, and [`lib/blocks.lua`](lib/blocks.lua), which splits a document into
paragraphs and groups them back into requests. `plugin.lua` loads them with
`require`. No build, no dependencies, the same on Windows, macOS and Linux. It
runs inside the editor in a sandbox with no file system, no network and no
`os` library — `require` reaches only inside this plugin's own directory.

**The prompts live here, in the plugin**, and they are what actually keeps
Markdown intact:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

The editor holds your API key and makes the request; the plugin never sees it,
and never reaches the network itself.

## What it asks for

| Permission | Why |
|---|---|
| `document.read` | the text to work on |
| `document.write` | to apply a rewrite, and only when you press Apply |
| `ai.chat` | to ask your configured model |
| `storage.local` | to remember your prompts and your target language |
| `ui.contextMenu` | the four right-click entries |
| `ui.sidebar` | the writing icon |
| `ui.settings` | its settings page |
| `ui.notifications` | to say when there is nothing to work on |

It does not ask for `network.request`, so it cannot send your text anywhere
the editor did not send it. `document.write` is checked by the editor when you
press Apply, not taken from the plugin's word for it.

## Settings

Six fields, on the plugin's own settings page: a system prompt and a user
prompt for each of the three commands. What the model is, and what it is being
given, are two different things to want to change — and a model that keeps
mistranslating a particular kind of document is fixed by saying so in the
prompt, which nobody can do from outside the plugin.

| Placeholder | Filled with |
|---|---|
| `{{text}}` | the text being worked on |
| `{{language}}` | the target language you chose |
| `{{instruction}}` | what you asked writing to do |

A template that forgets `{{text}}` gets the text appended, because a prompt
with nothing to work on in it is worse than an untidy one. Each field shows
its default, so you can see what you are changing; emptying one puts the
default back.

Double braces rather than `${...}`: that form is interpolation in Dart, in
JavaScript template strings and in the shell, and `$` is also KaTeX's
delimiter, which this editor renders.

## Languages

Twelve, matching the editor's: English, 简体中文, 日本語, 한국어, Deutsch,
Français, Italiano, Русский, Español, Português, Português (Brasil) and
العربية. Adding another is a few lines in `locales` in
[`manifest.json`](manifest.json) — pull requests welcome.

## Install

Download the release ZIP and use **Plugins → Install from ZIP** in MarkText
Plus, or find it through **Discover**: this repository carries the GitHub topic
`marktext-plus-plugin`.

MIT licensed.
