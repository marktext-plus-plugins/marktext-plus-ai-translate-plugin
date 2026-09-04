# Assistente de IA para MarkText Plus

Aplicação principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | Português | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Escrever, rever e traduzir com o modelo que configurou no MarkText Plus. Requer o MarkText Plus 1.6.1 ou posterior.

Este repositório não é verificado pelo MarkText Plus, de propósito. Leia o código antes de o instalar — são quatro ficheiros curtos.

**Ainda em 0.x.** O protocolo de extensões do editor está a assentar mas não assentou, e esta extensão segue-o.

## O que faz

Clique com o botão direito no editor.

| Entrada | O que faz |
|---|---|
| **Escrita com IA** | Diga o que deve fazer — ou tome uma das respostas habituais — e reescreve o que selecionou. Sem seleção reescreve o documento; com o documento vazio escreve apenas a partir da sua indicação |
| **Revisão com IA** | Ortografia, gralhas, gramática e pontuação, e nada mais: a voz é de quem escreve. Nada a responder, porque corrigir erros é toda a tarefa |
| **Traduzir a seleção** | Só aparece quando algo está selecionado |
| **Traduzir o documento** | Só aparece quando nada está |

Na barra lateral direita há também um ícone de escrita — a porta de entrada quando não há nada selecionado nem nada aberto.

**A escrita e a revisão mostram o resultado antes de ele ir seja para onde for.** Aparece num quadro ao lado do seu texto com um botão Aplicar; aplicar passa pelo histórico do editor, e um desfazer traz tudo de volta. O que um modelo devolve merece ser lido antes de aterrar naquilo que estava a escrever.

**A tradução não oferece nada para aplicar.** Substituir um documento pela sua tradução não é o que alguém quer dizer com «traduzir»; é mostrada para ser lida e copiada. Um documento inteiro é traduzido por lotes e vai aparecendo — vê o princípio enquanto o fim ainda vem a caminho, e uma falha custa um lote em vez do ficheiro. É desenhada como está a ler: como código-fonte ao lado da vista de código, composta ao lado da pré-visualização.

## Como funciona

Quatro ficheiros: [`plugin.lua`](../../plugin.lua), o módulo de API do SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua), que guarda as instruções e as suas alterações, e [`lib/blocks.lua`](../../lib/blocks.lua), que parte o documento em parágrafos e os reagrupa em pedidos. O `plugin.lua` carrega-os com `require`. Sem compilação, sem dependências, igual no Windows, macOS e Linux. Corre numa caixa de areia dentro do editor, sem sistema de ficheiros, sem rede e sem a biblioteca `os` — o `require` só chega dentro do diretório da própria extensão.

**As instruções estão aqui, na extensão**, e são elas que mantêm o Markdown intacto:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

O editor guarda a sua chave de API e faz o pedido; a extensão nunca a vê, e não toca na rede por si.

## O que pede

| Permissão | Para quê |
|---|---|
| `document.read` | o texto sobre o qual trabalhar |
| `document.write` | para aplicar uma reescrita, e só quando carrega em Aplicar |
| `ai.chat` | para perguntar ao modelo que configurou |
| `storage.local` | para se lembrar das suas instruções e do idioma de destino |
| `ui.contextMenu` | as quatro entradas do botão direito |
| `ui.sidebar` | o ícone de escrita |
| `ui.settings` | a sua página de definições |
| `ui.notifications` | para dizer quando não há nada sobre que trabalhar |

Não pede `network.request`, por isso não consegue enviar o seu texto para lado nenhum onde o editor não o tenha enviado. O `document.write` é verificado pelo editor quando carrega em Aplicar, e não por palavra da extensão.

## Definições

Seis campos, na sua própria página: uma instrução de sistema e uma de utilizador para cada um dos três comandos. O que o modelo é e o que lhe é dado são duas coisas diferentes que se quer mudar em separado — e um modelo que traduz sempre mal certo tipo de documento arranja-se dizendo-lho na instrução, coisa que de fora da extensão ninguém consegue fazer.

| Marcador | Preenchido com |
|---|---|
| `{{text}}` | o texto em que se trabalha |
| `{{language}}` | o idioma de destino escolhido |
| `{{instruction}}` | o que pediu à escrita |

A um modelo que se esqueça de `{{text}}` acrescenta-se o texto no fim, porque uma instrução sem nada sobre que trabalhar é pior do que uma desarrumada. Cada campo mostra o seu valor predefinido, para que veja o que está a mudar; esvaziá-lo repõe-no.

Chavetas duplas em vez de `${...}`: essa forma é interpolação em Dart, nos literais de modelo do JavaScript e na linha de comandos, e `$` é ainda o delimitador do KaTeX, que este editor compõe.

## Idiomas

Doze, como o editor: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) e العربية. Acrescentar outro são umas linhas em `locales` no [`manifest.json`](../../manifest.json) — pull requests são bem-vindos.

## Instalação

Descarregue o ZIP da versão e use **Extensões → Instalar a partir de ZIP** no MarkText Plus, ou encontre-a em **Descobrir**: este repositório tem o topic do GitHub `marktext-plus-plugin`.

Licenciado sob MIT.
