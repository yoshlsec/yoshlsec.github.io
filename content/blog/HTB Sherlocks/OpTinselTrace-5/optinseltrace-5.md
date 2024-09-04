---
title: OpTinselTrace-5
description: >
  HackTheBox Sherlocks - Hard<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/OpTinselTrace-5)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","hard","sherlock", "wireshark"]
---

---
### Enunciado del problema

You'll notice a lot of our critical server infrastructure was recently transferred from the domain of our MSSP - Forela.local over to Northpole.local. We actually managed to purchase some second-hand servers from the MSSP who have confirmed they are as secure as Christmas is! It seems not as we believe Christmas is doomed and the attackers seemed to have the stealth of a clattering sleigh bell, or they didn’t want to hide at all!!!!!! We have found nasty notes from the Grinch on all of our TinkerTech workstations and servers! Christmas seems doomed. Please help us recover from whoever committed this naughty attack! Please note - these Sherlocks are built to be completed sequentially and in order!

---

Nos piden la contraseña del ransomware dado para poder ver una imagen encriptada, nada más el archivo con ida vemos que es un ransomware que usa XOR:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503185516.png

Como en ida no vimos nada nos fuimos a binaryninja donde nos llamo la atención una string... `EncryptingC4Fun!`

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503190021.png

Nos fuimos a cyberchef y pusimos esta clave como contraseña de XOR.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503190153.png

Y como vemos nos aparece un unicornio... si lo metemos como respuesta lo tenemos bien!!!

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240503190220.png

---
Usando **Hayabusa**. **Timeline Explorer** y un par de busquedas en google obtenemos desde la primera hasta la cuarta pregunta

