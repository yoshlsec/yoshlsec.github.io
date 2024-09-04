---
title: Free Services
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/320)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "deobfuscation", "macro", "olevba", "microsoft word"]
---

---
# Enunciado del problema

Intergalactic Federation stated that it managed to prevent a large-scale phishing campaign that targeted all space personnel across the galaxy. The enemy&#039;s goal was to add as many spaceships to their space-botnet as possible so they can conduct distributed destruction of intergalactic services (DDOIS) using their fleet. Since such a campaign can be easily detected and prevented, malicious actors have changed their tactics. As stated by officials, a new spear phishing campaign is underway aiming high value targets. Now Klaus asks your opinion about a mail it received from &quot;sales@unlockyourmind.gal&quot;, claiming that in their galaxy it is possible to recover it&#039;s memory back by following the steps contained in the attached file.

---

# Resolución

Pido disculpas adelantadas por la mala estructura que tendrá este writeup y la mala expresión verbal, estoy cansado pero no hay escusas para trabajar.

Como tenenos un archivo Word de 2007 le intentamos sacar los macros, nos detecta que hay algunos pero no nos dicen cuales:

```powershell
$> olevba.exe free_decryption.xlsm | grep -v "CELL"

Encoding for stdout is only cp1252, will auto-encode text with utf8 before output
olevba 0.60.1 on Python 3.11.9 - http://decalage.info/python/oletools
===============================================================================
FILE: free_decryption.xlsm
Type: OpenXML
-------------------------------------------------------------------------------
VBA MACRO xlm_macro.txt
in file: xlm_macro - OLE stream: 'xlm_macro'
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
' RAW EXCEL4/XLM MACRO FORMULAS:
' SHEET: Macro1, Macrosheet
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
' EMULATION - DEOBFUSCATED EXCEL4/XLM MACRO FORMULAS:
+----------+--------------------+---------------------------------------------+
|Type      |Keyword             |Description                                  |
+----------+--------------------+---------------------------------------------+
|Suspicious|CALL                |May call a DLL using Excel 4 Macros (XLM/XLF)|
|Suspicious|CreateThread        |May inject code into another process         |
|Suspicious|VirtualAlloc        |May inject code into another process         |
|Suspicious|WriteProcessMemory  |May inject code into another process         |
|Suspicious|XLM macro           |XLM macro found. It may contain malicious    |
|          |                    |code                                         |
+----------+--------------------+---------------------------------------------+
```

Ignoro las lineas que contengan *CELL* porque solo estorbaban... Podemos ver que esta llamando a un archivo DLL, como solo tenemos este archivo se me ocurre ver que hay en su interior...

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240511224538.png)

Tampoco vemos nada fuera de lo normal, pero me fijo en la única imagen del word y proceso a extraerla del archivo para hacerle esteganografia:


![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240511224711.png)

No tiene pinta de ser una imagen muy común... Viendo la cabecera de la imagen sabemos que es IDHR y el contenido de la imagen nos dice que editemos el contenido del word:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240511225542.png)

Y si abrimos el documento aparte de ver la imagen anteriormente mencionada vemos este archivo que nos llama la anteción las columnas: *E, F y G*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240511230319.png)

Asique creamos un script in python para obtener ese resultado, viendo un poco por encima... veo que esta xoreado con 24,  esto lo sabemos porque con el *olevba* que vimos antes me fije más en lo de CELL, que viene de celda, y de ahi, los valores y que una linea muy curiosa:

```cleartext
CELL:A5, =SET.VALUE(B1,CHAR(_xlfn.BITXOR(ACTIVE.CELL(),24))), #N/A
```

entonces creo este scirpt de python para que me de la string:

```python
import pandas
column_names = ['A','B','C','D','E','F','G']
df = pandas.read_csv("macro1.csv", names=column_names)

df['E'] = df['E'].astype("Int64")
df['F'] = df['F'].astype("Int64")
df['G'] = df['G'].astype("Int64")
df.F[257] = 0
df.G[257] = 0

xored_dict = []
for idx, rows in df.iterrows():
    xored_dict.append(df.loc[idx, 'E'] ^ 24)
    xored_dict.append(df.loc[idx, 'F'] ^ 24
    xored_dict.append(df.loc[idx, 'G'] ^ 24)

''.join(chr(i) for i in xored_dict)
```

El cual me da un comando que tiene caracteres que sobran como puede ser: `\x`, con la magia de python lo quitamos de en medio y sacamos la flag:

```python
chars= [chr(i) for i in xored_dict]
print(''.join(chars[::2]))
```

