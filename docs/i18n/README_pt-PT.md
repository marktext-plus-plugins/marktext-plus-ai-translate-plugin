# Extensão de tradução por IA para o MarkText Plus

Aplicação principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | Português | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Traduz a selecção, ou o documento inteiro, através do modelo que configurou no MarkText Plus. Requer o MarkText Plus 1.6.1 ou mais recente.

Este repositório não é verificado pelo MarkText Plus, deliberadamente. Leia o código antes de o instalar — são dois ficheiros curtos.

## O que faz

Clique com o botão direito no editor. Com texto seleccionado é-lhe oferecido **Traduzir a selecção**; sem nada seleccionado, **Traduzir o documento**. Cada entrada aparece apenas quando se aplica, de modo que nunca lhe é oferecida aquela que não pretendia.

O idioma de destino é perguntado uma vez — os habituais estão ali para premir, e o que escrever em vez disso é usado tal como está — e a resposta fica guardada para a próxima.

Uma selecção traduzida volta numa janela pequena com um botão para copiar. Um documento traduzido abre num painel ao lado do seu texto, onde o pode ler contra o original. **Nada é escrito no seu documento**: uma tradução que ainda não leu não é uma alteração que tenha pedido.

## Como funciona

Dois ficheiros: [`plugin.lua`](../../plugin.lua) e [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), o módulo de API do SDK que o `plugin.lua` carrega com `require`, sem compilação, sem dependências, igual no Windows, no macOS e no Linux. Corre dentro do editor, numa caixa de areia sem sistema de ficheiros, sem rede e sem a biblioteca `os`.

**A instrução para o modelo vive aqui, na extensão**, e é ela que mantém o Markdown realmente intacto:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

A chave da API é guardada pelo editor, e é o editor que faz o pedido; a extensão nunca a vê e não escreve nada na rede por si própria. Ao modelo é apresentado exactamente o texto acima seguido do seu documento.

## O que pede

| Permissão | Para quê |
|---|---|
| `document.read` | ler o texto a traduzir |
| `ai.chat` | consultar o modelo configurado |
| `storage.local` | recordar o seu idioma de destino |
| `ui.contextMenu` | as duas entradas do botão direito |
| `ui.settings` | a sua própria página de definições |
| `ui.notifications` | avisar quando não há nada seleccionado |

Não pede `document.write`, pelo que não consegue alterar o seu documento nem que tentasse, e não pede `network.request`, pelo que não consegue enviar o seu texto para lado nenhum onde o editor não o tenha enviado.

## Definições

Um único campo, na sua página de definições: o idioma de destino predefinido, que preenche por si e actualiza sempre que escolhe outro.

## Idiomas

As entradas de menu e as perguntas vêm em English, 简体中文, 日本語, Deutsch e Français. Acrescentar outro são poucas linhas em `locales`, dentro do [`manifest.json`](../../manifest.json) — pull requests são bem-vindos.

## Instalação

Descarregue o ZIP da versão publicada e use **Extensões → Instalar a partir de ZIP** no MarkText Plus, ou encontre-a através de **Descobrir**: este repositório tem o tópico do GitHub `marktext-plus-plugin`.

Licenciado sob MIT.
