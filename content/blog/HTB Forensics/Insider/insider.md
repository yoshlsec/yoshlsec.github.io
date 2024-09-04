---
title: Insider
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/160)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "browser", "gecko"]
---


---
# Enunciado del problema
A potential insider threat has been reported, and we need to find out what they accessed. Can you help?
---
# Resolución 
### Requesitos
Para este nivel usaremos una herramienta de github que nos viene muy bien para *dumpear* archivos de firefox, pero también os dejo un par más para que os acostumbréis  a este tipo de datos:

1. https://github.com/unode/firefox_decrypt -> Nos saca las contraseñas de los perfiles

2. https://github.com/numirias/firefed -> Nos saca contraseñas, cookies, registros...
3. https://github.com/Busindre/dumpzilla -> Nos saca contraseñas, cookies, bookmarks, registros...

### Usando Firefox_decrypt
Una vez visto por encima todos los archivos y configurada la herramienta nos disponemos a usarla con el usuario *2542z9mo.default-release*, que lo vemos en el directorio: *Mozilla/Firefox/Profiles*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/PasswordInsider.png.png)
Así de una manera tan sencilla obtenemos la contraseña del usuario: *admin*.
