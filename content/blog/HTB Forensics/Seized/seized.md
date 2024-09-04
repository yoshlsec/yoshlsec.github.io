---
title: Seized
description: >
  HackTheBox Forensics Challenge - Medium<br>
  [Challenge Download](https://app.hackthebox.com/challenges/322)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium", "deobfuscation"]
---
---
# Enunciado del problema

Miyuki is now after a newly formed ransomware division which works for Longhir. This division's goal is to target any critical infrastructure and cause financial losses to their opponents. They never restore the encrypted files, even if the victim pays the ransom. This case is the number one priority for the team at the moment. Miyuki has seized the hard-drive of one of the members and it is believed that inside of which there may be credentials for the Ransomware's Dashboard. Given the AppData folder, can you retrieve the wanted credentials?

---
# Resolución

Como nos piden credenciales de un usuario, vamos a investigar sobre el registro de Google Chrome, para ello usamos el comando:

```bash
find Appdata -iname "Login Data" -exec cp "{}" .
```

Asi podemos copiar el archivo y tenerlo en un entorno de trabajo más cómodo. Con conocimientos básicos sobre Windows, sabemos que en el directorio: `AppData/Roaming/Microsoft/Protect` tenemos una masterkey encriptada que nos puede ayudar para dumpear la información encriptada por *DPAPI*, tipo de encriptado usado por los desarrolladores (Este tipo de encriptado también sirve para SAM
que lo podemos encontrar en el directorio: `C:\Windows\System32\LogFiles`, y suele tener los "tokens" de cada usuario, como un método de persistencia).

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240508200700.png)

La `master key` esta en: `S-1-5-21-3702016591-3723034727-1691771208-1002`, asique también la copiaremos en nuestro directorio de trabajo y pasaremos el formato a john para poder bruteforcearla:

Usaremos la herramienta: [DPAPImk2john.py](https://raw.githubusercontent.com/openwall/john/bleeding-jumbo/run/DPAPImk2john.py)

```bash
DPAPImk2john.py -S S-1-5-21-3702016591-3723034727-1691771208-1002 -mk tempdir/Protect/S-1-5-21-3702016591-3723034727-1691771208-1002/865be7a6-863c-4d73-ac9f-233f8734089d -c local> contracontra
john --wordlist=/usr/share/wordlists/rockyou.txt contracontra
```

Ahora usando la herramienta *dpapi.py* seremos capaz de obtener las contraseñas de chrome, usando la contraseña obtenida con el comando anterior: **ransom**:

```bash
dpapi.py masterkey -file tempdir/Protect/S-1-5-21-3702016591-3723034727-1691771208-1002/865be7a6-863c-4d73-ac9f-233f8734089d -sid S-1-5-21-3702016591-3723034727-1691771208-1002 -password ransom
```

Y terminaremos usando el siguiente script de python, *menciones a forensicskween*:

```python
import os
import json
import sqlite3
import base64
from impacket.dpapi import DPAPI_BLOB
from binascii import unhexlify
from Cryptodome.Cipher import AES

local_state = 'tempdir/Local State'
login_data = 'tempdir/Login Data'
masterkey = unhexlify("138f089556f32b87e53c5337c47f5f34746162db7fe9ef47f13a92c74897bf67e890bcf9c6a1d1f4cc5454f13fcecc1f9f910afb8e2441d8d3dbc3997794c630")

def get_encrypted_key(localstate):
    with open(localstate, 'r') as f:
        encrypted_key = json.load(f)['os_crypt']['encrypted_key']
        encrypted_key = base64.b64decode(encrypted_key)
    f.close()
    return encrypted_key

def get_credentials(logindata):
    conn = sqlite3.connect(logindata)
    cursor = conn.cursor()
    cursor.execute('SELECT action_url, username_value, password_value FROM logins')
    rows = cursor.fetchall()
    url = rows[0][0]
    username = rows[0][1]
    encrypted_value = rows[0][2]
    return url, username, encrypted_value

def decrypt_creds(key, value):
    if value.startswith(b'v10'):
        nonce = value[3:3+12]
        ciphertext = value[3+12:-16]
        tag = value[-16:]
        cipher = AES.new(key, AES.MODE_GCM, nonce)
        password = cipher.decrypt_and_verify(ciphertext, tag)
    else:
        password = DPAPI_BLOB.decrypt(value)
    return password

encrypted_key = get_encrypted_key(local_state)
enc_key_blob = DPAPI_BLOB(encrypted_key[5:])
localstate_key = enc_key_blob.decrypt(masterkey)
url, username, encrypted_value = get_credentials(login_data)
password = decrypt_creds(localstate_key, encrypted_value)
print(password.decode("utf-8"))
```

Flag: HTB{Br0ws3rs_C4nt_s4v3_y0u_n0w}