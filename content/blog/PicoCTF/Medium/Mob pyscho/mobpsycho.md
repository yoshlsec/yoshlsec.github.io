---
title: Mob psycho
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2019", "apk"]
---

---
# Enunciado del problema

Can you handle APKs? Download the android apk [here](https://artifacts.picoctf.net/c_titan/52/mobpsycho.apk).

--- 
# Resolucción

En pocas palabras, hacemos un *file* al archivo, vemos que es un comprimido, lo descomprimimos, buscamos por archivos txt, encontraremos:

```bash
$> cat ./res/color/flag.txt

7069636f4354467b6178386d433052553676655f4e5838356c346178386d436c5f38356462643231357d
```

Que si lo metemos en cybercheft nos da la flag: `picoCTF{ax8mC0RU6ve_NX85l4ax8mCl_85dbd215}`