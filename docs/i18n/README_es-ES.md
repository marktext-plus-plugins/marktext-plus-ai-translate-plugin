# Complemento de traducción con IA para MarkText Plus

Aplicación principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | Español | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Traduce la selección, o el documento entero, mediante el modelo que haya configurado en MarkText Plus. Requiere MarkText Plus 1.6.1 o posterior.

Este repositorio no está verificado por MarkText Plus, deliberadamente. Lea el código antes de instalarlo: son dos archivos cortos.

## Qué hace

Haga clic derecho en el editor. Con texto seleccionado se le ofrece **Traducir la selección**; sin nada seleccionado, **Traducir el documento**. Cada entrada aparece solo cuando corresponde, de modo que nunca se le ofrece la que no pretendía.

El idioma de destino se pregunta una vez —los habituales están ahí para pulsarlos, y lo que escriba en su lugar se toma tal cual— y la respuesta se recuerda para la próxima vez.

Una selección traducida vuelve en una ventana pequeña con un botón para copiar. Un documento traducido se abre en un panel junto a su texto, donde puede leerlo frente al original. **En su documento no se escribe nada**: una traducción que aún no ha leído no es una modificación que haya pedido.

## Cómo funciona

Dos archivos: [`plugin.lua`](../../plugin.lua) y [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), el módulo de API del SDK que `plugin.lua` carga con `require`, sin compilación, sin dependencias, igual en Windows, macOS y Linux. Se ejecuta dentro del editor, en un entorno aislado sin sistema de archivos, sin red y sin la biblioteca `os`.

**La instrucción para el modelo vive aquí, en el complemento**, y es lo que de verdad mantiene intacto el Markdown:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

La clave de API la guarda el editor, y es el editor quien hace la petición; el complemento nunca la ve y no escribe nada en la red por su cuenta. Al modelo se le plantea exactamente el texto anterior seguido de su documento.

## Qué pide

| Permiso | Para qué |
|---|---|
| `document.read` | leer el texto que se va a traducir |
| `ai.chat` | consultar el modelo configurado |
| `storage.local` | recordar su idioma de destino |
| `ui.contextMenu` | las dos entradas del clic derecho |
| `ui.settings` | su propia página de ajustes |
| `ui.notifications` | avisar cuando no hay nada seleccionado |

No pide `document.write`, así que no puede modificar su documento ni aunque lo intentara, y no pide `network.request`, así que no puede enviar su texto a ningún sitio al que el editor no lo haya enviado.

## Ajustes

Un solo campo, en su propia página de ajustes: el idioma de destino predeterminado, que rellena por usted y actualiza cada vez que elige otro.

## Idiomas

Las entradas de menú y las preguntas se incluyen en English, 简体中文, 日本語, Deutsch y Français. Añadir otro son unas pocas líneas en `locales`, dentro de [`manifest.json`](../../manifest.json); las pull requests son bienvenidas.

## Instalación

Descargue el ZIP de la versión publicada y use **Complementos → Instalar desde ZIP** en MarkText Plus, o encuéntrelo mediante **Descubrir**: este repositorio lleva el tema de GitHub `marktext-plus-plugin`.

Con licencia MIT.
