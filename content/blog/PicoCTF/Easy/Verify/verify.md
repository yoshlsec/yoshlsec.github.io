---
title: Verify
description: >
  PicoCTF Forensics Challenge - Easy
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","easy","picoctf2024", "checksum", "grep"]
---
---
# Enunciado del problema

People keep trying to trick my players with imitation flags. I want to make sure they get the real thing! I'm going to provide the SHA-256 hash and a decrypt script to help you know that my flags are legitimate. You can download the challenge files here:

- [challenge.zip](https://artifacts.picoctf.net/c_rhea/23/challenge.zip)

Additional details will be available after launching your challenge instance.

---

# Resolución

Nos proporcionan un archivo comprimido que en su interior encontramos 2 archivos y un directorio lleno de archivos comprimidos... Nos llama la atención un archivo llamado: `decrypt.sh`

```bash
#!/bin/bash

# Check if the user provided a file name as an argument
if [ $# -eq 0 ]; then
	echo "Expected usage: decrypt.sh <filename>"
	exit 1
fi

# Store the provided filename in a variable
file_name="$1"

# Check if the provided argument is a file and not a folder
if [ ! -f "/home/ctf-player/drop-in/$file_name" ]; then
	echo "Error: '$file_name' is not a valid file. Look inside the 'files' folder with 'ls -R'!"
	exit 1
fi

# If there's an error reading the file, print an error message
if ! openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -salt -in "/home/ctf-player/drop-in/$file_name" -k picoCTF; then
	echo "Error: Failed to decrypt '$file_name'. This flag is fake! Keep looking!"
fi
```

Vemos que esta desencriptando el contenido de una archivo con el comando openssl, junto a este script encontramos otro documento de text que se llama *checksum.txt* en su interior vemos un sha256:
- `b09c99c555e2b39a7e97849181e8996bc6a62501f0149c32447d8e65e205d6d2`

Sacado conclusiones, habrá que buscar un archivo que conincida con ese sha256 (recordamos que este tipo de hash es "único" para cada archivo) y desencriptarlo, nada pensar eso ejecute el siguiente comando en bash, para poder filtrar por los checksum del directorio:

```bash
$> sha256sum files/* | grep "b09c99c555e2b39a7e97849181e8996bc6a62501f0149c32447d8e65e205d6d2" -i

b09c99c555e2b39a7e97849181e8996bc6a62501f0149c32447d8e65e205d6d2  files/451fd69b
```

Con `sha256sum files/*` indicamos que en todos los archivos dentro del directorio *files* nos reporte su hash sha256 (con el comando sha256sum), y por último grepeamos/filtramos por el hash del checksum.txt. Una vez tenemos el archivo: *files/451fd69b* podemos ejecutar la parte del script: 

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -salt -in "/home/ctf-player/drop-in/$file_name" -k picoCTF
```

Para desencriptar el archivo:

```bash
$> openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -salt -in "./files/451fd69b" -k picoCTF

picoCTF{trust_but_verify_451fd69b}
```
