---
title: Mireshark doo dooo do doo
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2021", "wireshark"]
---
---
# Enunciado del problema

Can you find the flag? [shark1.pcapng](https://mercury.picoctf.net/static/81c7862241faf4a48bd64a858392c92b/shark1.pcapng).

---
# Resolución

La captura de paquetes que nos han proporcioando observamos que tenemos un registro de kerberos encriptado, si vamos viendo por los streams TCP del archivo, podemos encontrar una petición fuera de lo normal, en comparación con el resto de registros de ataques de kerberos.

Aquí la petición del cliente:

```cleartext
GET / HTTP/1.1
Host: 18.222.37.134
Connection: keep-alive
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
```

Y la respuesta del servidor es una cadena de texto:

```cleartext
HTTP/1.1 200 OK
Date: Mon, 10 Aug 2020 01:51:45 GMT
Server: Apache/2.4.29 (Ubuntu)
Last-Modified: Fri, 07 Aug 2020 00:45:02 GMT
ETag: "2f-5ac3eea4fcf01"
Accept-Ranges: bytes
Content-Length: 47
Keep-Alive: timeout=5, max=100
Connection: Keep-Alive
Content-Type: text/html

Gur synt vf cvpbPGS{c33xno00_1_f33_h_qrnqorrs}
```

Podemos identificar que es una método de encriptación de transposición, especificamente **rot13**, esto lo podemos saber por *Gur* que hace referencia a *The*, con el siguiente script podemos pasar de texto en rot13 a texto plano y viceversa:

```bash
$> echo 'Gur synt vf cvpbPGS{c33xno00_1_f33_h_qrnqorrs}' | tr 'A-Za-z' 'N-ZA-Mn-za-m'

The flag is picoCTF{p33kab00_1_s33_u_deadbeef}
```

También si lo nuestro no es la programación podemos usar herramientas online como *cyberchef* para hacer el mismo proceso, simplemente buscando en las recetas *ROT13*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240613121858.png)
