# MarkText Plus AI 翻訳プラグイン

メインアプリケーション：[MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | 日本語 | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

MarkText Plus で設定したモデルを使って、選択範囲またはドキュメント全体を翻訳します。MarkText Plus 1.6.1 以降が必要です。

このリポジトリは意図的に MarkText Plus の検証を受けていません。インストールする前にソースを読んでください——ファイルは二つだけです。

## できること

エディタ内で右クリックします。テキストを選択していれば**選択範囲を翻訳**が、何も選択していなければ**ドキュメントを翻訳**が出ます。それぞれ当てはまるときだけ現れるので、意図しないほうを差し出されることはありません。

翻訳先の言語は一度だけ尋ねられます——よく使うものはその場で押せますし、代わりに入力したものはそのまま使われます——そして答えは次回のために記憶されます。

選択範囲の翻訳は、コピーボタン付きの小さなウィンドウに出ます。ドキュメント全体の翻訳は本文の横のパネルに開き、原文と読み比べられます。**ドキュメントには何も書き込まれません**：まだ読んでいない翻訳は、あなたが求めた編集ではありません。

## しくみ

二つのファイルです：[`plugin.lua`](../../plugin.lua) と [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua)（SDK の API モジュール、`require` で読み込まれます）——ビルド不要、依存関係なし、Windows・macOS・Linux で同じもの。エディタ内部のサンドボックスで動き、ファイルシステムもネットワークも `os` ライブラリもありません。

**プロンプトはこのプラグインの中にあります**。Markdown を壊さずに保つのは、まさにそれです：

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

API キーはエディタが保持し、リクエストもエディタが送ります。プラグインがそれを見ることは一度もなく、自分でネットワークに何かを書き出すこともありません。モデルに渡されるのは、上の文章にあなたのドキュメントを続けたものだけです。

## 要求する権限

| 権限 | 理由 |
|---|---|
| `document.read` | 翻訳するテキストを読むため |
| `ai.chat` | 設定済みのモデルに尋ねるため |
| `storage.local` | 翻訳先の言語を覚えておくため |
| `ui.contextMenu` | 右クリックの二項目のため |
| `ui.settings` | 自身の設定ページのため |
| `ui.notifications` | 何も選択されていないと伝えるため |

`document.write` は要求していないので、たとえ試みてもドキュメントを変更できません。`network.request` も要求していないので、エディタが送った先以外にあなたの文章を送ることはできません。

## 設定

自身の設定ページに項目は一つ、既定の翻訳先言語です。自動で埋められ、別の言語を選ぶたびに更新されます。

## 言語

メニュー項目と問いかけは English、简体中文、日本語、Deutsch、Français を同梱しています。追加は [`manifest.json`](../../manifest.json) の `locales` に数行足すだけです——プルリクエスト歓迎。

## インストール

リリースの ZIP をダウンロードし、MarkText Plus の**プラグイン → ZIP からインストール**を使ってください。あるいは**探す**から見つけられます：このリポジトリには GitHub トピック `marktext-plus-plugin` が付いています。

MIT ライセンス。
