# Assistente IA per MarkText Plus

Applicazione principale: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | Italiano | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Scrivere, correggere e tradurre con il modello che hai configurato in MarkText Plus. Richiede MarkText Plus 1.6.1 o successivo.

Questo repository non è verificato da MarkText Plus, di proposito. Leggi il sorgente prima di installarlo: sono quattro file brevi.

**Ancora 0.x.** Il protocollo delle estensioni dell’editor si sta assestando ma non è assestato, e questa estensione lo segue.

## Che cosa fa

Clic destro nell’editor.

| Voce | Che cosa fa |
|---|---|
| **Scrittura IA** | Dì che cosa deve fare — o prendi una delle risposte solite — e riscrive ciò che hai selezionato. Senza selezione riscrive il documento; con il documento vuoto scrive dalla tua sola indicazione |
| **Correzione IA** | Ortografia, errori di battitura, grammatica e punteggiatura, nient’altro: la voce è di chi scrive. Niente da rispondere, perché correggere è tutto il compito |
| **Traduci la selezione** | Compare solo quando qualcosa è selezionato |
| **Traduci il documento** | Compare solo quando non lo è |

Nella barra laterale destra c’è anche un’icona per scrivere: la via d’ingresso quando non c’è nulla di selezionato e nulla di aperto.

**Scrittura e correzione mostrano il risultato prima che vada da qualche parte.** Compare in un riquadro accanto al testo con un pulsante Applica; applicare passa per la cronologia dell’editor, e un annulla lo riporta indietro. Ciò che un modello restituisce merita di essere letto prima di finire in quello che stavi scrivendo.

**La traduzione non offre nulla da applicare.** Sostituire un documento con la sua traduzione non è ciò che qualcuno intende per «tradurre»: viene mostrata per essere letta e copiata. Un documento intero è tradotto a gruppi e compare mentre arriva — vedi l’inizio mentre la fine è ancora per strada, e un errore costa un gruppo anziché il file. È disegnata come stai leggendo: come sorgente accanto alla vista sorgente, resa accanto all’anteprima.

## Come funziona

Quattro file: [`plugin.lua`](../../plugin.lua), il modulo API dell’SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua), che tiene i prompt e le tue modifiche, e [`lib/blocks.lua`](../../lib/blocks.lua), che divide un documento in paragrafi e li raggruppa in richieste. `plugin.lua` li carica con `require`. Nessuna build, nessuna dipendenza, uguale su Windows, macOS e Linux. Gira in una sandbox dentro l’editor, senza file system, senza rete e senza libreria `os`: `require` arriva soltanto dentro la cartella dell’estensione stessa.

**I prompt stanno qui, nell’estensione**, e sono loro a tenere intatto il Markdown:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

L’editor tiene la tua chiave API e fa la richiesta; l’estensione non la vede mai e non tocca la rete da sé.

## Che cosa chiede

| Permesso | Perché |
|---|---|
| `document.read` | il testo su cui lavorare |
| `document.write` | per applicare una riscrittura, e solo quando premi Applica |
| `ai.chat` | per interrogare il modello che hai configurato |
| `storage.local` | per ricordare i tuoi prompt e la lingua di destinazione |
| `ui.contextMenu` | le quattro voci del clic destro |
| `ui.sidebar` | l’icona di scrittura |
| `ui.settings` | la sua pagina di impostazioni |
| `ui.notifications` | per dire quando non c’è nulla su cui lavorare |

Non chiede `network.request`, quindi non può mandare il tuo testo dove l’editor non l’ha mandato. `document.write` lo verifica l’editor quando premi Applica, non sulla parola dell’estensione.

## Impostazioni

Sei campi, sulla sua pagina: un prompt di sistema e uno utente per ciascuno dei tre comandi. Che cosa sia il modello e che cosa gli si dia sono due cose diverse da voler cambiare — e un modello che continua a tradurre male un certo tipo di documento si aggiusta dicendolo nel prompt, cosa che da fuori dell’estensione non può fare nessuno.

| Segnaposto | Riempito con |
|---|---|
| `{{text}}` | il testo su cui si lavora |
| `{{language}}` | la lingua di destinazione scelta |
| `{{instruction}}` | ciò che hai chiesto alla scrittura |

Un modello che dimentica `{{text}}` si vede aggiungere il testo in coda, perché un prompt senza nulla su cui lavorare è peggio di uno disordinato. Ogni campo mostra il proprio valore predefinito, così vedi che cosa stai cambiando; svuotarlo lo ripristina.

Doppie graffe anziché `${...}`: quella forma è interpolazione in Dart, nelle stringhe template di JavaScript e nella shell, e `$` è anche il delimitatore di KaTeX, che questo editor disegna.

## Lingue

Dodici, come l’editor: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) e العربية. Aggiungerne una sono poche righe sotto `locales` in [`manifest.json`](../../manifest.json) — le pull request sono benvenute.

## Installazione

Scarica lo ZIP della release e usa **Estensioni → Installa da ZIP** in MarkText Plus, oppure trovala da **Scopri**: questo repository porta il topic GitHub `marktext-plus-plugin`.

Licenza MIT.
