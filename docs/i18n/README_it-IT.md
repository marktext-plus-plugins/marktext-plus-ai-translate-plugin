# Estensione di traduzione IA per MarkText Plus

Applicazione principale: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | Italiano | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Traduce la selezione, o l'intero documento, tramite il modello che avete configurato in MarkText Plus. Richiede MarkText Plus 1.6.1 o successivo.

Questo repository non è deliberatamente verificato da MarkText Plus. Leggete il sorgente prima di installarlo — è un solo file.

## Che cosa fa

Fate clic destro nell'editor. Con del testo selezionato compare **Traduci la selezione**; senza nulla di selezionato, **Traduci il documento**. Ciascuna voce appare solo quando è pertinente, così non vi viene mai proposta quella che non intendevate.

La lingua di destinazione viene chiesta una volta — le più comuni sono lì da premere, e quello che digitate al loro posto viene preso così com'è — e la risposta viene ricordata per la volta successiva.

Una selezione tradotta torna in una piccola finestra con un pulsante per copiare. Un documento tradotto si apre in un pannello accanto al vostro testo, dove potete leggerlo a fronte dell'originale. **Nel vostro documento non viene scritto nulla**: una traduzione che non avete ancora letto non è una modifica che avete chiesto.

## Come funziona

L'intera estensione è [`plugin.lua`](../../plugin.lua) — un file, nessuna compilazione, nessuna dipendenza, identico su Windows, macOS e Linux. Gira dentro l'editor in una sandbox senza file system, senza rete e senza la libreria `os`.

**Il prompt sta qui, nell'estensione**, ed è ciò che tiene davvero insieme il Markdown:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

La chiave API la custodisce l'editor, ed è l'editor a inviare la richiesta; l'estensione non la vede mai e non scrive nulla in rete per conto proprio. Al modello viene sottoposto esattamente il testo qui sopra seguito dal vostro documento.

## Che cosa chiede

| Permesso | Perché |
|---|---|
| `document.read` | leggere il testo da tradurre |
| `ai.chat` | interrogare il modello configurato |
| `storage.local` | ricordare la lingua di destinazione |
| `ui.contextMenu` | le due voci del clic destro |
| `ui.settings` | la propria pagina di impostazioni |
| `ui.notifications` | dire quando non c'è nulla di selezionato |

Non chiede `document.write`, quindi non può modificare il vostro documento nemmeno provandoci, e non chiede `network.request`, quindi non può mandare il vostro testo da nessuna parte dove l'editor non l'abbia già mandato.

## Impostazioni

Un solo campo, nella sua pagina di impostazioni: la lingua di destinazione predefinita, che compila per voi e aggiorna ogni volta che ne scegliete un'altra.

## Lingue

Le voci di menu e le domande sono fornite in English, 简体中文, 日本語, Deutsch e Français. Aggiungerne un'altra sono poche righe in `locales` dentro [`manifest.json`](../../manifest.json) — le pull request sono benvenute.

## Installazione

Scaricate lo ZIP della release e usate **Estensioni → Installa da ZIP** in MarkText Plus, oppure trovatela con **Scopri**: questo repository porta il topic GitHub `marktext-plus-plugin`.

Licenza MIT.
