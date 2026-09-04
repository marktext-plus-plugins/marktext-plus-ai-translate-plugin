# MarkText Plus AI 助手

主应用: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | 简体中文 | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

用你在 MarkText Plus 里配置的大模型来写作、纠错和翻译。需要 MarkText Plus 1.6.1 或更新的版本。

本仓库有意不经 MarkText Plus 验证。安装前请读一遍源码——一共四个短文件。

**仍在 0.x。** 编辑器的插件协议正在稳定但尚未定型，这个插件跟着它走。

## 能做什么

在编辑器里右键。

| 菜单项 | 做什么 |
|---|---|
| **AI 写作** | 说明你要它做什么——也可以直接选一个常见改法——它会改写你选中的内容。没有选中时改写整篇文档；文档也是空的时候，就只按你的要求从头写 |
| **AI 纠错** | 错别字、手误、语法和标点，别的一概不动：文风是作者的。没有什么要问的，改错本身就是全部要求 |
| **翻译选中内容** | 只在有选中时出现 |
| **翻译全文** | 只在没有选中时出现 |

右侧边栏还有一个写作图标——什么都没选、什么都没开的时候，那是入口。

**写作和纠错会先把结果给你看。** 它出现在正文旁边的窗格里，带一个「采用」按钮；采用会走编辑器的历史栈，撤销一下就回来。模型返回的东西，值得在它落进你正在写的文字之前先读一遍。

**翻译不提供「采用」。** 把文档换成它的译文，不是任何人说「翻译」的意思，所以译文只供阅读和复制。整篇文档是分批翻译、边译边显示的——你能先看到开头，末尾还在路上；某一批失败只损失那一批，不是整个文件。它按你正在阅读的方式绘制：源码视图旁边就是源码，预览旁边就是渲染后的样子。

## 怎么工作的

四个文件：[`plugin.lua`](../../plugin.lua)、SDK 的 API 模块 [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua)、装着提示词以及你对它们的修改的 [`lib/prompts.lua`](../../lib/prompts.lua)，还有把文档切成段落再重新分批的 [`lib/blocks.lua`](../../lib/blocks.lua)。`plugin.lua` 用 `require` 加载它们。无需构建、没有依赖，在 Windows、macOS 和 Linux 上完全一样。它在编辑器内的沙箱里运行，没有文件系统、没有网络、没有 `os` 库——`require` 只能触及这个插件自己的目录。

**提示词就在插件里**，而且正是它们在保住 Markdown 的结构：

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

编辑器持有你的 API key 并发出请求；插件从来看不到它，自己也不碰网络。

## 它申请了什么

| 权限 | 用来做什么 |
|---|---|
| `document.read` | 要处理的文本 |
| `document.write` | 采用一次改写时才用，且只在你按下「采用」时 |
| `ai.chat` | 向你配置的模型提问 |
| `storage.local` | 记住你的提示词和目标语言 |
| `ui.contextMenu` | 四个右键菜单项 |
| `ui.sidebar` | 写作图标 |
| `ui.settings` | 它自己的设置页 |
| `ui.notifications` | 在没有可处理的内容时说一声 |

它没有申请 `network.request`，所以它没法把你的文字送到编辑器没送过的地方。`document.write` 由编辑器在你按下「采用」时检查，不是听插件自己声明。

## 设置

六个字段，在插件自己的设置页上：三个功能各有一个系统提示词和一个用户提示词。模型是什么，和给它的是什么，是两件不同的、你会想分别修改的事——而一个总是把某类文档译坏的模型，靠在提示词里说清楚就能纠正，这件事从插件外面做不到。

| 占位符 | 填入的内容 |
|---|---|
| `{{text}}` | 正在处理的文本 |
| `{{language}}` | 你选的目标语言 |
| `{{instruction}}` | 你让写作做的事 |

忘了写 `{{text}}` 的模板会把文本追加在末尾，因为一条没有可处理内容的提示词比一条不整齐的更糟。每个字段都显示它的默认值，你能看清自己在改什么；清空一个就恢复默认。

用双花括号而不是 `${...}`：后者在 Dart、JavaScript 模板字符串和 shell 里都是插值语法，而 `$` 还是 KaTeX 的定界符，这个编辑器会渲染它。

## 语言

十二种，与编辑器一致：English、简体中文、日本語、한국어、Deutsch、Français、Italiano、Русский、Español、Português、Português (Brasil) 和 العربية。要加一种，只需在 [`manifest.json`](../../manifest.json) 的 `locales` 里加几行——欢迎提 PR。

## 安装

下载发行版的 ZIP，在 MarkText Plus 里用**插件 → 安装 ZIP**；或者通过**发现**找到它：本仓库带着 GitHub topic `marktext-plus-plugin`。

以 MIT 许可证发布。
