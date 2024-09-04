---
title: OpTinselTrace-1
description: >
  HackTheBox Sherlocks - Easy<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/OpTinselTrace-1)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy","sherlock", "wireshark"]
---

### Enunciado del problema

An elf named "Elfin" has been acting rather suspiciously lately. He's been working at odd hours and seems to be bypassing some of Santa's security protocols. Santa's network of intelligence elves has told Santa that the Grinch got a little bit too tipsy on egg nog and made mention of an insider elf! Santa is very busy with his naughty and nice list, so he’s put you in charge of figuring this one out. Please audit Elfin’s workstation and email communications. Please note - these Sherlocks are built to be completed sequentially and in order!

--- 
Investigando la inmensidad de archivos he encontrado el binario: `santa_deliveries` en el directorio: `elfidence_collection/TriageData/C/users/Elfin/Appdata/Roaming/top-secret`, en su interior encontramos un nombre de usuario y una contraseña:

```cpp
v0 = (unsigned __int8)std::operator==<char,std::char_traits<char>,std::allocator<char>>(v2, "elf-admin")
&& (unsigned __int8)std::operator==<char,std::char_traits<char>,std::allocator<char>>(v3, "3lfP@ssw0rd");
```

Ahora vamos a probar a ejecutar el binario:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502131351.png)

Nos preguntan por las credenciales, ponemos las que hemos obtenido con *ida (ghidra/binaryninja)*, pero no vemos que ocurra nada interesante, he probado a saturar el binario, con buffer overflow y viendo un poco más el código fuente, pero tiene pinta de ser un rabbit hole. 
Como dato curioso, el binario esta acompañado de un archivo comprimido, que si lo abrimos nos aparecen los logs del ejecutable.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502131823.png)

---

Como nos pregutaban sobre los el nombre del cliente que usaba Elfin en su correo electronico he decidido buscar en la raiz archivos relacionados con **mail**:

```bash
find . -iname "*mail*" -type f
```

Nos llama la atención dos archivos, que me suena de un recuerdo vago entre algun log del sistema:

```java
./TriageData/C/Windows/prefetch/MAILCLIENT.EXE-3B077E7E.pf
./TriageData/C/Windows/prefetch/MAILCLIENT.EXE-3B077E7D.pf
```


Investigando sobre la extensión **.pf** encontramos este blog que nos dice como abrir archivos prefetch de un windows 10: https://bromiley.medium.com/parse-windows-10-prefetch-files-in-linux-51a764cc045a

Parece ser otro rabbit hole, probando vemos que no hay mucha información...

---
Ya desesperado busque información sobre **eM client**, siendo un cliente como outlook, al estar solo disponible para windows se me complico hacerlo pero al final se pudo, pasamos la carpeta: `elfidence_collection/TriageData/C/users/Elfin/Appdata/Roaming/eM Client` a nuestro directorio de windows y empezamos a ver el email.

Como lo hice desde otro windows donde no tengo conexión para pasar capturas obtuve fotos de algunos writeups, asi se ve el cliente:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502142142.png)

Simplemente leyendo y sacando conclusiones podemos saber varias preguntas.

```
What is the name of the email client that Elfin is using?
eM client

What is the email the threat is using?
definitelynotthegrinch@gmail.com

When does the threat actor reach out to Elfin?
2023-11-27 17:27:26
```

La tercera pregunta esta dentro del email, en el mensaje original.
![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502142432.png)


Asi son el resto de preguntas, buscar todo al rededor del email, muchos archivos y muchas tablas, la mayoria vacias, se puede hacer mas "rapido" con sqlitebrowser...

Uno de los que se usa sin sqlitebrowser es la última pregunta:

```
The head elf PixelPeppermint has requested any passwords of Elfins to assist in the investigation down the line. What’s the windows password of Elfin’s host?
```

Para esto instalamos impacket y usamos la herramienta *secretsdump.py* en: `system3/config`

```bash
sudo apt install python3-impacket
python3 /usr/share/doc/python3-impacket/examples/secretsdump.py -sam SAM -security SECURITY -system SYSTEM LOCAL
```

De aqui sacamos varios hashes del ordenador, pero nos interesa más el de Elfin:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502163440.png)

