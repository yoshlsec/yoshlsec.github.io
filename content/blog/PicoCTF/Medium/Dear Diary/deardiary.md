---
title: Dear Diary
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2024", "disk"]
---

---
# Enunciado del problema

If you can find the flag on this disk image, we can close the case for good! Download the disk image [here](https://artifacts.picoctf.net/c_titan/63/disk.flag.img.gz).

---
# Resolución

```bash
$> file disk.flag.img

disk.flag.img: DOS/MBR boot sector; partition 1 : ID=0x83, active, start-CHS (0x0,32,33), end-CHS (0x26,94,56), startsector 2048, 614400 sectors; partition 2 : ID=0x82, start-CHS (0x26,94,57), end-CHS (0x47,1,58), startsector 616448, 524288 sectors; partition 3 : ID=0x83, start-CHS (0x47,1,59), end-CHS (0x82,138,8), startsector 1140736, 956416 sectors
```

Usando autopsy vemos en el directorio root un file.txt 

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240827194826.png)

Usando una función de grep podemos ver el contenido dentro de los archivos filtrados, de la siguiente manera

```bash
$> grep innocuous --text disk.flag.img
```

Y sacamos de aqui:

```
picoCTF{1_533_n4m35_80d24b30}
```