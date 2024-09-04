---
title: Matryoshka doll
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2021", "binwalk"]
---
---
# Enunciado del problema

Matryoshka dolls are a set of wooden dolls of decreasing size placed one inside another. What's the final one? Image: [this](https://mercury.picoctf.net/static/b6205dd933ec01c022c4e6acbdf11116/dolls.jpg)

---
# Resolución

Por el nombre del reto sabemos que trata de una sucesión de *embed files*/archivos escondidos, con el parametro **-M** de binwalk podemos sacarlo todos a la vez:

```bash
$> binwalk -eM dolls.jpg

Scan Time:     2024-06-02 20:54:49
Target File:   /data/dolls.jpg
...
```

Una vez hecho esto podemos filtrar por los archivos, con el comando *find*:

```bsah
$> find _dolls.jpg.extracted -type f

_dolls.jpg.extracted/4286C.zip
_dolls.jpg.extracted/base_images/2_c.jpg
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/2DD3B.zip
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/3_c.jpg
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/_3_c.jpg.extracted/1E2D6.zip
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/_3_c.jpg.extracted/base_images/4_c.jpg
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/_3_c.jpg.extracted/base_images/_4_c.jpg.extracted/136DA.zip
_dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/_3_c.jpg.extracted/base_images/_4_c.jpg.extracted/flag.txt

$> cat _dolls.jpg.extracted/base_images/_2_c.jpg.extracted/base_images/_3_c.jpg.extracted/base_images/_4_c.jpg.extracted/flag.txt

picoCTF{4f11048e83ffc7d342a15bd2309b47de}
```

