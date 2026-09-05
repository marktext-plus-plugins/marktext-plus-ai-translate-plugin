# Changelog

## [Unreleased]

### Fixed

- **A code block containing a fence was cut in half.** Splitting a document
  for translation ended a block on any fence at all, so the ``` a document
  shows inside a ```` block ended it — and the blank line underneath became a
  cut, handing the model half a program. What closes a block now depends on
  what opened it: the same character, at least as long, with nothing after
  it. `~~~` and ``` no longer close each other, and a ```js line inside a
  block is code rather than the end of it.

## [0.1.4] - 2026-09-05

The first release rather than a pre-release, and the plugin is **AI
Assistant**: writing, proofreading and translation. Same repository and same
id, so it arrives as an update.

Still 0.x. The editor's plugin protocol is settling but not settled, and this
plugin follows it.

### Added

- **AI writing.** Right-click, say what it should do — or take one of the
  usual answers — and the rewrite appears in a pane with an Apply button. With
  nothing selected it rewrites the document; with nothing in the document it
  is a blank page, which is what the side bar icon is for.
- **AI proofreading.** Spelling, typing slips, grammar and punctuation, and
  nothing else: the voice is the author's. Nothing to answer, because
  correcting mistakes is the whole brief.
- **Shown before applied.** What a model returns is worth reading before it
  lands in what you were writing, and Apply goes through the editor's history,
  so one press of undo takes it back.
- **Six prompts, all yours.** A system prompt and a user prompt for each
  command — what the model is, and what it is being given, are two different
  things to want to change. `{{text}}` is where the source goes,
  `{{language}}` what you chose, `{{instruction}}` what you asked for.
- **An icon in the right side bar**, for writing without selecting anything
  first.

### Changed

- Translation now sends paragraphs in batches rather than one request each: a
  long document was dozens of round trips for text that fits in a handful. A
  fenced block is never cut, a paragraph over the budget still travels alone,
  and a heading is never sent by itself.
- The pane opens before the first request rather than after it, so it says it
  is working instead of sitting empty.
- Twelve languages, matching the editor's.

### Requires

MarkText Plus **v1.6.1** or newer. Applying a rewrite needs the editor to let
a plugin write to the document, which older versions do not.

## [0.1.3] - 2026-09-03

Pre-release, and updated in place while it stays one — the tag does not move
for every change to something that has not settled.

### Updated 2026-09-04 — three commands, not one

The plugin is **AI Assistant** now: writing, proofreading and translation.
Same repository, same id, so it arrives as an update.

- **AI writing.** Right-click, say what it should do — or pick one of the
  usual answers — and the rewrite appears in a pane with an Apply button. With
  nothing selected it rewrites the document; with nothing in the document it
  is a blank page, which is what the side bar icon is for.
- **AI proofreading.** Spelling, typing slips, grammar and punctuation, and
  nothing else: the voice is the author's. No question to answer, because
  correcting mistakes is the whole brief.
- **Both are shown before they are applied.** What a model returns is worth
  reading before it lands in what you were writing, and Apply goes through the
  editor's history, so one press of undo takes it back.
- **Six prompts, all yours.** A system prompt and a user prompt for each
  command — what the model is, and what it is being given, are two different
  things to want to change. `{{text}}` is where the source goes, `{{language}}`
  what you chose, `{{instruction}}` what you asked for. Double braces rather
  than `${...}`, which is interpolation in Dart, in JavaScript template
  strings and in the shell, and shares a character with KaTeX.
- Translation is unchanged, and still offers nothing to apply: replacing a
  document with its translation is not what anyone means by "translate".

### Updated 2026-09-04

- **It says what it is, in the plugin list**, in the twelve languages the
  application ships. The list had only a name to show; the five languages here
  covered fewer than half its readers.
- **The pane opens before the first request rather than after it**, so it says
  it is working instead of sitting empty for the seconds the first paragraph
  takes. The editor reads a pane action ahead of an `ai` one, so returning
  both means "put this up, then go and ask".
- **Paragraphs travel together up to a budget**, instead of one request each.
  A paragraph is the smallest thing worth translating on its own, but a
  request per paragraph is dozens of round trips for a document that fits in a
  handful. A fence is never cut, a paragraph over the budget still travels
  alone, and a heading is never sent by itself — on its own it tells the model
  nothing about the register or the subject it is translating.

### Changed

- A whole document is translated a block at a time and appears a block at a
  time, in a pane beside the text. It used to go to the model in one request:
  slow on a long file, past what the model will take on a longer one, and
  losing everything rather than one paragraph when it failed.
- The translation is drawn the way the document is being read — as source
  beside the source view, rendered beside the preview. Raw Markdown next to a
  rendered preview cannot be compared with what it sits beside.

### Fixed

- Splitting on blank lines no longer cuts a fenced code block in half, and the
  paragraph above a code block is its own block.

## [0.1.2] - 2026-09-03

Pre-release.

### Changed

- Uses the SDK's API module, `lib/marktext-plus.lua`, loaded with `require`.
  The plugin now reads as `sdk.show(result, language)` rather than as a table
  literal whose spelling nothing checks, and it is two files instead of one —
  which is the point: a plugin was limited to one file until `require` landed.

## [0.1.1] - 2026-09-03

Pre-release. Nothing here is settled, and the version stays in 0.x until it is.

### Changed

- Rewritten as a Lua script plugin. The first version shipped Dart source and
  could not run on anyone's machine: the editor started it with
  `Platform.resolvedExecutable`, which in a release build is the editor's own
  binary — `Bad state: plugin process exited`. Running it would have needed a
  Dart SDK nobody has a reason to install.
- The two commands are in the editor's right-click menu, where someone
  translating a paragraph is looking, and each appears only when it applies.
- A translated selection comes back in a small window; a translated document
  opens in a panel beside the text. Neither replaces your selection.

### Added

- The target language is asked once, offered as ten common ones to press, and
  remembered. Anything typed instead is used as it stands.
- Menu entries, prompts and settings in English, 简体中文, 日本語, Deutsch and
  Français.
- A settings page with the default target language.

Requires MarkText Plus 1.6.1 or newer.

## [0.1.0] - 2026-09-02

### Added

- Initial community AI translation plugin.
- OpenAI and Anthropic provider request formats.
- JSON-RPC stdin/stdout protocol with Markdown-preserving translation prompts.
- No API key persistence in the plugin directory.
