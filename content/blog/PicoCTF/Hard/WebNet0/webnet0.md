---
title: WebNet0
description: >
  PicoCTF Forensics Challenge - Hard
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","hard","picoctf2019", "wireshark"]
---

---
# Enunciado del problema

We found this [packet capture](https://jupiter.challenges.picoctf.org/static/0c84d3636dd088d9fe4efd5d0d869a06/capture.pcap) and [key](https://jupiter.challenges.picoctf.org/static/0c84d3636dd088d9fe4efd5d0d869a06/picopico.key). Recover the flag.

---
# Resolución

Al abrir el paquete de red vamos que esta todo encriptado con TLS, y al abrir **key** vemos que tiene una clave privada, ya con esto lo podemos con interfaz grafica o con herramienta terminal.

### GUI Method
Nos iremos al menu de *Preferencias* [`Ctrl + Shift + P`] y dentro del apartado: *RSA Keys* meteremos el archivo: *key* (picopico.key)

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240809172430.png)

Ahora si buscamos por los tls streams encontraremos la flag, especificamente en: *tcp.stream eq 2*

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240809172511.png)

Flag:
```
picoCTF{nongshim.shrimp.crackers}
```

Otras maneras son mediante terminal, inyectando la key dentro del programa, diferente método misma solución:
```bash
editcap --inject-secrets tls,keys.txt capture.pcap key-capture.pcapng
```

Por último, inyectar directamente la key, como en el método grafico, lo malo es que editamos el archivo (como en el primero, exactamente lo mismo):

```bash
ssldump -r capture.pcap -k picopico.key -d
```