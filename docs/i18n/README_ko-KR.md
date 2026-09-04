# MarkText Plus AI 어시스턴트

메인 애플리케이션: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | 한국어 | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | [Español](README_es-ES.md) | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

MarkText Plus에서 설정한 모델로 글을 쓰고, 교정하고, 번역합니다. MarkText Plus 1.6.1 이상이 필요합니다.

이 저장소는 의도적으로 MarkText Plus의 검증을 받지 않았습니다. 설치하기 전에 소스를 읽어 보세요 — 짧은 파일 넷뿐입니다.

**아직 0.x입니다.** 에디터의 플러그인 프로토콜은 자리를 잡아 가고 있지만 아직 굳지 않았고, 이 플러그인은 그것을 따릅니다.

## 무엇을 하는가

에디터에서 오른쪽 클릭하세요.

| 항목 | 하는 일 |
|---|---|
| **AI 글쓰기** | 무엇을 해야 하는지 말하면 — 흔한 답 중에 골라도 됩니다 — 고른 부분을 고쳐 씁니다. 고른 것이 없으면 문서를 고쳐 쓰고, 문서도 비어 있으면 당신의 요구만으로 처음부터 씁니다 |
| **AI 교정** | 맞춤법, 오타, 문법, 문장 부호만 고칩니다. 그 밖에는 손대지 않습니다 — 문체는 글쓴이의 것입니다. 물을 것도 없습니다. 잘못을 고치는 것이 전부이기 때문입니다 |
| **선택 영역 번역** | 무언가를 골랐을 때만 나옵니다 |
| **문서 번역** | 아무것도 고르지 않았을 때만 나옵니다 |

오른쪽 사이드바에는 글쓰기 아이콘도 있습니다. 고른 것도 없고 열어 둔 것도 없을 때의 입구입니다.

**글쓰기와 교정은 결과를 먼저 보여 줍니다.** 본문 옆 창에 「적용」 단추와 함께 나타나고, 적용은 에디터의 기록을 거치므로 되돌리기 한 번이면 돌아옵니다. 모델이 돌려준 것은 당신이 쓰던 글에 들어가기 전에 읽어 볼 값어치가 있습니다.

**번역에는 적용이 없습니다.** 문서를 그 번역으로 바꾸는 것은 누구도 「번역」이라는 말로 뜻하지 않습니다. 그래서 읽고 복사하라고 보여 줄 뿐입니다. 문서 전체는 묶음으로 번역되어 도착하는 대로 나타납니다 — 끝이 아직 오는 중에 앞부분을 읽을 수 있고, 실패해도 한 묶음이지 파일 전체가 아닙니다. 읽는 방식대로 그려집니다: 소스 옆이면 소스로, 미리보기 옆이면 렌더링해서.

## 어떻게 도는가

파일 넷: [`plugin.lua`](../../plugin.lua), SDK의 API 모듈 [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), 프롬프트와 당신이 고친 것을 담은 [`lib/prompts.lua`](../../lib/prompts.lua), 그리고 문서를 문단으로 나누고 다시 묶는 [`lib/blocks.lua`](../../lib/blocks.lua). `plugin.lua`가 `require`로 불러옵니다. 빌드도 의존성도 없고, Windows와 macOS와 Linux에서 똑같습니다. 에디터 안 샌드박스에서 돌며 파일 시스템도 네트워크도 `os` 라이브러리도 없습니다 — `require`는 이 플러그인 자신의 디렉터리 안에만 닿습니다.

**프롬프트는 이 플러그인 안에 있고**, Markdown을 그대로 지켜 주는 것이 실은 그것입니다:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

API 키는 에디터가 쥐고 요청도 에디터가 보냅니다. 플러그인은 그것을 보지 못하고, 스스로 네트워크에 닿지도 않습니다.

## 무엇을 요구하는가

| 권한 | 왜 |
|---|---|
| `document.read` | 다룰 글 |
| `document.write` | 고쳐 쓴 것을 적용하기 위해. 「적용」을 누를 때만입니다 |
| `ai.chat` | 설정한 모델에 묻기 위해 |
| `storage.local` | 프롬프트와 대상 언어를 기억하기 위해 |
| `ui.contextMenu` | 네 개의 오른쪽 클릭 항목 |
| `ui.sidebar` | 글쓰기 아이콘 |
| `ui.settings` | 자기 설정 페이지 |
| `ui.notifications` | 다룰 것이 없다고 알리기 위해 |

`network.request`는 요구하지 않으므로, 에디터가 보내지 않은 곳으로 당신의 글을 보낼 수 없습니다. `document.write`는 「적용」을 누를 때 에디터가 확인합니다. 플러그인의 말을 믿어서가 아닙니다.

## 설정

자기 설정 페이지에 여섯 개. 세 명령마다 시스템 프롬프트와 사용자 프롬프트가 하나씩 있습니다. 모델이 무엇인가와, 모델에 무엇을 주는가는 따로 바꾸고 싶어지는 서로 다른 일입니다 — 어떤 종류의 문서를 자꾸 잘못 옮기는 모델은 프롬프트에 그렇게 적으면 고쳐지고, 그것은 플러그인 바깥에서는 할 수 없습니다.

| 자리표시자 | 채워지는 것 |
|---|---|
| `{{text}}` | 다루고 있는 글 |
| `{{language}}` | 고른 대상 언어 |
| `{{instruction}}` | 글쓰기에 시킨 것 |

`{{text}}`를 잊은 틀에는 글이 뒤에 붙습니다. 다룰 것이 아무것도 없는 프롬프트는 정돈되지 않은 것보다 나쁘기 때문입니다. 각 칸은 기본값을 보여 주므로 무엇을 바꾸는지 보입니다. 비우면 기본값이 돌아옵니다.

`${...}`가 아니라 이중 중괄호입니다: 앞의 것은 Dart에서도 JavaScript 템플릿 문자열에서도 셸에서도 보간 문법이고, `$`는 이 에디터가 그리는 KaTeX의 구분 기호이기도 합니다.

## 언어

에디터와 같은 열둘: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil), العربية. 하나 더하려면 [`manifest.json`](../../manifest.json)의 `locales`에 몇 줄이면 됩니다 — 풀 리퀘스트를 환영합니다.

## 설치

릴리스 ZIP을 내려받아 MarkText Plus에서 **플러그인 → ZIP에서 설치**를 쓰거나, **찾기**로 찾으세요: 이 저장소에는 GitHub topic `marktext-plus-plugin`이 붙어 있습니다.

MIT 라이선스입니다.
