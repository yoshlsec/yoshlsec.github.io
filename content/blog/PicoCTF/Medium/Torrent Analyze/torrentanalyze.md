---
title: Torrent Analyze
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2022", "wireshark", "torrent"]
---

---
# Enunciado del problema

SOS, someone is torrenting on our network. One of your colleagues has been using torrent to download some files on the company’s network. Can you identify the file(s) that were downloaded? The file name will be the flag, like `picoCTF{filename}`. [Captured traffic](https://artifacts.picoctf.net/c/165/torrent.pcap).

---
# Resolución

Una costumbre que estoy empezando a tener con las capturas de red es ver los nombres de los servidores para enterarme mejor de que esta pasando, y que IP es la emisora, en este caso, usamos el filtro:

```wireshark
tls.handshake.extensions_server_name
```

Y obtenemos el nombre del host: *torrent.ubuntu.com* (me gusta hacer esto, asi no dependemos del enunciado del problema):

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240823125301.png)

Como nos piden el nombre del archivo habrá que ver en los objetos:

thasrk exportar objetos

```bash
mkdir exported
for p in http ftp smtp smb pop; do tshark -r torrent.pcap -q -z export_objects,"$p" > "exported/${p}_objects.txt" &>/dev/null; done
```

Pero no encontramos ningún objeto exportado, viendo los paquetes de la captura podemos identificar que el protocolo: *[BT-DHT](https://www.bittorrent.org/beps/bep_0005.html)* tiene que ver con torrent, de este modo, empezamos a investigar acerca del protocolo y sus funcionalidades.

_PD: Hay que habilitarse todos los protocolos en wireshark: Ctrl + Shift + E -> Enable All_

Tras buscar por palabras clave en los paquetes, vemos el *hash md5* de un archivo, a la hora de buscarlo en google terminamos por encontrar un archivo *.iso* de ubuntu:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240826235551.png)

Flag: `picoCTF{ubuntu-19.10-desktop-amd64.iso}`

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240826235609.png)