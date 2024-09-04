---
title: Export
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/159)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "volatility"]
---

---
# Enunciado del problema

Saber quien se conecto al servidor mediante la información de un volcado de memoria en un archivo *.raw*

---
# Resolución

### Docker preparation
Para esto necesitaremos instalarnos el docker y la siguiente imagen: https://hub.docker.com/r/blacktop/volatility

```docker
docker pull blacktop/volatility
```

Una vez con la imagen pondremos un alias para usar el comando:
```bash
alias vol='docker run -it --rm -v $(pwd):/data:ro blacktop/volatility $@'
```

### Obteniendo el user
Teniendo el archivo con extensión *.raw* vamos a usar el comando *vol* para obtener un poco más de información acerca de los últimos usuarios que modificaron el archivo:
```bash
vol imageinfo -f ./WIN-LQS146OE2S1-20201027-142607.raw
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/imageinfo.png.png)

Y vemos que el último usuario que modifico el archivo es *Win7SP1x64* asi que veamos que comandos usó.

### Viendo logs de los comandos
Para esto tendremos que especificar el usuario y el pluging:
```bash
vol -f ./WIN-LQS146OE2S1-20201027-142607.raw --profile=Win7SP1x64 cmdscan
```

Con el pluging *cmdscan* podemos ver el logs de la *cmd* también dicha la consola.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/cmdscan.png.png)

Lo que podemos identificar es la ruta del ejecutable de la powershell (*.ps1*) que la llevaremos a cyberchef para ver el texto plano.

## CyberChef
Podemos ver que es un link acortado que tiene otro texto encriptado

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/WriteUps/BlueUps/Export/cybercheff1.png.png)

Y este texto vemos que tiene la flag, encriptada en *Base64*

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020231015131211.png)

Y la flag es: *HTB{W1Nd0ws_f0r3Ns1CS_3H?}*
