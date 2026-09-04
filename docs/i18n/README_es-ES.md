# Asistente de IA para MarkText Plus

Aplicación principal: [MarkText Plus](https://github.com/SugarFatFree/marktext-plus)

[English](../../README.md) | [简体中文](README_zh-CN.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md) | [Deutsch](README_de-DE.md) | [Français](README_fr-FR.md) | [Italiano](README_it-IT.md) | [Русский](README_ru-RU.md) | Español | [Português](README_pt-PT.md) | [العربية](README_ar-SA.md) | [Português (Brasil)](README_pt-BR.md)

Escribir, corregir y traducir con el modelo que hayas configurado en MarkText Plus. Requiere MarkText Plus 1.6.1 o posterior.

Este repositorio no está verificado por MarkText Plus, a propósito. Lee el código antes de instalarlo: son cuatro archivos cortos.

**Sigue en 0.x.** El protocolo de complementos del editor se está asentando pero no está asentado, y este complemento lo sigue.

## Qué hace

Clic derecho en el editor.

| Entrada | Qué hace |
|---|---|
| **Escritura con IA** | Di qué debe hacer —o toma una de las respuestas habituales— y reescribe lo que hayas seleccionado. Sin selección reescribe el documento; con el documento vacío escribe sólo a partir de tu indicación |
| **Corrección con IA** | Ortografía, erratas, gramática y puntuación, y nada más: la voz es de quien escribe. No hay nada que responder, porque corregir errores es todo el encargo |
| **Traducir la selección** | Sólo aparece cuando hay algo seleccionado |
| **Traducir el documento** | Sólo aparece cuando no lo hay |

En la barra lateral derecha hay además un icono de escritura: la puerta de entrada cuando no hay nada seleccionado ni nada abierto.

**La escritura y la corrección enseñan el resultado antes de que vaya a ninguna parte.** Aparece en un cuadro junto a tu texto con un botón Aplicar; aplicar pasa por el historial del editor, y un deshacer lo devuelve. Lo que devuelve un modelo merece leerse antes de aterrizar en lo que estabas escribiendo.

**La traducción no ofrece nada que aplicar.** Sustituir un documento por su traducción no es lo que nadie quiere decir con «traducir»; se muestra para leerla y copiarla. Un documento entero se traduce por tandas y va apareciendo — ves el principio mientras el final aún llega, y un fallo cuesta una tanda en vez del archivo. Se dibuja como estás leyendo: como fuente junto a la vista de fuente, compuesta junto a la vista previa.

## Cómo funciona

Cuatro archivos: [`plugin.lua`](../../plugin.lua), el módulo de API del SDK [`lib/marktext-plus.lua`](../../lib/marktext-plus.lua), [`lib/prompts.lua`](../../lib/prompts.lua), que guarda las instrucciones y tus cambios, y [`lib/blocks.lua`](../../lib/blocks.lua), que parte el documento en párrafos y los reagrupa en peticiones. `plugin.lua` los carga con `require`. Sin compilar, sin dependencias, igual en Windows, macOS y Linux. Corre en un espacio aislado dentro del editor, sin sistema de archivos, sin red y sin la biblioteca `os`: `require` sólo llega dentro del propio directorio del complemento.

**Las instrucciones están aquí, en el complemento**, y son ellas las que mantienen el Markdown intacto:

```
- Preserve every Markdown construct exactly: headings, lists, tables,
  links, images, footnotes, block quotes and front matter.
- Do not translate code inside fences or inline code, URLs, file paths,
  or HTML tag names.
- Keep the same block order and the same number of blocks.
```

El editor guarda tu clave de API y hace la petición; el complemento no la ve nunca, y él mismo no toca la red.

## Qué pide

| Permiso | Para qué |
|---|---|
| `document.read` | el texto sobre el que trabajar |
| `document.write` | para aplicar una reescritura, y sólo cuando pulsas Aplicar |
| `ai.chat` | para preguntar al modelo que configuraste |
| `storage.local` | para recordar tus instrucciones y tu idioma de destino |
| `ui.contextMenu` | las cuatro entradas del clic derecho |
| `ui.sidebar` | el icono de escritura |
| `ui.settings` | su página de ajustes |
| `ui.notifications` | para decir cuándo no hay nada sobre lo que trabajar |

No pide `network.request`, así que no puede mandar tu texto a ningún sitio al que el editor no lo haya mandado. `document.write` lo comprueba el editor al pulsar Aplicar, no por la palabra del complemento.

## Ajustes

Seis campos, en su propia página: una instrucción de sistema y otra de usuario para cada una de las tres órdenes. Qué es el modelo y qué se le da son dos cosas distintas que querrás cambiar por separado — y a un modelo que traduce siempre mal cierto tipo de documento se le arregla diciéndoselo en la instrucción, cosa que desde fuera del complemento no puede hacer nadie.

| Marcador | Se rellena con |
|---|---|
| `{{text}}` | el texto con el que se trabaja |
| `{{language}}` | el idioma de destino elegido |
| `{{instruction}}` | lo que le pediste a la escritura |

A una plantilla que olvide `{{text}}` se le añade el texto al final, porque una instrucción sin nada sobre lo que trabajar es peor que una desordenada. Cada campo muestra su valor por defecto, para que veas qué estás cambiando; vaciarlo lo restablece.

Llaves dobles en lugar de `${...}`: esa forma es interpolación en Dart, en las plantillas de JavaScript y en el intérprete de órdenes, y `$` es además el delimitador de KaTeX, que este editor compone.

## Idiomas

Doce, como el editor: English, 简体中文, 日本語, 한국어, Deutsch, Français, Italiano, Русский, Español, Português, Português (Brasil) y العربية. Añadir otro son unas líneas en `locales` en [`manifest.json`](../../manifest.json) — se agradecen las pull requests.

## Instalación

Descarga el ZIP de la publicación y usa **Complementos → Instalar desde ZIP** en MarkText Plus, o encuéntralo en **Descubrir**: este repositorio lleva el topic de GitHub `marktext-plus-plugin`.

Con licencia MIT.
