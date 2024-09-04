---
title: Trivial Flag Transfer Protocol
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2021", "wireshark"]
---

---
# Enunciado del problema

Figure out how they moved the [flag](https://mercury.picoctf.net/static/fb24ddcfaf1e297be525ba7474964fa5/tftp.pcapng).

---
# Resolución

## Protocolo TFTP

El acronimo de: **T**_rivial_ **F**_ile_ **T**_ransfer_ **P**_rotocol_, es un protocolo cliente-servidor que regula la trasnferencia de archivos en redes, sin encriptarlas con **SSL** u otros protocolos, ya deducimos que estamos hablando ante un **UDP**.

![img1](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img1.png?raw=true)
https://raw.githubusercontent.com/yoshlsec/OLD-images-web/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img1.png?token=GHSAT0AAAAAACWACKPUVBUKX4XCSD3UOGLMZWQRPKA

## Protocolo SSDP

Protocolo el cúal sirve para la búsqueda de dispositivos _UPnP_ dentro de una red, siendo utilizado tanto en unicast como en multicast, aquí os dejo un pdf que explica muy bien el funcionamiento de dicho protocolo y sobre los dispositivos _UPnp_: [https://biblus.us.es/bibing/proyectos/abreproy/11954/fichero/4+-+CAP.3+-+Tecnologia+UPnP.pdf](https://biblus.us.es/bibing/proyectos/abreproy/11954/fichero/4+-+CAP.3+-+Tecnologia+UPnP.pdf)

**Arquitectura de UPnP** ![img2](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img2.png?raw=true)

# Analisis de wireshark

Una vez sabiendo como funcionan los protocolos capturados de la red, leyendo la pequeña descripción de los paquetes principales nos damos cuenta que un cliente esta accediendo a varios archivos, dichos nombres son:

- **instructions.txt**
- **program.deb**

![img3](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img3.png?raw=true)

## Exportando archivos

Por comodidad vamos a extraer los posibles archivos de la captura _pcapng_:

![img4](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img4.png?raw=true)

![img5](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img5.png?raw=true)

Como podemos ver nos aparecen 6 archivos y podemos identificar los 2 mencionados anteriormente, acontinuación le damos a **Save All** o **Guardar todos**, dependiendo de como tengas configurado _wireshark_ con los idiomas y ya tendriamos los paquetes en nuestro equipo:

![img6](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img6.png?raw=true)

# Analizando archivos

Con el comando: **file** que ya viene incluido en los dispositivos: _Unix_ nos indica que tipo de archivo es el selecionado, en este caso vamos a seleccionar todos los archivos extraidos para eso usaremos el símbolo: *****:

```bash
$ file *            

instructions.txt: ASCII text
picture1.bmp:     PC bitmap, Windows 3.x format, 605 x 454 x 24, image size 824464, resolution 5669 x 5669 px/m, cbSize 824518, bits offset 54
picture2.bmp:     data
picture3.bmp:     data
plan:             ASCII text
program.deb:      Debian binary package (format 2.0), with control.tar.gz, data compression xz
tftp.pcapng:      pcapng capture file - version 1.0
```

## Leyendo los txt

### instructions.txt

Al hacer un _cat_ al archivo vemos que no es un formato legible y tampoco esta encodeado en _Base64_ entonces vamos a probar con la famosa “encriptación” _ROT13_ para ello os voy a compartir un scirpt que tengo hecho para agilizar este proceso:

```bash
rot13de: aliased to tr '[a-zA-Z]' '[n-za-mN-ZA-M]'
```

Una vez con este comando configurado vamos a leer el archivo en texto plano:

```ascii
TFTPDOESNTENCRYPTOURTRAFFICSOWEMUSTDISGUISEOURFLAGTRANSFER.FIGUREOUTAWAYTOHIDETHEFLAGANDIWILLCHECKBACKFORTHEPLAN
```

Vamos a poner espacios para saber que nos esta diciendo:

```ascii
TFTP DOESNT ENCRYPT OUR TRAFFIC SO WE MUST DISGUISE OUR FLAG TRANSFER. FIGURE OUT A WAY TO HIDE THE FLAG AND I WILL CHECK BACK FOR THE PLAN
```

### flag

Como el archivo anterior usaremos _ROT13_:

```ascii
IUSEDTHEPROGRAMANDHIDITWITH-DUEDILIGENCE.CHECKOUTTHEPHOTOS
```

Ahora poniendo los espacios:

```ascii
I USED THE PROGRAM AND HID IT WITH - DUEDILIGENCE. CHECK OUT THE PHOTOS
```

## Descomprimiendo el .deb

Con esta información no nos sirve, entonces gracias al comando _7z_ podemos ver que archivos tiene comprimidos, al hacerlo nos damos cuenta que tiene el archivo: **data.tar** en su interior y nuevamente vamos a descomprimir este:

![img7](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img7.png?raw=true)

![img8](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img8.png?raw=true)

Al descomprimirlo nos mostrara un directorio con el nombre **usr**, si investigamos un poco de este nos vamos a dar cuenta que tiene información relacionada con _steghide_ un comando usado para ver información y archivos ocultos en imagenes, videos u otros archivos:

![img9](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img9.png?raw=true)

# Usando: steghide

Investigando acerca del comando vemos que es muy sencillo de instalar y usar:

```bash
sudo apt install steghide
```

![img10](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img10.png?raw=true)

Ahora sabiendo lo básico del comando podemos usarlo, probando con los 3 archivos con extensión: **.bmp** solo funcionará con el archivo:

- **picture3.bmp**

![img11](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img11.png?raw=true)

Viendo que nos pide una contraseña, recordamos que en el archivo **flag** ponia que usaron el programa con: _DUEDILIGENCE_, entonces probaremos este como contraseña:

![img12](https://github.com/Llo0zy/images-web/blob/main/UGljb0NURi1Ucml2aWFsRmxhZ1RyYW5zZmVyUHJvdG9jb2wK/img12.png?raw=true)

Y ya tendríamos nuestra flag del _CTF Trivial Flag Transfer Protocol_: `picoCTF{h1dd3n_1n_pLa1n_51GHT_18375919}`