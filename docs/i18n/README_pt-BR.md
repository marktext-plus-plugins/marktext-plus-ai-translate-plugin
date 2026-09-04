# Assistente de IA para MarkText Plus

Aplicativo principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | Português (Brasil)

Escrever, revisar e traduzir com o modelo que você configurou no MarkText Plus. Requer o MarkText Plus 1.6.1 ou posterior.

Este repositório não é verificado pelo MarkText Plus, de propósito. Leia o código antes de instalá-lo — são quatro arquivos curtos.

**Ainda em 0.x.** O protocolo de extensões do editor está a assentar mas não assentou, e esta extensão segue-o.

## O que faz

Clique com o botão direito no editor.

| Entrada | O que faz |
|---|---|
| **Escrita com IA** | Diga o que ele deve fazer — ou pegue uma das respostas de sempre — e ele reescreve o que você selecionou. Sem seleção reescreve o documento; com o documento vazio escreve só a partir da sua indicação |
| **Revisão com IA** | Ortografia, erros de digitação, gramática e pontuação, e nada mais: a voz é de quem escreve. Nada a responder, porque corrigir erros é a tarefa inteira |
| **Traduzir a seleção** | Só aparece quando há algo selecionado |
| **Traduzir o documento** | Só aparece quando não há |

Na barra lateral direita há também um ícone de escrita — a porta de entrada quando não há nada selecionado nem nada aberto.

**A escrita e a revisão mostram o resultado antes de ele ir para qualquer lugar.** Aparece em um quadro ao lado do seu texto com um botão Aplicar; aplicar passa pelo histórico do editor, e um desfazer traz tudo de volta. O que um modelo devolve merece ser lido antes de cair naquilo que você estava escrevendo.

**A tradução não oferece nada para aplicar.** Trocar um documento pela sua tradução não é o que ninguém quer dizer com «traduzir»; ela é mostrada para ser lida e copiada. Um documento inteiro é traduzido em lotes e vai aparecendo — você vê o começo enquanto o fim ainda está a caminho, e uma falha custa um lote em vez do arquivo. É desenhada do jeito que você está lendo: como código-fonte ao lado da visão de código, composta ao lado da pré-visualização.

## Como funciona

Quatro arquivos: [`plugin.lua`](../../plugin.lua), o módulo de API do SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua), que guarda as instruções e as suas mudanças, e [`lib/blocks.lua`](../../lib/blocks.lua), que parte o documento em parágrafos e os reagrupa em requisições. O `plugin.lua` carrega-os com `require`. Sem build, sem dependências, igual no Windows, macOS e Linux. Roda em uma caixa de areia dentro do editor, sem sistema de arquivos, sem rede e sem a biblioteca `os` — o `require` só chega dentro do diretório da própria extensão.

**As instruções estão aqui, na extensão**, e são elas que mantêm o Markdown intacto:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

O editor guarda a sua chave de API e faz a requisição; a extensão nunca a vê, e não toca na rede por conta própria.

## O que pede

| Permissão | Para quê |
|---|---|
| `document.read` | o texto sobre o qual trabalhar |
| `document.write` | para aplicar uma reescrita, e só quando você aperta Aplicar |
| `ai.chat` | para perguntar ao modelo que você configurou |
| `storage.local` | para lembrar as suas instruções e o idioma de destino |
| `ui.contextMenu` | as quatro entradas do botão direito |
| `ui.sidebar` | o ícone de escrita |
| `ui.settings` | a sua página de configurações |
| `ui.notifications` | para dizer quando não há nada sobre o que trabalhar |

Não pede `network.request`, então não consegue mandar o seu texto para lugar nenhum aonde o editor não o tenha mandado. O `document.write` é verificado pelo editor quando você aperta Aplicar, e não pela palavra da extensão.

## Definições

Seis campos, na sua própria página: uma instrução de sistema e uma de usuário para cada um dos três comandos. O que o modelo é e o que é dado a ele são duas coisas diferentes que se quer mudar em separado — e um modelo que traduz sempre mal certo tipo de documento se conserta dizendo isso na instrução, coisa que de fora da extensão ninguém consegue fazer.

| Marcador | Preenchido com |
|---|---|
| `{{text}}` | o texto em que se trabalha |
| `{{language}}` | o idioma de destino escolhido |
| `{{instruction}}` | o que você pediu à escrita |

A um modelo que esqueça `{{text}}` acrescenta-se o texto no fim, porque uma instrução sem nada sobre o que trabalhar é pior do que uma desarrumada. Cada campo mostra o seu valor padrão, para que você veja o que está mudando; esvaziá-lo o restaura.

Chavetas duplas em vez de `${...}`: essa forma é interpolação em Dart, nos literais de modelo do JavaScript e na linha de comandos, e `$` é ainda o delimitador do KaTeX, que este editor compõe.

## Idiomas

Doze, como o editor: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) e العربية. Acrescentar outro são umas linhas em `locales` no [`manifest.json`](../../manifest.json) — pull requests são bem-vindos.

## Instalação

Baixe o ZIP da versão e use **Extensões → Instalar a partir de ZIP** no MarkText Plus, ou encontre-a em **Descobrir**: este repositório tem o topic do GitHub `marktext-plus-plugin`.

Licenciado sob MIT.
