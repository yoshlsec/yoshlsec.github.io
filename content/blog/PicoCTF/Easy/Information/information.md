---
title: Information
description: >
  PicoCTF Forensics Challenge - Easy
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","easy","picoctf2021", "metadata"]
---


---
# Enunciado del problema

Files can always be changed in a secret way. Can you find the flag? [cat.jpg](https://mercury.picoctf.net/static/e5825f58ef798fdd1af3f6013592a971/cat.jpg)

---
# Resolución

Al ser una imagen empezamos mirando los metadatos, nos llama la atención el valor *Licence*:

```bash
$> exiftool cat.jpg

ExifTool Version Number         : 12.57
File Name                       : cat.jpg
Directory                       : .
File Size                       : 878 kB
File Modification Date/Time     : 2024:06:02 22:37:06+02:00
File Access Date/Time           : 2024:06:02 22:37:23+02:00
File Inode Change Date/Time     : 2024:06:02 22:37:22+02:00
File Permissions                : -rwxrwxrwx
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.02
Resolution Unit                 : None
X Resolution                    : 1
Y Resolution                    : 1
Current IPTC Digest             : 7a78f3d9cfb1ce42ab5a3aa30573d617
Copyright Notice                : PicoCTF
Application Record Version      : 4
XMP Toolkit                     : Image::ExifTool 10.80
License                         : cGljb0NURnt0aGVfbTN0YWRhdGFfMXNfbW9kaWZpZWR9
Rights                          : PicoCTF
Image Width                     : 2560
Image Height                    : 1598
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 2560x1598
Megapixels                      : 4.1
```

Si lo desencodeamos en base64:

```bash
$> echo cGljb0NURnt0aGVfbTN0YWRhdGFfMXNfbW9kaWZpZWR9 | base64 -d

picoCTF{the_m3tadata_1s_modified}
```