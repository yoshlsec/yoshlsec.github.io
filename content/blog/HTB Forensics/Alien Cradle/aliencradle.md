---
title: Alien Cradle
description: >
  HackTheBox Forensics Challenge - Very Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/Alien%2520Cradle)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","very easy", "deobfuscation"]
---

----

# Enunciado del problema
*In an attempt for the aliens to find more information about the relic, they launched an attack targeting Pandora's close friends and partners that may know any secret information about it. During a recent incident believed to be operated by them, Pandora located a weird PowerShell script from the event logs, otherwise called PowerShell cradle. These scripts are usually used to download and execute the next stage of the attack. However, it seems obfuscated, and Pandora cannot understand it. Can you help her deobfuscate it?*

----

# Resolución
Al hacer un *Get-Content/batcat* a nuestro archivo, podemos ver que tiene asignada una variable **f** que tiene el continedo de la flag, para ello exportaremos esa variable y la mostraremos para tener la flag en una sola pieza.

![AlienCradler.png.png](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/AlienCradler.png.png)

