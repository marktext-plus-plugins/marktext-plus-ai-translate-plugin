# Changelog

## [0.1.5] - 2026-09-11

### Changed

- **Writing and proofreading open under the document rather than beside it.**
  A rewrite is read against the paragraph it rewrites, and that comparison is
  made by dropping down a line of the same width — not by looking across two
  narrow columns. Both now fill the `bottom` slot, which is how a plugin says
  "under" as of this editor version; translation still opens beside, because a
  translation is read on its own rather than compared line for line.

  The reader can flip either one back with the button in the pane's title bar.

### Fixed

- **A document that itself contained `{{instruction}}` had it replaced by the
  brief you just typed.** The prompt was filled one placeholder at a time, so
  each replacement was scanned again by the next: once the document went in as
  `{{text}}`, the round that filled `{{instruction}}` found the reader's braces
  inside it. Measured — a document reading `A: {{instruction}}` reached the
  model as `A: MAKE-IT-SHORT`, and the rewrite came back with that in it.
  Anyone writing about Jinja, Handlebars, Vue or this plugin's own prompt
  settings writes `{{...}}` all day.

  Which key won depended on the order `pairs` happened to give, so only one of
  the three commands showed it and the same document could differ between
  runs. The template is now walked once: a value goes into the output and is
  never looked at again. A `{{name}}` the plugin has no value for is left as it
  stands — the prompts are yours to edit and the braces may be yours too.

- **A translated document was left behind in this plugin's settings file.**
  Translating works through the document a batch at a time, and what has not
  been sent yet has to survive between two calls — storage is the only place
  there is, so the document goes in there. That part is right. What was
  missing is letting go of it afterwards: measured on a 210 KB document,
  209 636 bytes of it stayed in `settings.json` once the translation had
  finished, for as long as the plugin stayed installed, and nothing read it
  again or said it was there.

  The copy is dropped as the last batch goes out. A translation abandoned
  half-way still leaves one, and the next translation overwrites it; what must
  not happen is a *finished* translation keeping the reader's document on
  disk. The editor now also writes a line to its log when any plugin's
  settings file passes four megabytes, which is far above anything that is
  actually settings.

- **A guard that did not guard, in every `blocks.lua` closure.** The editor's
  Lua treats a valueless `return` inside a nested function as nothing at all
  and runs the next line anyway. Four guards here were written that way. Three
  had a second check behind them and survived by luck; the fourth sent an
  empty request to the model. All now say `return nil`, and the SDK's README
  documents the trap — `if not ok then return end` is how everyone writes a
  guard, and inside `while true` the same fault is a loop with no exit.

- **A heading was sent with the paragraph above it instead of the text below.**
  Batching never breaks on a heading, so it joined whichever batch was open —
  the one above. Then the block it introduces overflowed, broke there, and
  went out on its own: a bare "## Results" glued to an unrelated paragraph,
  and its own text with nothing to say what it was. Trailing headings now move
  forward with the batch they belong to. The last batch keeps them, because
  there is nothing after it to carry them to.

- **A template that dropped `{{instruction}}` or `{{language}}` dropped what
  you had just told it.** The prompts are yours to edit, and one that forgets
  `{{text}}` has always had the source appended rather than sent an empty
  request. Its two siblings had no such net: remove `{{instruction}}` from the
  writing template and the brief you typed a second earlier went nowhere;
  remove `{{language}}` and the language you picked from the list did too.

  Worse than an error, because there is no error. The model answers a prompt
  that is missing them, so nothing looks wrong — the answer is simply to a
  question nobody asked. All three are now appended if their placeholder is in
  neither the system prompt nor the user one.

- **The writing ideas were English in every language.** Asking what to write
  offers six suggestions as chips — "Make it shorter", "More formal" — and
  they were written into `prompts.lua` as sentences rather than as keys, so a
  reader working in Japanese was asked a Japanese question and handed English
  answers. They are `locales` keys now, translated into all twelve.

- **A code block containing a fence was cut in half.** Splitting a document
  for translation ended a block on any fence at all, so the ``` a document
  shows inside a ```` block ended it — and the blank line underneath became a
  cut, handing the model half a program. What closes a block now depends on
  what opened it: the same character, at least as long, with nothing after
  it. `~~~` and ``` no longer close each other, and a ```js line inside a
  block is code rather than the end of it.


### Internal

- The copy of the API module this plugin ships had fallen five options behind
  the SDK's — `as`, `append`, `ai`, `apply` and `replaces`, every one of them
  added for this plugin's own features. The module is meant to be copied and
  owned, so drifting is allowed; drifting *behind* while being the reference
  plugin is not. It is the SDK's current file again, and the editor's test
  suite now compares the two.
- The panes are built with `sdk.pane` rather than as table literals. They were
  literals because the older constructor could not carry those five options —
  which is the situation the constructor exists to prevent, since a literal's
  spelling is checked by nothing. Behaviour is unchanged and the thirty-four
  tests that run this plugin say so.

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
