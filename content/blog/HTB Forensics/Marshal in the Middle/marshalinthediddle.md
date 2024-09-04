---
title: Marshal in the Middle
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/27)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "wireshark"]
---
---
# Enunciado del problema

*The security team was alerted to suspicous network activity from a production web server.
Can you determine if any data was stolen and what it was?*

---
# Resolución
### Analizando archivos
En este caso nos traen varios archivos, aquí un listado de ellos:

```bash
 bundle.pem   chalcap.pcapng   secrets.log

bro: (Directorio)
 conn.log   dns.log   files.log   http.log   packet_filter.log   ssl.log   weird.log
```

Buscando lo que es el archivo **secrets.log** vemos que es para leer el texto plano de un paquete SSL/TLS, investigando más logramos introducir estos "secretos" en las preferencias (**Edit** > **Preferences**) de nuestro wireshark, para no tener problema alguno:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/0.png.png)

Ahora si vamos a ver los paquetes de red en  el archivo: **chalcap.pcapng**

### Analizando con wireshark
Como de costumbre empezamos viendo que las conversaciones entre las IPs y nos fijaremos en la conversación con más intercambio de datos, en este caso está entre las 2 *IPs*:
- Cliente -> 10.10.20.13
- Servidor: -> 104.20.208.21

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/1.png.png)

Si aplicamos el filtro: `ip.addr == 10.10.20.13 && ip.addr == 104.20.208.21`, nos llamara la atención el paquete de **5725** por la petición *POST* al directorio: */api/api_post.php*, si hacemos un seguimiento al protocolo TCP (click derecho > **Follow** > **HTTP Stream**), nos mostrará las peticiones completas y veremos que está en el dominio **pastebin.com**
- Dominio -> pastebin.com

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/2.png.png)

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/3.png.png)

### Aplicando filtro del dominio
Como ya sabemos el dominio podemos hacer un filtro para tener más información sobre este:
```wireshark
http.host == "pastebin.com"
```

Y si hacemos seguimiento *HTTP* a uno de estos 3 paquetes (es indiferente) nos llevará al segundo filtro:
```wireshark
tcp.port == 187
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/4.png.png)

Y ahí podemos ver la flag que nos estaban pidiendo:

```
HTB{Th15_15_4_F3nD3r_Rh0d35_M0m3NT!!}
```