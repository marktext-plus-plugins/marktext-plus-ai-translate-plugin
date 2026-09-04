# Assistant IA MarkText Plus

Application principale: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | Français | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Écrire, relire et traduire avec le modèle que vous avez configuré dans MarkText Plus. Nécessite MarkText Plus 1.6.1 ou plus récent.

Ce dépôt n’est délibérément pas vérifié par MarkText Plus. Lisez la source avant de l’installer — ce sont quatre fichiers courts.

**Toujours en 0.x.** Le protocole d’extension de l’éditeur se stabilise sans être stabilisé, et cette extension le suit.

## Ce qu’elle fait

Clic droit dans l’éditeur.

| Entrée | Ce qu’elle fait |
|---|---|
| **Écriture IA** | Dites ce qu’il faut faire — ou prenez l’une des réponses habituelles — et elle réécrit ce que vous avez sélectionné. Sans sélection, le document ; sur un document vide, elle écrit à partir de votre seule consigne |
| **Relecture IA** | Orthographe, fautes de frappe, grammaire et ponctuation, rien d’autre : la voix appartient à l’auteur. Rien à répondre, puisque corriger est tout le propos |
| **Traduire la sélection** | Proposée seulement quand quelque chose est sélectionné |
| **Traduire le document** | Proposée seulement quand rien ne l’est |

La barre latérale droite porte aussi une icône d’écriture — l’entrée quand rien n’est sélectionné et rien n’est ouvert.

**L’écriture et la relecture montrent le résultat avant qu’il n’aille où que ce soit.** Il paraît dans un volet à côté de votre texte, avec un bouton Appliquer ; appliquer passe par l’historique de l’éditeur, une annulation le reprend. Ce qu’un modèle renvoie mérite d’être lu avant d’atterrir dans ce que vous étiez en train d’écrire.

**La traduction ne propose rien à appliquer.** Remplacer un document par sa traduction n’est ce que personne entend par « traduire » ; elle est montrée pour être lue et copiée. Un document entier est traduit par lots et paraît à mesure — vous voyez le début pendant que la fin arrive encore, et un échec coûte un lot plutôt que le fichier. Il est dessiné comme vous lisez : en source à côté de la vue source, rendu à côté de l’aperçu.

## Comment elle marche

Quatre fichiers : [`plugin.lua`](../../plugin.lua), le module d’API du SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua), qui porte les invites et vos modifications, et [`lib/blocks.lua`](../../lib/blocks.lua), qui découpe un document en paragraphes et les regroupe en requêtes. `plugin.lua` les charge avec `require`. Aucune compilation, aucune dépendance, identique sur Windows, macOS et Linux. Elle tourne en bac à sable dans l’éditeur, sans système de fichiers, sans réseau et sans bibliothèque `os` — `require` n’atteint que le répertoire de l’extension elle-même.

**Les invites sont ici, dans l’extension**, et ce sont elles qui gardent le Markdown intact :

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

L’éditeur détient votre clé d’API et fait la requête ; l’extension ne la voit jamais et ne touche pas au réseau elle-même.

## Ce qu’elle demande

| Droit | Pourquoi |
|---|---|
| `document.read` | le texte à traiter |
| `document.write` | pour appliquer une réécriture, et seulement quand vous appuyez sur Appliquer |
| `ai.chat` | pour interroger le modèle que vous avez configuré |
| `storage.local` | pour retenir vos invites et votre langue cible |
| `ui.contextMenu` | les quatre entrées du clic droit |
| `ui.sidebar` | l’icône d’écriture |
| `ui.settings` | sa page de réglages |
| `ui.notifications` | pour dire qu’il n’y a rien à traiter |

Elle ne demande pas `network.request` : elle ne peut donc envoyer votre texte nulle part où l’éditeur ne l’a pas envoyé. `document.write` est vérifié par l’éditeur au moment où vous appuyez sur Appliquer, non sur parole d’extension.

## Réglages

Six champs, sur sa propre page : une invite système et une invite utilisateur pour chacune des trois commandes. Ce qu’est le modèle et ce qu’on lui donne sont deux choses différentes à vouloir changer — et un modèle qui traduit toujours mal un certain genre de document se corrige en le disant dans l’invite, ce que personne ne peut faire depuis l’extérieur de l’extension.

| Marqueur | Rempli avec |
|---|---|
| `{{text}}` | le texte traité |
| `{{language}}` | la langue cible choisie |
| `{{instruction}}` | ce que vous avez demandé à l’écriture |

Un modèle qui oublie `{{text}}` se voit ajouter le texte à la fin, car une invite sans rien à traiter vaut moins qu’une invite mal rangée. Chaque champ montre sa valeur par défaut, pour que vous voyiez ce que vous changez ; le vider la remet.

Doubles accolades plutôt que `${...}` : cette forme est de l’interpolation en Dart, dans les gabarits JavaScript et dans le shell, et `$` est aussi le délimiteur de KaTeX, que cet éditeur rend.

## Langues

Douze, comme l’éditeur : English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) et العربية. En ajouter une tient en quelques lignes sous `locales` dans [`manifest.json`](../../manifest.json) — les pull requests sont bienvenues.

## Installation

Téléchargez le ZIP de la publication et utilisez **Extensions → Installer depuis un ZIP** dans MarkText Plus, ou trouvez-la par **Découvrir** : ce dépôt porte le topic GitHub `marktext-plus-plugin`.

Sous licence MIT.
