---
title: OpTinselTrace-4
description: >
  HackTheBox Sherlocks - Easy<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/OpTinselTrace-4)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy","sherlock", "wireshark"]
---

---
### Enunciado del problema

Printers are important in Santa’s workshops, but we haven’t really tried to secure them! The Grinch and his team of elite hackers may try and use this against us! Please investigate using the packet capture provided! The printer server IP Address is 192.168.68.128 Please note - these Sherlocks are built to be completed sequentially and in order!

--- 

Nos dan un comprimido que nos piden una contraseña, como no tenemos más información se me ocurrio usar la contraseña que sacamos en [[OpTinselTrace-1]], dentro del binario nos encontrabamos con las credenciales, pero nada, no hubo suerte.

```bash
elf-admin:3lfP@ssw0rd
```

No borro eso para que se quede permanente... habia que poner otra vez la contraseña que HTB nos proporcionaba JAJJAJAJJA

---

Nos preguntan cual es la IP del atacante sabiendo que el servidor es: *192.168.68.128* y que el atacante ha mandado muchos paquetes a este, para hacerlo más sencillo y sin usar filtros, que podríamos usar:

```tshark
ip.dst == "192.168.68.128"
```

Podemos ver las conversación de *IPv4* y buscar la ip *192.168.68.128*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503182533.png)

También nos preguntan sobre el puerto que utiliza entonces, sin necesidad de conocimientos sobre los filtros de wireshark/tshark, podemos hacer click derecho en lo azul, seguir, elegir opción: **A -> B** y luego dentro de un paquete mirar la estructura del paquete, en mi caso elegi un TCP / SYN Scan, usado también en *nmap*.

Asi deducimos que el comando ejecutado por el atacante es: (esta parte es opcional pero curiosa)

```bash
nmap -p- -sS 172.17.79.133
```

Y aqui vemos como esta indicando el puerto *9100*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503182932.png)


Ahora nos estan preguntado por el nombre completo de la impresora, en el mismo paquete de red podemos ver la dirección mac de esta:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503183042.png)

```bash
Ethernet II, Src: VMware_16:1e:03 (00:0c:29:16:1e:03), Dst: VMware_ee:c1:2f (00:50:56:ee:c1:2f)
```

Sabiendo esto aplicamos el filtro con la mac address o en el paquete donde sacamos el puerto, y seguimos el stream tcp, acabando en el número 28, donde vemos el nombre que ARP nos dio:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503183422.png)

Si seguimos bajando en el mismo archivo encontraremos una lista de niños que nos piden para una de las preguntas:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503183551.png)

Y lo mismo con la carta de arrepentimiento...

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503183717.png)

En el stream 46, tambien relacionado con las ips anteriores... nos encontramos el puesto de trabajo que nos piden:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503183916.png)

Tambien nos piden una clave id_rsa, y si buscamos en la misma conversación sobre ssh lo encontramos, como veís es un reto muy muy sencillo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503184214.png)

---

 https://labs.hackthebox.com/achievement/sherlock/1615089/581