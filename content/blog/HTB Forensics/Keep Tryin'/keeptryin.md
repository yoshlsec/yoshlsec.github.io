---
title: Keep Tryin'
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/51)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "wireshark", "deobfuscation"]
---

---
# Enunciado del problema

This packet capture seems to show some suspicious traffic

---
# Resolución

Nos encontramos dos objetos dentro del pcap, que son unos "rabbit holes" que nos motivian diciendo que sigamos y `TryHarder` que lo manda a un archivo llamado flag, en el servidor. Nos encontramos un stream udp con el siguiente contenido:

```c
`............init.c2VjcmV0LnR4dHwx.totallylegit.com.....`............init.c2VjcmV0LnR4dHwx.totallylegit.com..................OK
```

Donde: c2VjcmV0LnR4dHwx es un código en base64 y su contenido en texto plano es: secret.txt.

En el segundo steam de tcp, nos encontramos con otra cadena de texto... 

```c
0ejXWsr6TH-P_1xkEstaVwi7WDy8AcxufnGotWXH3ckb2Lh5A-qFljIWOAOLUS0?T1W8P4CpiCZbCM7_QKcv-r0JG29RpsyYY5YkZRxo7YDIYUJpHlGgxu5PWV1G_DA?KNrmnrktfbeDgzcpPJBjPTeMYx3Qs1Q6bAuFhROWXemJ80gPTYIz0xl8usJQN3m.w
```

Aqui. al intentar desencondear en base64 no encontramos nada, decidimos ir para atras y ver el contenido nuevamente del resto de paquetes, donde vemos que `TryHader` es una key de un cifrado:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240505114844.png)

Con ayuda de cyberchef, vemos que es un encriptado RC4:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240505114951.png)

Al descomprimirlo obtendremos la flag.