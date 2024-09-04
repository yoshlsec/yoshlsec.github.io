---
title: Suspicious Threat
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/746)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "rootkit"]
---

---
# Enunciado del problema

Our SSH server is showing strange library linking errors, and critical folders seem to be missing despite their confirmed existence. Investigate the anomalies in the library loading process and filesystem. Look for hidden manipulations that could indicate a userland rootkit. Creds: `root:hackthebox`

---
# Resolución
Nos hablan de un posible rootkit, mi primer pensamiento fue ver las librerias a las que llaman los binarios cuando los ejecutas. Al usar el comando *ldd*, diseñado para hacer lo mencionado, obtenemos que hay una libreria que se esta llamando de manera estática, para mayor comodidad usamos el comando: *scp*, ayudando a transferir archivos mediante el protocolo ssh.

```bash
ldd /usr/sbin/shutdown
scp -P 57907 root@94.237.59.63:/lib/x86_64-linux-gnu/libc.hook.so.6 .
```

Analizando el binario con *IDA64* observamos como llama a un directorio y lo borra.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240802235629.png)

Una vez de vuelta al servidor ssh, borraremos la libreria estática, y buscaremos el directorio que se eliminaba, para encontrar ahi dentro la flag del reto.

```
rm /lib/x86_64-linux-gnu/libc.hook.so.6
find / -iname "pr3l04d_"
cat /var/pr3l04d_/flag.txt
```