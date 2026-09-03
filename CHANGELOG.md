# Changelog

## [1.0.1] - 2026-09-03

### Fixed

- Both commands were offered at once: "translate the selection" with nothing
  selected, and "translate the document" while pointing at a paragraph. Each
  now appears only when it applies.
- A translated paragraph arrived as a dialog the width of the window showing it
  beside the original. It is now one small window with the translation in it.
- A translated document arrived the same way, covering the document it was
  meant to be read against. It now opens in a panel beside the text.

### Added

- Ten common languages offered as chips on the language question. Anything
  typed instead is still taken as it stands.

Requires MarkText Plus 1.6.1 or newer.

## [1.0.0] - 2026-09-03

Rewritten as a script plugin. The first version could not run on a reader's
machine at all.

### Changed

- The plugin is now one Lua file that runs inside the editor, replacing a Dart
  program the editor spawned as a child process.
- The two commands appear in the editor's right-click menu, where translating
  something is actually done, rather than as an icon in the plugins panel's
  title bar.
- A translation is shown beside the original instead of replacing the
  selection.

### Added

- The target language is asked once and remembered.
- Menu entries, prompts and the settings field in English, 简体中文, 日本語,
  Deutsch and Français.
- A settings page with the default target language.

### Fixed

- "Bad state: plugin process exited". The plugin shipped Dart source, which
  the editor started with `Platform.resolvedExecutable` — in a release build
  that is the editor's own binary, so it launched a second editor and waited
  for it to answer JSON-RPC. A reader with no Dart SDK could never have run
  the old version either way.

## [0.1.0] - 2026-09-02

### Added

- Initial community AI translation plugin.
- OpenAI and Anthropic provider request formats.
- JSON-RPC stdin/stdout protocol with Markdown-preserving translation prompts.
- No API key persistence in the plugin directory.
