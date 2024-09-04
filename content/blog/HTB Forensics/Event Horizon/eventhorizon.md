---
title: Event Horizon
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/158)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "windows", "winevtx", "logs"]
---

---
# Enunciado del prbolema
Tenemos que descubrir que comandos ejecuto un hacker al integrarse en el equipo mediante la powershell, el problema es que borro el registro de esta pero no los archivos *[[evtx]]* que pueden tener algún tipo de pista.

---
# Resolución

## Filtrando archivos
Al tener una cantidad de 325 archivos *.evtx* vamos a ver si todos tienen contenido con el comando *file*:
```bash
file * | grep -v "empty"
```

Una vez hecho esto, todos los archivos tendrán algún tipo de registro, y nos llama la atención el archivo -> **Microsoft-Windows-PowerShell%4Operational.evtx**
Así que pasamos todo su contenido a un archivo xml:

```bash
evtxtract ./Microsoft-Windows-PowerShell%4Operational.evtx > ./logs.xml
```

## Leyendo archivo xml
Como sabemos que hubo un intruso vamos a ver si el firewall detecto algo, por lo general este nos manda un error con la siguiente sintaxis:
```powershell
Error Message = At line:n char:n
```

Entonces con nuestros conocimientos de bash, vamos a usar el comando *grep* para filtrar por esas lineas y las 2 siguientes para ver de que se trata el error:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/invokegrep.png.png)

Investigando un poco podemos ver que *Mimikatz* es una herramienta de post-explotación  que vuelca las credenciales/contraseñas de texto sin formato de la memoria, junto con hashes, códigos PIN y vales Kerberos. Básicamente una vez que tenemos acceso a la máquina usamos *Mimikatz* para ver algún tipo de credenciales sueltas por el sistema.

Si vemos más sobre el error, obtenemos su *Opcode* que nos sirve para ver más información sobre este error:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/opcodelinuxshell.png.png)

Ahora si buscamos por el *número del Opcode* en la lista de los errores (*mismo archivo*), nos saldra la información que queremos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Viendolaflagshell.png.png)

Para esto hay que saber que el argumento *MessageNumber* es equivalente al *número del Opcode* de un error, con eso ya tendríamos nuestra flag; aquí os dejo como sería hacerlo desde la aplicación *Event Log Explorer* disponible en Windows.

### Event Log Explorer
Mucho más fácil e intuitivo nada más abrir el archivo nos sale un aviso de un error sobre el anti-virus, que detecto el fallo anteriormente mencionado en Linux

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/EventLogEpxlorer.png.png)

Ahora si, podemos darle a un botón que nos filtra por el *ID* del evento y nos saldrán otros avisos...

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Filterbutton.png.png)

Dentro de los avisos podemos encontrar la flag y el contenido de estos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Viendolaflag.png.png)

Y ahí obtenemos la flag: *HTB{---}*.