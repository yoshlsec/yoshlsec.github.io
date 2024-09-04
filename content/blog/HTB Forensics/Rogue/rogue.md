---
title: Rogue
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/371)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "deobfuscation", "windows", "crypto"]
---

---
# Enunciado del problema

SecCorp has reached us about a recent cyber security incident. They are confident that a malicious entity has managed to access a shared folder that stores confidential files. Our threat intel informed us about an active dark web forum where disgruntled employees offer to give access to their employer's internal network for a financial reward. In this forum, one of SecCorp's employees offers to provide access to a low-privileged domain-joined user for 10K in cryptocurrency. Your task is to find out how they managed to gain access to the folder and what corporate secrets did they steal.

---
# Resolución

Al estar hablando de la "dark web" pensando que esta en TheOnionRouter y lo podemos verificar por la cantidad de paquetes TCP, en vez de ver objetos **HTTP** miraremos los objetos **FTP-DATA**, donde encontraremos un *.zip* que pesa 21*MB*, al descomprimirlo obtenemos:

```bash
$> ls 3858793632.pmd -l
-rwxrwxrwx 1 yoshl yoshl 46239820 Jul  4  2022 3858793632.pmd

$> file 3858793632.pmd
3858793632.pmd: writable, executable, regular file, no read permission
```

Viendo por encima las cadenas de texto legibles por el ojo humano vemos que puede ser un malware para linux, por usar comando como: *ln*, podemos deducir que es un ransomware por la implementación de bcrypt

```powershell
$> grep "bcrypt" raw.data | sort -u

bcrypt.dll
bcrypt.pdb
bcryptprimitives.dll
bcryptPrimitives.dll
bcryptprimitives.pdb
onecore\ds\security\cryptoapi\ncrypt\crypt\bcrypt\init.c
onecore\ds\security\cryptoapi\ncrypt\translate\bcrypttranslate.c
.text$lp00bcryptprimitives.dll!20_pri7
.text$lp01bcrypt.dll!20_pri7
.text$lp01bcryptprimitives.dll!20_pri7
.text$lp03bcryptprimitives.dll!30_clientonly
.text$lp09bcryptprimitives.dll!40_serveronly
.text$lp10bcrypt.dll!40_serveronly
.text$lp10bcryptprimitives.dll!40_serveronly
.text$lp11bcryptprimitives.dll!50_coldboot
.text$lp12bcrypt.dll!50_coldboot
.text$lp12bcryptprimitives.dll!50_coldboot
```

_PD: Hemos conseguido raw.data haciendo: `strings *.pmd > raw.data`_

También vemos 2 posibles opciones llamadas:
- BCryptEncrypt
- EncryptFileA
- OpenEncryptedFileRawA
- CryptDecrypt
- DecryptFileA

Al volver a hacer un file al archivo vemos que es un minidump... sera por temas del windows defender de antes:

```powershell
$> file 3858793632.pmd

3858793632.pmd: Mini DuMP crash report, 13 streams, Mon Jul  4 11:39:18 2022, 0x6 type
```

Como es de costumbre usamos volatility3 para obtener información hacerca de la memoria RAM:

```bash
$> vol3 -f /data/3858793632.pmd banners.Banners
Volatility 3 Framework 2.5.0
Progress:  100.00               PDB scanning finished
Offset  Banner

$> vol3 -f /data/3858793632.pmd windows.info
Volatility 3 Framework 2.5.0
Unable to validate the plugin requirements: ['plugins.Info.kernel.layer_name', 'plugins.Info.kernel.symbol_table_name']

Unsatisfied requirement plugins.Info.kernel.layer_name:
Unsatisfied requirement plugins.Info.kernel.symbol_table_name:

A translation layer requirement was not fulfilled.  Please verify that:
        A file was provided to create this layer (by -f, --single-location or by config)
        The file exists and is readable
        The file is a valid memory image and was acquired cleanly

A symbol table requirement was not fulfilled.  Please verify that:
        The associated translation layer requirement was fulfilled
        You have the correct symbol file for the requirement
        The symbol file is under the correct directory or zip file
        The symbol file is named appropriately or contains the correct banner
```

Al obtener el error que os acabo de mostrar pasamos a usar volatility2, a ver si nos lo detecta mejor...

```bash
$> vol2 -f /data/3858793632.pmd imageinfo
Volatility Foundation Volatility Framework 2.6.1
INFO    : volatility.debug    : Determining profile based on KDBG search...
          Suggested Profile(s) : No suggestion (Instantiated with no profile)
                     AS Layer1 : FileAddressSpace (/data/3858793632.pmd)
                      PAE type : No PAE
```

Ignorando este hecho decidimos ver un poco más acerca de la captura de red, y nos encontramos con un samba2 encriptado... casualidad? viendo los registros podemos obtener:

```powershell
CORP\athomson
```

Un posible nombre de usuario, como tiene que ver con el .zip mencionado anteriormente decidi sacarlo manual, encontre el stream packet gracias al protocolo *FTP-Data*, sabiendo que tenemos un nombre de usuario y tenemos un volcado de memoria que no nos funciona volatility, usaremos la herramienta *mimikatz* para extraer posibles contraseñas, estando en windows abrimos mimikatz.exe, os dejo una mini mini guia de mimikatz para aprender lo basico:

- **cd** -> Change Directory y pwd
- **log archivo.log** -> Empieza la a recopilar toda la terminal en un archivo
- **log** -> Cerrar el log

En nuestra terminal ejecutaremos lo siguiente:

```mimikatz
sekurlsa::minidump 3858793632.pmd
sekurlsa::logonpasswords
```

Al guardar los logs se nos hace más fácil buscar la información en Visual Studio Code, donde filtraremos por el nombre de usuario: *athomson*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240521213922.png)

Y obtenemos las siguientes credenciales:

```c
Authentication Id : 0 ; 3857660 (00000000:003adcfc)
Session           : RemoteInteractive from 2
User Name         : athomson
Domain            : CORP
Logon Server      : CORP-DC
Logon Time        : 7/4/2022 1:32:10 PM
SID               : S-1-5-21-288640240-4143160774-4193478011-1110
    msv :  
     [00000003] Primary
     * Username : athomson
     * Domain   : CORP
     * NTLM     : 88d84bad705f61fcdea0d771301c3a7d
     * SHA1     : 60570041018a9e38fbee99a3e1f7bc18712018ba
     * DPAPI    : 022e4b6c4a40b4343b8371abbfa9a1a0
    tspkg :
    wdigest :  
     * Username : athomson
     * Domain   : CORP
     * Password : (null)
    kerberos :  
     * Username : athomson
     * Domain   : CORP.LOCAL
     * Password : (null)
    ssp :  
    credman :  
    cloudap :
```


Con una simple busqueda sobre como desencriptar el trafico samba de un pcap nos encontramos con el siguiente post:

https://medium.com/maverislabs/decrypting-smb3-traffic-with-just-a-pcap-absolutely-maybe-712ed23ff6a2

Que editando un poco el código que nos proporciona podemos ejecutar el siguiente comando:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240521224527.png)

Ahora con wireshark podemos meter un tipo de encriptado con la sessión key: `0x0000a00000000015` (visto justo el paquete donde menciona el user), y dentro de unos de los archivos exportados nos encontraremos un pdf con la contraseña en su interior:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240521224848.png)
