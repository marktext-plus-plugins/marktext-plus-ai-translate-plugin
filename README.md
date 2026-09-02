# MarkText Plus AI Translate Plugin
Main application: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)


An open, community plugin that translates selected Markdown through the provider configured by MarkText Plus.

This repository is intentionally unverified by MarkText Plus. Users should inspect the source and release before installing it.

## Supported protocol

The plugin runs as a separate process and reads one JSON-RPC request per line from stdin. It supports:

- `initialize`: receives provider, endpoint, model, and a short-lived API key from the host secret bridge.
- `translate`: receives `text` and `targetLanguage`, then returns translated text.
- `shutdown`: exits cleanly.

The plugin never writes API keys to disk. The host should provide secrets only in memory.

## Run

```bash
dart run bin/ai_translate.dart
```

The plugin supports OpenAI-style chat completions and Anthropic Messages API requests through raw HTTPS. It does not use an OpenAI-compatible shim for Anthropic.

Add the GitHub topic `marktext-plus-plugin` to make this public repository discoverable by MarkText Plus.
