---
title: MacroHard WeakEdge
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2021", "olevba"]
---

---
# Enunciado del problema

I've hidden a flag in this file. Can you find it? [Forensics is fun.pptm](https://mercury.picoctf.net/static/2e739f9e0dc9f4c1556ea6b033c3ec8e/Forensics is fun.pptm)

---
# Resolución

Nos proporcionan un documento powerpoint, cada vez que tenemos un archivo de *Microsoft +2007* es recomendable ver si contiene algún macro ejecutable el archivo, podemos usar herramietnas como *oletools/olevba* para verificar si tiene MACROS o no, cuando lo ejecutamos vemos que no aparece un mensaje de una variable llamada: *not_flag*

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240613123659.png)

Como no contiene ningún macro llamativo, ejecutamos *binwalk* para obtener archivos ocultos dentro del powerpoint, al ejecutarlo nos detecta muchos archivos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240613124125.png)

Con el comando *7z* podemos extraer todos los archivos posibles, e investigando encontramos un archivo oculto en la carpeta: *.\\ppt\\slideMasters*, el nombre de este archivo es *Hidden*, su contenido es un tanto extraño

```bash
$> cat hidden

Z m x h Z z o g c G l j b 0 N U R n t E M W R f d V 9 r b j B 3 X 3 B w d H N f c l 9 6 M X A 1 f Q
```

Nos recuerda al encriptado *base64* por como se intercalan los números, letras mayúsculas y letras minúscula. Como hay espacios en el archivo vamos a quitarlos con el comando *tr* y despues probaremos a desencriptarlo en base64, todo esto lo podemos hacer en una simple linea de código en bash:

```bash
$> cat hidden | tr -d " " | base64 -d 2>/dev/null

flag: picoCTF{D1d_u_kn0w_ppts_r_z1p5}
```
