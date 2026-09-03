# MarkText Plus KI-Übersetzungs-Plug-in

Hauptanwendung: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | Deutsch | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Übersetzt die Auswahl oder das ganze Dokument über das Modell, das Sie in MarkText Plus eingerichtet haben. Erfordert MarkText Plus 1.6.1 oder neuer.

Dieses Repository ist bewusst nicht von MarkText Plus geprüft. Lesen Sie den Quelltext, bevor Sie es installieren — es sind zwei kurze Dateien.

## Was es tut

Klicken Sie im Editor mit der rechten Maustaste. Ist Text markiert, wird **Auswahl übersetzen** angeboten; ist nichts markiert, **Dokument übersetzen**. Jeder Eintrag erscheint nur dann, wenn er zutrifft, sodass Ihnen nie der angeboten wird, den Sie nicht gemeint haben.

Nach der Zielsprache wird einmal gefragt — die üblichen stehen zum Anklicken bereit, und was Sie stattdessen eintippen, wird unverändert übernommen — und die Antwort wird für das nächste Mal behalten.

Eine übersetzte Auswahl erscheint in einem kleinen Fenster mit Kopierschaltfläche. Ein übersetztes Dokument öffnet sich in einem Bereich neben Ihrem Text, wo Sie es gegen das Original lesen können. **In Ihr Dokument wird nichts geschrieben**: eine Übersetzung, die Sie noch nicht gelesen haben, ist keine Änderung, um die Sie gebeten haben.

## Wie es funktioniert

Zwei Dateien: [`plugin.lua`](../../plugin.lua) und [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), das API-Modul des SDK, das `plugin.lua` per `require` lädt, kein Build, keine Abhängigkeiten, auf Windows, macOS und Linux dieselbe. Es läuft im Editor in einer Sandbox ohne Dateisystem, ohne Netzwerk und ohne `os`-Bibliothek.

**Der Prompt steht hier, im Plug-in**, und er ist es, der das Markdown tatsächlich heil lässt:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

Den API-Schlüssel hält der Editor, und der Editor stellt die Anfrage; das Plug-in bekommt ihn nie zu sehen und schreibt selbst nichts ins Netz. Dem Modell wird genau der obige Text vorgelegt, gefolgt von Ihrem Dokument.

## Worum es bittet

| Berechtigung | Wofür |
|---|---|
| `document.read` | den zu übersetzenden Text lesen |
| `ai.chat` | das eingerichtete Modell fragen |
| `storage.local` | sich Ihre Zielsprache merken |
| `ui.contextMenu` | die beiden Kontextmenü-Einträge |
| `ui.settings` | die eigene Einstellungsseite |
| `ui.notifications` | sagen, wenn nichts markiert ist |

Es bittet nicht um `document.write`, kann Ihr Dokument also selbst dann nicht ändern, wenn es das versuchte, und es bittet nicht um `network.request`, kann Ihren Text also nirgendwohin senden, wohin der Editor ihn nicht ohnehin gesendet hat.

## Einstellungen

Ein einziges Feld auf der eigenen Einstellungsseite: die voreingestellte Zielsprache, die es für Sie ausfüllt und bei jeder anderen Wahl aktualisiert.

## Sprachen

Menüeinträge und Rückfragen liegen auf English, 简体中文, 日本語, Deutsch und Français bei. Eine weitere hinzuzufügen sind ein paar Zeilen unter `locales` in [`manifest.json`](../../manifest.json) — Pull Requests willkommen.

## Installation

Laden Sie das Release-ZIP herunter und verwenden Sie in MarkText Plus **Plug-ins → Aus ZIP installieren**, oder finden Sie es über **Entdecken**: dieses Repository trägt das GitHub-Thema `marktext-plus-plugin`.

MIT-lizenziert.
