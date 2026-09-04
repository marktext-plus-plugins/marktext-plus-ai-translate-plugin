# MarkText Plus KI-Assistent

Hauptanwendung: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | Deutsch | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Schreiben, Korrekturlesen und Übersetzen mit dem Modell, das Sie in MarkText Plus eingerichtet haben. Erfordert MarkText Plus 1.6.1 oder neuer.

Dieses Repository ist absichtlich nicht von MarkText Plus geprüft. Lesen Sie den Quelltext, bevor Sie es installieren — es sind vier kurze Dateien.

**Weiterhin 0.x.** Das Plug-in-Protokoll des Editors setzt sich, ist aber noch nicht gesetzt, und dieses Plug-in folgt ihm.

## Was es tut

Rechtsklick im Editor.

| Eintrag | Was er tut |
|---|---|
| **KI-Schreiben** | Sagen Sie, was geschehen soll — oder nehmen Sie eine der üblichen Antworten — und es schreibt um, was Sie ausgewählt haben. Ohne Auswahl das Dokument; bei leerem Dokument schreibt es allein aus Ihrer Vorgabe |
| **KI-Korrektur** | Rechtschreibung, Vertipper, Grammatik und Zeichensetzung, sonst nichts: die Stimme gehört der Autorin. Nichts zu beantworten, denn Fehler zu beheben ist der ganze Auftrag |
| **Auswahl übersetzen** | Nur wenn etwas ausgewählt ist |
| **Dokument übersetzen** | Nur wenn nichts ausgewählt ist |

In der rechten Seitenleiste gibt es außerdem ein Symbol zum Schreiben — der Weg hinein, wenn nichts ausgewählt und nichts geöffnet ist.

**Schreiben und Korrektur zeigen das Ergebnis, bevor es irgendwohin geht.** Es erscheint in einem Bereich neben Ihrem Text mit einer Übernehmen-Schaltfläche; das Übernehmen läuft über die Editorhistorie, ein Rückgängig holt es zurück. Was ein Modell zurückgibt, ist es wert, gelesen zu werden, bevor es in dem landet, was Sie geschrieben haben.

**Beim Übersetzen gibt es nichts zu übernehmen.** Ein Dokument durch seine Übersetzung zu ersetzen meint niemand mit „übersetzen“; es wird zum Lesen und Kopieren gezeigt. Ein ganzes Dokument wird in Stapeln übersetzt und erscheint, während es ankommt — Sie sehen den Anfang, während das Ende noch unterwegs ist, und ein Fehlschlag kostet einen Stapel statt der Datei. Gezeichnet wird es so, wie Sie lesen: als Quelltext neben der Quelltextansicht, gesetzt neben der Vorschau.

## Wie es funktioniert

Vier Dateien: [`plugin.lua`](../../plugin.lua), das API-Modul des SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua) mit den Prompts und Ihren Änderungen daran, und [`lib/blocks.lua`](../../lib/blocks.lua), das ein Dokument in Absätze teilt und wieder zu Anfragen bündelt. `plugin.lua` lädt sie mit `require`. Kein Build, keine Abhängigkeiten, auf Windows, macOS und Linux dasselbe. Es läuft in einer Sandbox im Editor, ohne Dateisystem, ohne Netz und ohne `os`-Bibliothek — `require` reicht nur in das eigene Verzeichnis dieses Plug-ins.

**Die Prompts stehen hier, im Plug-in**, und sie sind es, die das Markdown tatsächlich heil lassen:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

Der Editor hält Ihren API-Schlüssel und stellt die Anfrage; das Plug-in bekommt ihn nie zu sehen und greift selbst nicht aufs Netz.

## Worum es bittet

| Recht | Wofür |
|---|---|
| `document.read` | der Text, der bearbeitet wird |
| `document.write` | um eine Umschreibung zu übernehmen, und nur wenn Sie Übernehmen drücken |
| `ai.chat` | um Ihr eingerichtetes Modell zu fragen |
| `storage.local` | um Ihre Prompts und Ihre Zielsprache zu behalten |
| `ui.contextMenu` | die vier Einträge im Kontextmenü |
| `ui.sidebar` | das Symbol zum Schreiben |
| `ui.settings` | die eigene Einstellungsseite |
| `ui.notifications` | um zu sagen, wenn es nichts zu bearbeiten gibt |

Es bittet nicht um `network.request`, kann Ihren Text also nirgendwohin senden, wohin der Editor ihn nicht gesendet hat. `document.write` prüft der Editor, wenn Sie Übernehmen drücken — nicht auf das Wort des Plug-ins hin.

## Einstellungen

Sechs Felder auf der eigenen Einstellungsseite: ein System- und ein Benutzer-Prompt für jeden der drei Befehle. Was das Modell ist und was es bekommt, sind zwei verschiedene Dinge, die man ändern möchte — und ein Modell, das eine bestimmte Art von Dokument immer wieder falsch übersetzt, wird geheilt, indem man das in den Prompt schreibt, was von außerhalb des Plug-ins niemand kann.

| Platzhalter | Wird gefüllt mit |
|---|---|
| `{{text}}` | dem Text, an dem gearbeitet wird |
| `{{language}}` | der gewählten Zielsprache |
| `{{instruction}}` | dem, worum Sie das Schreiben gebeten haben |

Eine Vorlage, die `{{text}}` vergisst, bekommt den Text angehängt, denn ein Prompt ohne etwas zu bearbeiten ist schlimmer als ein unordentlicher. Jedes Feld zeigt seinen Standardwert, damit Sie sehen, was Sie ändern; leeren setzt ihn zurück.

Doppelte geschweifte Klammern statt `${...}`: jene Form ist Interpolation in Dart, in JavaScript-Template-Strings und in der Shell, und `$` ist zudem das Trennzeichen von KaTeX, das dieser Editor setzt.

## Sprachen

Zwölf, wie im Editor: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) und العربية. Eine weitere sind ein paar Zeilen unter `locales` in [`manifest.json`](../../manifest.json) — Pull Requests willkommen.

## Installation

Laden Sie das Release-ZIP herunter und nutzen Sie in MarkText Plus **Plug-ins → Aus ZIP installieren**, oder finden Sie es über **Entdecken**: dieses Repository trägt das GitHub-Topic `marktext-plus-plugin`.

MIT-lizenziert.
