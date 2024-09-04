---
title: One Of Us
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/439)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "macro", "olevba", "microsoft word"]
---

---
# Enunciado del problema

Dark Pointy Hats are causing trouble again. This time, they have targeted Invisible Shields and the protectors of the forbidden spells. They developed a specific spyware that aims to get access to the forbidden spells server. We managed to retrieve a sample of the spyware and suspicious mail that seems to be produced by the spyware. Can you analyze the provided files and find out what happened?

---
# Resolución

Nos dan el siguiente email junto a un documento word:

```xml
$> cat mail.txt

From: Austin <taustin@whschool.com>
To: dph@whschool.com
Subject: Outlook Exfiltration Data from User: taustin


*twGsy*#p7XY8CT4N3RpGq5xDzL7EMHW|F02fGjYTWhdk3JYn2nntOcU56fnU0YD4prneoaPxbsNIcMgcwsFFGWifg7tNNkohHj9nZRTWJDg/BcnUpTuKynaTtMg9fnOnhjYmg++Q6pklR9Zt0s2vzVu2FMJxO+xBaQrONSPvPg5sd2qRtAkrCa4ikKuKwg38QA7v+wseZRrx37P2sIiellwVcWFMRQCZtlE6bdN14JKmXn+GeXFIP51KHOCR3qd34NgzcGuLySbH9ZGzldLZWagnIcAFKTP9
```

El documento word, como era de esperar, tiene un macro y esta relacionado con XOR

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240517185034.png)

Dentro del doc encontramos:

```powershell
Path = .\invisible_shields.docm
Type = zip
Physical Size = 270726

   Date      Time    Attr         Size   Compressed  Name
------------------- ----- ------------ ------------  ------------------------
1980-01-01 00:00:00 .....         1635          426  [Content_Types].xml
1980-01-01 00:00:00 .....          590          239  _rels\.rels
1980-01-01 00:00:00 .....         4625         1396  word\document.xml
1980-01-01 00:00:00 .....         1213          321  word\_rels\document.xml.rels
1980-01-01 00:00:00 .....       129024        37102  word\vbaProject.bin
1980-01-01 00:00:00 .....       217336       217336  word\media\image1.png
1980-01-01 00:00:00 .....         8393         1746  word\theme\theme1.xml
1980-01-01 00:00:00 .....          277          191  word\_rels\vbaProject.bin.rels
1980-01-01 00:00:00 .....         2625          648  word\vbaData.xml
1980-01-01 00:00:00 .....         4144         1921  word\settings.xml
1980-01-01 00:00:00 .....          289          183  customXml\item1.xml
1980-01-01 00:00:00 .....          341          225  customXml\itemProps1.xml
1980-01-01 00:00:00 .....        29455         2947  word\styles.xml
1980-01-01 00:00:00 .....          894          334  word\webSettings.xml
1980-01-01 00:00:00 .....         1658          495  word\fontTable.xml
1980-01-01 00:00:00 .....          635          339  docProps\core.xml
1980-01-01 00:00:00 .....          710          365  docProps\app.xml
1980-01-01 00:00:00 .....          296          194  customXml\_rels\item1.xml.rels
------------------- ----- ------------ ------------  ------------------------
1980-01-01 00:00:00             404140       266408  18 files
```

