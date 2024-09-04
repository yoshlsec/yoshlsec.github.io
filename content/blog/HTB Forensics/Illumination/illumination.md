---
title: Illumination
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/87)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "logs"]
---

---
# Enunciado del problema
A Junior Developer just switched to a new source control platform. Can you find the secret token?
---
# Resolución
### Viendo los logs de Git
Nada más descomprimido el archivo podemos ver que esta la carpeta *.git*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/gitls.png.png)

Haciendo un *git log* vemos que hay varios cambios:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/listalogs.png.png)

Fijandonos en los comentarios que dejan los programadores que hicieron cambios vemos que en uno nos menciona acerca de un token...

```bash
Thanks to contributors, I removed the unique token as it was a security risk. Thanks for reporting responsibly!
```

### Viendo detalles del log
Para ver más información sobre el cambio podemos hacer un **git show** al identificador, en este caso: **47241a47f62ada864ec74bd6dedc4d33f4374699**:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/obteneridlog.png.png)

Ahora si, vamos a ver más a fondo este log:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/loginfo.png.png)

Y vemos que el token: **SFRCe3YzcnNpMG5fYzBudHIwbF9hbV9JX3JpZ2h0P30=** encriptado en *Base64*, para ver su contenido en texto legible usaremos el comando de linux **base64 -d**:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/flagoutput.png.png)

Y ya tendríamos nuestra flag: HTB{v3rsi0n_c0ntr0l_am_I_right?}*