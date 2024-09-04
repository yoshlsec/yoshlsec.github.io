---
title: endianness-v2
description: >
  PicoCTF Forensics Challenge - Medium
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","medium","picoctf2024", "script"]
---

---
# Enunciado del problema

Here's a file that was recovered from a 32-bits system that organized the bytes a weird way. We're not even sure what type of file it is. Download it [here](https://artifacts.picoctf.net/c_titan/37/challengefile) and see what you can get out of it

---
# Resolución


Teniendo el archivo, vemos que no es reconocido por la herramienta: *file* pero viendo los metadatos descubrimos que es un archivo formato imagen *jpeg*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240822192211.png)

Buscando en google acerca de las cabeceras del formato de archivo nos damos cuenta que los bytes estan dados la vuelta:
`E0 FF D8 FF -> FF d8 FF E0` 

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240822192527.png)

Buscando un poco más de información vemos que a la hora de pasar *little endian* (x86) a *big endian* (x64) sufre ligeros cambios los hexadecimales del archivo, para pivotar de un endian a otro habrá que hacer un *byteswap*  y *reverse string* a los bits, esto por cada palabra del archivo, para entender todo esto que acabamos de decir os dejo este pequeño esquema para diferenciar entre bit, byte y palabra:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240823120742.png)

Podemos hacer todo lo que queremos en ensamblardor con la función *bswap* aquí un pequeño ejemplo:

```asm
lw $t0, 0($a0) ; Cargar de la memoria
bwswap $t0, $t0 ; Byte swap
sw $t0, 0($a0) ; Guardar en la memoria
```

Esto lo podemos pasar de muchas maneras a python, aquí veremos solo dos tipos, con la librería: **struct** y con la *built-in* function **bytearray()**:

#### Struct module

```python
import struct

with open('challengefile', 'rb') as f:
    _data = f.read()

num_words = len(_data) // 4
remainder = len(_data) % 4

unpacked__data = struct.unpack('<' + 'I' * num_words, _data[:num_words * 4])
packed__data = struct.pack('>' + 'I' * num_words, *unpacked__data)
packed__data += _data[num_words * 4:]

with open('flag.jpg', 'wb') as f:
    f.write(packed__data)
```

#### Bytearray

```python
_in, _name = ('challengefile', 'flag.jpg')
_out = open(_name, 'wb')

with open(_in, 'rb') as f:
    while True:
        chunk = f.read(4096)
        if not chunk:
            break
        
        output_data = bytearray()
        
        for i in range(0, len(chunk), 4):
            block = chunk[i:i + 4]
            reversed_block = block[::-1]
            output_data.extend(reversed_block)

        _out.write(output_data)
```

Una vez hecho esto podemos comprobar que el archivo esta bien colocado podemos abrir el archivo y encontrar la flag:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240823121406.png)