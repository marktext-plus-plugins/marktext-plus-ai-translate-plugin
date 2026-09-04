# MarkText Plus AI アシスタント

メインアプリケーション: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | 日本語 | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

MarkText Plus で設定したモデルを使って、執筆、校正、翻訳をします。MarkText Plus 1.6.1 以降が必要です。

このリポジトリは意図的に MarkText Plus の検証を受けていません。入れる前にソースを読んでください——短いファイルが四つだけです。

**まだ 0.x です。** エディタのプラグイン protocol は固まりつつありますが固まってはおらず、このプラグインはそれに従います。

## できること

エディタで右クリックします。

| メニュー項目 | 何をするか |
|---|---|
| **AI 執筆** | 何をしてほしいかを伝えると——よくある指示から選んでもかまいません——選択範囲を書き直します。何も選んでいなければ文書全体を、文書も空なら指示だけを頼りに一から書きます |
| **AI 校正** | 誤字、打ち間違い、文法、句読点だけを直します。それ以外には手を触れません——文体は書き手のものです。尋ねることはありません。間違いを直すことがすべてだからです |
| **選択範囲を翻訳** | 何かを選んでいるときだけ出ます |
| **ドキュメントを翻訳** | 何も選んでいないときだけ出ます |

右のサイドバーには執筆用のアイコンもあります。何も選ばず、何も開いていないときの入り口です。

**執筆と校正は、結果をまず見せます。** 本文の隣のペインに「適用」ボタンつきで現れ、適用はエディタの履歴を通るので、取り消し一回で戻ります。モデルが返したものは、あなたが書いていた文章に入る前に読む価値があります。

**翻訳には「適用」がありません。** 文書をその訳文で置き換えることは、誰も「翻訳」という言葉で意味していません。ですから読むためと写すためだけに示されます。文書全体はまとめて少しずつ訳され、届いた順に現れます——末尾がまだ来ないうちに冒頭を読めますし、失敗しても一まとまり分で済み、ファイル全体ではありません。読んでいる形で描かれます: ソース表示の隣ならソースとして、プレビューの隣なら整形されて。

## 仕組み

ファイルは四つ: [`plugin.lua`](../../plugin.lua)、SDK の API モジュール [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua)、プロンプトとあなたの変更を保持する [`lib/prompts.lua`](../../lib/prompts.lua)、そして文書を段落に切り、まとめ直す [`lib/blocks.lua`](../../lib/blocks.lua)。`plugin.lua` が `require` で読み込みます。ビルドも依存もなく、Windows、macOS、Linux で同じです。エディタの中のサンドボックスで動き、ファイルシステムもネットワークも `os` ライブラリもありません——`require` はこのプラグイン自身のディレクトリの中だけに届きます。

**プロンプトはこのプラグインの中にあり**、Markdown をそのまま保っているのは実際それです:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

API キーはエディタが持ち、要求もエディタが出します。プラグインはそれを見ることがなく、自分でネットワークに触れることもありません。

## 何を求めているか

| 権限 | なぜ |
|---|---|
| `document.read` | 扱う文章 |
| `document.write` | 書き直しを適用するため。「適用」を押したときだけです |
| `ai.chat` | 設定したモデルに尋ねるため |
| `storage.local` | プロンプトと翻訳先の言語を覚えるため |
| `ui.contextMenu` | 四つの右クリック項目 |
| `ui.sidebar` | 執筆のアイコン |
| `ui.settings` | 自分の設定ページ |
| `ui.notifications` | 扱うものがないと伝えるため |

`network.request` は求めていないので、エディタが送らなかった場所へあなたの文章を送ることはできません。`document.write` は「適用」を押したときにエディタが確かめます。プラグインの申告を信用してのことではありません。

## 設定

自分の設定ページに六つ。三つのコマンドそれぞれにシステムプロンプトとユーザープロンプトがあります。モデルが何であるかと、モデルに何を渡すかは、別々に変えたくなる別のことです——ある種類の文書をいつも訳し損ねるモデルは、プロンプトにそう書けば直りますが、それはプラグインの外からはできません。

| プレースホルダ | 入るもの |
|---|---|
| `{{text}}` | 扱っている文章 |
| `{{language}}` | 選んだ翻訳先の言語 |
| `{{instruction}}` | 執筆に頼んだこと |

`{{text}}` を書き忘れたテンプレートには、文章が末尾に付け足されます。扱うものが何も入っていないプロンプトは、整っていないプロンプトより悪いからです。どの欄も既定値を示すので、何を変えているのかが見えます。空にすれば既定に戻ります。

`${...}` ではなく二重波括弧にしています: 前者は Dart でも JavaScript のテンプレート文字列でもシェルでも補間の記法であり、`$` はこのエディタが描画する KaTeX の区切り記号でもあるためです。

## 言語

エディタと同じ十二: English、简体中文、日本語、한국어、Deutsch、Français、Italiano、Русский、Español、Português、Português (Brasil)、العربية。増やすには [`manifest.json`](../../manifest.json) の `locales` に数行加えるだけです——プルリクエストを歓迎します。

## インストール

リリースの ZIP をダウンロードし、MarkText Plus で**プラグイン → ZIP からインストール**を使ってください。あるいは**探す**から: このリポジトリには GitHub topic `marktext-plus-plugin` が付いています。

MIT ライセンスです。
