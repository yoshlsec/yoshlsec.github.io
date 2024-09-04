---
title: m00nwalk2
description: >
  PicoCTF Forensics Challenge - Hard
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","hard","picoctf2019", "stego", "qqstv"]
---
---
# Enunciado del problema

Revisit the last transmission. We think this [transmission](https://jupiter.challenges.picoctf.org/static/571a2c199e39fb02f4fcc5791ed9bce1/message.wav) contains a hidden message. There are also some clues [clue 1](https://jupiter.challenges.picoctf.org/static/571a2c199e39fb02f4fcc5791ed9bce1/clue1.wav), [clue 2](https://jupiter.challenges.picoctf.org/static/571a2c199e39fb02f4fcc5791ed9bce1/clue2.wav), [clue 3](https://jupiter.challenges.picoctf.org/static/571a2c199e39fb02f4fcc5791ed9bce1/clue3.wav).

---
# Resolución

Hay dos maneras de convertir un *.wav* a un formato imagen, ambas con **qsstv** y **sstv**, vamos a empezar con la más común automatizada, que es usando **sstv**, simplemente hay que ejecutar el siguiente comando y tendríamos la imagen de un archivo de audio:

```bash
sstv -d <file.wav> -o <file.png>
```

Y ya está, sinceramente bastante aburrido en comparación con la siguiuente manera, que es usando la interfaz gráfica de **qsstv**, la podemos instalar en un debian based con el siguiente comando:

```bash
sudo apt install qsstv
```

Una vez hecho esto solo falta ejecutar el programa, y se nos abrira la siguiente interfaz gráfica:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted image%2020240614114828.png)

Por defecto esta herramienta esta programada para que el input venga desde fuera, como puede ser para escsuchar la cinta dentro de una habitación por señal y otras cosas inimaginales para la gente que usa este programa, nosotros nos iremos al apartado de *Options* -> *Configuration* -> *Sound*, donde veremos las siguientes opciones:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted image%2020240614115020.png)

Aqui cambiaremos las opciones de **Sound Input** habilitaremos **From file**, ahora al darle al botón de *Status Start Reciever* se nos abrira un explorador de archivos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted image%2020240614115342.png)

Hecho esto, uno de los archivos nos reportará la siguiente imagen:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/clue1.png)

Ahora usando el comando: *steghide* obtendremos la flag del archivo principal (*message.wav*):

```bash
$> steghide extract -sf message.wav -p hidden_stegosaurus

wrote extracted data to "steganopayload12154.txt".
```

Al abrirlo tendremos la flag.