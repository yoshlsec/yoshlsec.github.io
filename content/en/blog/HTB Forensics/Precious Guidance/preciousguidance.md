---
title: Precious Guidance
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/319)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "macro", "olevba", "microsoft word"]
---
---
# Enunciado del problema

Miyuki has come across what seems to be a suspicious process running on one of her spaceship's navigation systems. After investigating the origin of this process, it seems to have been initiated by a script called "SatelliteGuidance.vbs". Eventually, one of your engineers informs her that she found this file in the spaceship's Intergalactic Inbox and thought it was an interactive guide for the ship's satellite operations. She tried to run the file but nothing happened. You and Miyuki start analysing it and notice you don't understand its code... it is obfuscated! What could it be and who could be behind its creation? Use your skills to uncover the truth behind the obfuscation layers.

---
# Resolución

Nos dan un **.vbs** que al hacerle un file nos muestra que es un archivo de: *Sony PLayStation Audio*

```bash
$> ll
total 2.2M
-rwxrwxrwx 1 yoshl yoshl 2.2M May 12  2022 SatelliteGuidance.vbs

$> file SatelliteGuidance.vbs
SatelliteGuidance.vbs: Sony PlayStation Audio
```

Aun haciendo caso al enunaciado, probamos a sacar los macros, y si, nos reporta un gran macro, como habia muchas arrays y las estaba ejecutando, pense cambiar la funcion de ejecutar por la de mostar y quitar estas últimas lineas del código:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515172013.png)

Usando **cscript** ejecutamos el macro y terminamos redirigiendo todo el output a un nuevo archivo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515172104.png)


Viendo un poco por encima observamos que esta creando un **dll** y sin miedo volvemos a ejecutar el archivo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515172315.png)

Al obtener el ddl podemos abrir *dnSpy*, y encontrar un código un poco llamativo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/1%20REFMzmmLQIO358QfGBsMhQ.webp)

Metiendo esto en cyberchef, nos aparecera la contraseña (es un formato hexadecimal)