# Extension de traduction IA pour MarkText Plus

Application principale : [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | Français | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Traduit la sélection, ou le document entier, à l'aide du modèle que vous avez configuré dans MarkText Plus. Nécessite MarkText Plus 1.6.1 ou plus récent.

Ce dépôt n'est délibérément pas vérifié par MarkText Plus. Lisez la source avant de l'installer — c'est un seul fichier.

## Ce qu'elle fait

Faites un clic droit dans l'éditeur. Avec du texte sélectionné, on vous propose **Traduire la sélection** ; sans rien de sélectionné, **Traduire le document**. Chaque entrée n'apparaît que lorsqu'elle s'applique, si bien qu'on ne vous propose jamais celle que vous ne vouliez pas.

La langue cible vous est demandée une fois — les plus courantes sont là, à portée de clic, et ce que vous saisissez à la place est repris tel quel — puis votre réponse est retenue pour la fois suivante.

Une sélection traduite revient dans une petite fenêtre munie d'un bouton de copie. Un document traduit s'ouvre dans un panneau à côté de votre texte, où vous pouvez le lire face à l'original. **Rien n'est écrit dans votre document** : une traduction que vous n'avez pas encore lue n'est pas une modification que vous avez demandée.

## Comment elle fonctionne

Toute l'extension tient dans [`plugin.lua`](../../plugin.lua) — un fichier, aucune compilation, aucune dépendance, identique sur Windows, macOS et Linux. Elle s'exécute dans l'éditeur, dans un bac à sable sans système de fichiers, sans réseau et sans bibliothèque `os`.

**L'invite se trouve ici, dans l'extension**, et c'est elle qui préserve réellement le Markdown :

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

C'est l'éditeur qui détient votre clé d'API et qui effectue la requête ; l'extension ne la voit jamais et n'écrit rien elle-même sur le réseau. Ce qui est soumis au modèle, c'est exactement le texte ci-dessus suivi de votre document.

## Ce qu'elle demande

| Permission | Pourquoi |
|---|---|
| `document.read` | lire le texte à traduire |
| `ai.chat` | interroger le modèle configuré |
| `storage.local` | retenir votre langue cible |
| `ui.contextMenu` | les deux entrées du clic droit |
| `ui.settings` | sa propre page de réglages |
| `ui.notifications` | signaler qu'il n'y a rien de sélectionné |

Elle ne demande pas `document.write` : elle ne peut donc pas modifier votre document, même si elle l'essayait. Elle ne demande pas non plus `network.request` : elle ne peut donc envoyer votre texte nulle part ailleurs que là où l'éditeur l'a envoyé.

## Réglages

Un seul champ, sur sa propre page de réglages : la langue cible par défaut, qu'elle remplit pour vous et met à jour chaque fois que vous en choisissez une autre.

## Langues

Les entrées de menu et les questions sont fournies en English, 简体中文, 日本語, Deutsch et Français. En ajouter une tient en quelques lignes dans `locales`, au sein de [`manifest.json`](../../manifest.json) — les pull requests sont bienvenues.

## Installation

Téléchargez le ZIP de la version publiée et utilisez **Extensions → Installer depuis un ZIP** dans MarkText Plus, ou trouvez-la via **Découvrir** : ce dépôt porte le sujet GitHub `marktext-plus-plugin`.

Sous licence MIT.
