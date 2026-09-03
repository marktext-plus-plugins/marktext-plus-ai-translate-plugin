# Extensão de tradução por IA para o MarkText Plus

Aplicação principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | Português (Brasil)

Traduz a seleção, ou o documento inteiro, através do modelo que você configurou no MarkText Plus. Requer o MarkText Plus 1.6.1 ou mais recente.

Este repositório não é verificado pelo MarkText Plus, deliberadamente. Leia o código antes de instalá-lo — é um único arquivo.

## O que faz

Clique com o botão direito no editor. Com texto selecionado, aparece **Traduzir a seleção**; sem nada selecionado, **Traduzir o documento**. Cada entrada aparece somente quando se aplica, de modo que você nunca recebe aquela que não pretendia.

O idioma de destino é perguntado uma vez — os mais comuns estão ali para clicar, e o que você digitar no lugar é usado tal como está — e a resposta fica guardada para a próxima vez.

Uma seleção traduzida volta em uma janela pequena com um botão de copiar. Um documento traduzido abre em um painel ao lado do seu texto, onde você pode lê-lo comparando com o original. **Nada é escrito no seu documento**: uma tradução que você ainda não leu não é uma alteração que você pediu.

## Como funciona

A extensão inteira é o [`plugin.lua`](../../plugin.lua) — um arquivo, sem compilação, sem dependências, igual no Windows, no macOS e no Linux. Roda dentro do editor, em uma sandbox sem sistema de arquivos, sem rede e sem a biblioteca `os`.

**A instrução para o modelo vive aqui, na extensão**, e é ela que mantém o Markdown realmente intacto:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

A chave da API fica com o editor, e é o editor que faz a requisição; a extensão nunca a vê e não escreve nada na rede por conta própria. Ao modelo é apresentado exatamente o texto acima seguido do seu documento.

## O que ela pede

| Permissão | Para quê |
|---|---|
| `document.read` | ler o texto a traduzir |
| `ai.chat` | consultar o modelo configurado |
| `storage.local` | lembrar o seu idioma de destino |
| `ui.contextMenu` | as duas entradas do botão direito |
| `ui.settings` | a própria página de configurações |
| `ui.notifications` | avisar quando não há nada selecionado |

Ela não pede `document.write`, portanto não consegue alterar o seu documento nem se tentasse, e não pede `network.request`, portanto não consegue mandar o seu texto para lugar nenhum aonde o editor não o tenha mandado.

## Configurações

Um único campo, na própria página de configurações: o idioma de destino padrão, que ela preenche para você e atualiza sempre que você escolhe outro.

## Idiomas

As entradas de menu e as perguntas vêm em English, 简体中文, 日本語, Deutsch e Français. Acrescentar outro são poucas linhas em `locales`, dentro do [`manifest.json`](../../manifest.json) — pull requests são bem-vindos.

## Instalação

Baixe o ZIP da versão publicada e use **Extensões → Instalar a partir de ZIP** no MarkText Plus, ou encontre-a através de **Descobrir**: este repositório tem o tópico do GitHub `marktext-plus-plugin`.

Licenciado sob MIT.
