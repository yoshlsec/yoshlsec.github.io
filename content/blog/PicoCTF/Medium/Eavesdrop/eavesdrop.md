---
title: Eavesdrop
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2022", "wireshark", "torrent"]
---

---
# Enunciado del problema

Download this packet capture and find the flag.
- [Download packet capture](https://artifacts.picoctf.net/c/135/capture.flag.pcap)

---
# Resolución

Cuando listamos los *strings* dell archivo se puede ver la siguiente conversación con un archivo y credenciales:

```
EHey, how do you decrypt this file again?
ci>d@You're serious?
cYeah, I'm serious
*sigh* openssl des3 -d -salt -in file.des3 -out file.txt -k supersecretpassword123
Ok, great, thanks.
Let's use Discord next time, it's more secure.
NJC'mon, no one knows we use this program like this!
xWhatever.
gCould you transfer the file to me again?
Oh great. Ok, over 9002?
Yeah, listening.
4iAa+You're unbelievable
```

Dicha conversación se ve en un formato más legible en: `tcp.stream eq 0`:

![[Pasted image 20240827000427.png]]

Con ayuda de *binwalk* listamos el archivo que queremos obtener:

```bash
$> binwalk capture.flag.pcap

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             Libpcap capture file, little-endian, version 2.4, Ethernet, snaplen: 262144
5882          0x16FA          OpenSSL encryption, salted, salt: 0x3C4B26E8B8F91E2C
```

Como binwalk, ni foremost ni bulk_extractor nos extraen el archivo que listan... usaremos `dd`

```bash
dd if=capture.flag.pcap of=openssl_data.bin bs=1 skip=5882
```

Ya obtenido el archivo lo desencriptaremos con el siguiente comando::
```bash
$> openssl des3 -d -salt -in openssl_data.bin -out file.txt -k supersecretpassword123
*** WARNING : deprecated key derivation used.
Using -iter or -pbkdf2 would be better.
bad decrypt
804B8063857F0000:error:1C80006B:Provider routines:ossl_cipher_generic_block_final:wrong final block length:../providers/implementations/ciphers/ciphercommon.c:443:

$> strings file.txt -n10 # Flag
picoCTF{nc_73115_411_0ee7267a}
```
