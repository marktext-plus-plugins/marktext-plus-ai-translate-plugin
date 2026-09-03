# MarkText Plus AI 翻译插件

主应用：[MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | 简体中文 | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

通过你在 MarkText Plus 里配置的模型，翻译选中内容或整篇文档。需要 MarkText Plus 1.6.1 或更高版本。

本仓库有意不做官方验证。安装前请先读一遍源码——两个短文件而已。

## 能做什么

在编辑器里右键。选中了文本，出现的是**翻译选中内容**；没有选中，出现的是**翻译全文**。每一项只在它适用时出现，所以你不会被递上一个本来就不想要的选项。

它会问一次目标语言——常用的直接点，想打别的照样算数——然后记住你的答案。

选区的译文出现在一个带复制按钮的小窗口里。全文的译文在正文旁边开一栏，你可以对照着原文读。**什么都不会写进你的文档**：你还没读过的译文，不算你要的修改。

## 怎么做到的

两个文件：[`plugin.lua`](../../plugin.lua) 和 [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua)——后者是 SDK 的 API 模块，由 `plugin.lua` 用 `require` 加载。不用编译，没有依赖，Windows、macOS、Linux 上都一样。它在编辑器内部的沙箱里运行，没有文件系统、没有网络、没有 `os` 库——`require` 也只能在本插件自己的目录里解析。

**提示词就在插件里**，保住 Markdown 不散架的正是它：

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

API key 由编辑器保管、请求也由编辑器发出；插件从头到尾看不到它，自己也不往网络上写任何东西。发给模型的内容，就是上面这段文字加上你的文档。

## 它申请了什么权限

| 权限 | 用途 |
|---|---|
| `document.read` | 读要翻译的文本 |
| `ai.chat` | 调用你配置的模型 |
| `storage.local` | 记住你的目标语言 |
| `ui.contextMenu` | 那两个右键菜单项 |
| `ui.settings` | 它自己的设置页 |
| `ui.notifications` | 在没选中内容时提示你 |

它**没有**申请 `document.write`，所以即使想改也改不了你的文档；也**没有**申请 `network.request`，所以它无法把你的文字发到编辑器之外的任何地方。

## 设置

它自己的设置页上只有一项：默认目标语言。它会替你填好，并在你每次换语言时更新。

## 语言

菜单项和提问文案自带 English、简体中文、日本語、Deutsch、Français。加一种语言只需要在 [`manifest.json`](../../manifest.json) 的 `locales` 里加几行——欢迎提 PR。

## 安装

下载 release 里的 ZIP，在 MarkText Plus 中用**插件 → 安装 ZIP**；或者通过**发现**找到它：本仓库带有 GitHub topic `marktext-plus-plugin`。

MIT 协议。
