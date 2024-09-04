---
title: Glory of the Garden
description: >
  PicoCTF Forensics Challenge - Easy
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","easy","picoctf2019"]
---

---
# Enunciado del problema

This [garden](https://jupiter.challenges.picoctf.org/static/d0e1ffb10fc0017c6a82c57900f3ffe3/garden.jpg) contains more than it seems.

---
# Resolución

En este reto nos dan una imagen que si hacemos un poco de reconocimiento por la imagen, como puede ser ver la información en hexadecimal, strings ocultas o esteganografía veremos la flag, aqui una manera de muchas, de hacerlo:

```bash
$> strings garden.jpg -n10 | grep picoCTF

Here is a flag "picoCTF{more_than_m33ts_the_3y3eBdBd2cc}"
```
