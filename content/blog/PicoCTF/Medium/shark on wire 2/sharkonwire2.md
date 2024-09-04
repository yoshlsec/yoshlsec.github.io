---
title: shark on wire 2
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2019", "wireshark"]
---
---
# Enunciado del problema

We found this [packet capture](https://jupiter.challenges.picoctf.org/static/b506393b6f9d53b94011df000c534759/capture.pcap). Recover the flag that was pilfered from the network.

---
# Resolución

Dentro de los paquetes UDP, podemos encontrar mensajes como estos:

```
icoCTF{StaT31355e
```

```
I really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flagsI really want to find some picoCTF flags
```

```
fjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdnfjdsakf;lankeflksanlkfdn
```

Encontramos una conversación por el puerto 22 udp, que nos llama la atención por el formato que tiene, empezando por un *start* y terminando con *end*. Entre los dos paquetes encontramos muchas letras, entre ellas: `C T F { }`.

Esto lo podemos saber porque obteniendo el valor de *data* de cada paquete y transformandolo del hexadecimal obtenemos lo que queremos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240823230222.png)

Para mayor comodidad exportaremos el filtro en un nuevo archivo .pcap, para eso buscaremos en el apartado de *File* donde dice: *Export Specified Packlets*. Ahora con **thsark** podemos sacar todos los valores en hexadecimal:

```bash
tshark -r hexcontent.pcap -T fields -e data
```

Tras mirar profundamente dentor de los paquetes, porque lo dicho anteriormente daba solo letras *a* sin sentido, decidi fijarme en los numeros de los puertos udp, y darme cuenta que podian tener un valor en ascii, entonces modifique un poco el comando de whireshark para filtrar por el numero de puerto:

```bash
tshark -r hexcontent.pcap -T fields -e udp.srcport | sed 's/^5//'
```

Con lo obtenido lo pase  a una página de ASCII to text y obtuve la flag:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240823232235.png)

