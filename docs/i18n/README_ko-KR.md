# MarkText Plus AI 번역 플러그인

메인 애플리케이션: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | 한국어 | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

MarkText Plus에서 설정한 모델로 선택 영역이나 문서 전체를 번역합니다. MarkText Plus 1.6.1 이상이 필요합니다.

이 저장소는 의도적으로 MarkText Plus의 검증을 받지 않았습니다. 설치하기 전에 소스를 읽어 보세요 — 파일은 하나뿐입니다.

## 무엇을 하나요

에디터에서 마우스 오른쪽 버튼을 누르세요. 텍스트를 선택했다면 **선택 영역 번역**이, 아무것도 선택하지 않았다면 **문서 번역**이 나타납니다. 각 항목은 해당하는 상황에서만 나타나므로, 원하지 않던 쪽이 제시되는 일은 없습니다.

목표 언어는 한 번만 묻습니다 — 자주 쓰는 언어는 눌러서 고르고, 대신 입력한 것은 그대로 사용됩니다 — 그리고 답은 다음을 위해 기억됩니다.

선택 영역의 번역은 복사 버튼이 있는 작은 창에 나옵니다. 문서 전체의 번역은 본문 옆 패널에 열려 원문과 비교하며 읽을 수 있습니다. **문서에는 아무것도 쓰지 않습니다**: 아직 읽지 않은 번역은 당신이 요청한 편집이 아닙니다.

## 어떻게 동작하나요

플러그인 전체가 [`plugin.lua`](../../plugin.lua) 한 파일입니다 — 빌드 없음, 의존성 없음, Windows·macOS·Linux에서 동일합니다. 에디터 내부의 샌드박스에서 실행되며 파일 시스템도, 네트워크도, `os` 라이브러리도 없습니다.

**프롬프트는 이 플러그인 안에 있습니다.** Markdown이 망가지지 않게 지켜 주는 것이 바로 그것입니다:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

API 키는 에디터가 보관하고 요청도 에디터가 보냅니다. 플러그인은 그것을 결코 볼 수 없고, 스스로 네트워크에 무언가를 쓰지도 않습니다. 모델에게 전달되는 것은 위 문장 뒤에 당신의 문서를 붙인 것뿐입니다.

## 요구하는 권한

| 권한 | 이유 |
|---|---|
| `document.read` | 번역할 텍스트를 읽기 위해 |
| `ai.chat` | 설정한 모델에 요청하기 위해 |
| `storage.local` | 목표 언어를 기억하기 위해 |
| `ui.contextMenu` | 오른쪽 클릭 메뉴 두 항목을 위해 |
| `ui.settings` | 자체 설정 페이지를 위해 |
| `ui.notifications` | 선택된 내용이 없다고 알리기 위해 |

`document.write`는 요구하지 않으므로 시도하더라도 문서를 바꿀 수 없고, `network.request`도 요구하지 않으므로 에디터가 보낸 곳 외에 당신의 텍스트를 보낼 수 없습니다.

## 설정

자체 설정 페이지에는 항목이 하나, 기본 목표 언어입니다. 자동으로 채워지며 다른 언어를 고를 때마다 갱신됩니다.

## 언어

메뉴 항목과 질문은 English, 简体中文, 日本語, Deutsch, Français로 제공됩니다. 언어를 추가하려면 [`manifest.json`](../../manifest.json)의 `locales`에 몇 줄만 더하면 됩니다 — 풀 리퀘스트를 환영합니다.

## 설치

릴리스 ZIP을 내려받아 MarkText Plus에서 **플러그인 → ZIP에서 설치**를 사용하세요. 또는 **탐색**으로 찾을 수 있습니다: 이 저장소에는 GitHub 토픽 `marktext-plus-plugin`이 달려 있습니다.

MIT 라이선스.
