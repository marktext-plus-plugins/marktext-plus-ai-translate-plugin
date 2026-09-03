# Changelog

## [0.2.0] - 2026-09-03

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
