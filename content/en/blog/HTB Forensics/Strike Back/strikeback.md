---
title: Strike Back
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/278)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "deobfuscation", "wireshark", "cobaltstreak"]
---
---
# Enunciado del problema

A fleet of steam blimps waits the final signal from their commander in order to attack gogglestown kingdom. A recent cyber attack had us thinking if the enemy managed to discover our plans and prepare a counter-attack. Will the fleet get ambused???

---
# Resolución

Nos dan un *Mini Dump* y un pcap file, viendo por encima obtenemos un ejecutable *PE32* de en el pcap.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240517163716.png)

Decidimos buscar el ejecutable, mediante el hash, en virustotal para ver que tipo de virus es:

```powershell
$> md5sum freesteam.exe

10d01baf19d5d2448799e440095a8035  freesteam.exe
```


Nada más leer el reporte, *AhnLab-V3* nos reporta que tiene que ver con CobaltStrike:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240517163909.png)

Buscando el como desencriptar/sacar informacion de archivos relacionados con cobal strike observamos el siguieten código en python: 

Fuente: https://blog.nviso.eu/2021/11/03/cobalt-strike-using-process-memory-to-decrypt-traffic-part-3/
Fuente: https://blog.didierstevens.com/2021/04/26/quickpost-decrypting-cobalt-strike-traffic/
Code: https://github.com/DidierStevens/Beta/blob/master/cs-parse-http-traffic.py
Code: https://github.com/DidierStevens/Beta/blob/master/cs-extract-key.py

Siguiendo el tutorial obtenemos con el comando: *cs-extract-key* las clvaes HMAC y AES:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240517172433.png)

Para luego usarlas en *cs-http-traffic* y obtener archivos o todo lo posible, el formato que nos espefician es: *HMAC:AES*, de la siguiente manera:

```powershell
python .\cs-parse-http-traffic.py -k bf2d35c0e9b64bc46e6d513c1d0f6ffe:3ae7f995a2392c86e3fa8b6fbc3d953a .\capture.pcap
```

usando la argumento *-e* podemos extraer los archivos listados:

```powershell
$> file *.vir
 
payload-00f542efefccd7a89a55c133180d8581.vir: PDF document, version 1.4, 1 pages
payload-1e4b88220d370c6bc55e213761f7b5ac.vir: PE32 executable (DLL) (GUI) Intel 80386, for MS Windows, 4 sections
payload-2211925feba04566b12e81807ff9c0b4.vir: data
payload-851cbc5a118178f5c548e573a719d221.vir: PE32+ executable (DLL) (GUI) x86-64, for MS Windows, 5 sections
payload-b0cfbef2bd9a171b3f48e088b8ae2a99.vir: writable, executable, regular file, no read permission
payload-b25952a4fd6a97bac3ccc8f2c01b906b.vir: ASCII text, with no line terminators
```

Y al abrir el **PDF** encontramos la flag:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240517173302.png)

