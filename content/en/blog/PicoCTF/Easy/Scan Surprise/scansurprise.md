---
title: Scan Surprise
description: >
  PicoCTF Forensics Challenge - Easy
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","easy","picoctf2024", "qr_code"]
---
---
# Enunciado del problema

I've gotten bored of handing out flags as text. Wouldn't it be cool if they were an image instead? You can download the challenge files here:

- [challenge.zip](https://artifacts.picoctf.net/c_atlas/16/challenge.zip)

Additional details will be available after launching your challenge instance.

---
# Resolución

Para este reto tendremos que usar herramientas externas como un telefono movil, un escaner de códigos QR u otras herramientas web, en mi caso utilizare: https://dnschecker.org/qr-code-scanner.php
Dentro del comprimido habra varias carpetas como matrioskas, y al llegar al final obtendremos un archivo en formato imagen que contiene un código QR, al escanearlo nos devolvera la flag:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240613122253.png)

