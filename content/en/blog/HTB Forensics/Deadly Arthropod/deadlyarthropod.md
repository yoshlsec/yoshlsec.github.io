---
title: Deadly Arthropod
description: >
  HackTheBox Forensics Challenge - Easy<br>
  [Challenge Download](https://app.hackthebox.com/challenges/36)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy", "wireshark", "esolang", "tshark"]
---

---
# Enunciado del problema

Our operatives have intercepted critical information. Origin? Classified. <br>Objective: Retrieve the flag!

---
# Resolución

Aun no se que hay que hacer en este pcap de USB, pero me doy cuenta que hay archivos que contienen **HID Data**, con tshark vamos a filtrar por este campo y recoger toda la información en un archivo:

```tshark
tshark -r deadly_arthropod.pcap -T fields -e usbhid.data > data
```



Y ahora en ese mismo archivo usaremos este script en python para sacar la información:

```python
import sys

usb_codes = {
   0x04:"aA", 0x05:"bB", 0x06:"cC", 0x07:"dD", 0x08:"eE", 0x09:"fF",
   0x0A:"gG", 0x0B:"hH", 0x0C:"iI", 0x0D:"jJ", 0x0E:"kK", 0x0F:"lL",
   0x10:"mM", 0x11:"nN", 0x12:"oO", 0x13:"pP", 0x14:"qQ", 0x15:"rR",
   0x16:"sS", 0x17:"tT", 0x18:"uU", 0x19:"vV", 0x1A:"wW", 0x1B:"xX",
   0x1C:"yY", 0x1D:"zZ", 0x1E:"1!", 0x1F:"2@", 0x20:"3#", 0x21:"4$",
   0x22:"5%", 0x23:"6^", 0x24:"7&", 0x25:"8*", 0x26:"9(", 0x27:"0)",
   0x2C:"  ", 0x2D:"-_", 0x2E:"=+", 0x2F:"[{", 0x30:"]}",  0x32:"#~",
   0x33:";:", 0x34:"'\"",  0x36:",<",  0x37:".>", 0x4f:">", 0x50:"<"
   }
lines = ["","","","",""]

pos = 0
print('')
for x in open(sys.argv[1],"r").readlines():
    if ':' not in x:
        x = ':'.join(a+b for a,b in zip(x[::2], x[1::2]))

    code = int(x[6:8],16)

    if code == 0:
        continue
    # newline or down arrow - move down
    if code == 0x51 or code == 0x28:
        pos += 1
        continue
    # up arrow - move up
    if code == 0x52:
        pos -= 1
        continue
    # select the character based on the Shift key
    if int(x[0:2],16) == 2:
        lines[pos] += usb_codes[code][1]
    else:
        lines[pos] += usb_codes[code][0]

for x in lines:
    if x: print(x)

print('')
```

Que nos dara el siguiente output:

```cleartext
eks@hackthebox.eu
Th1sC0uldB3MyR3alP@ssw0rd
QK<_>.<<<<H>5<<{_<I>>ck>'>>b0<<<<<<<<<I<<<<T>>f>>>>>>_>>>>>>}<.<.<<<<3<<<<<<<<u<<t_>>a<<<<<<<<<<B>>>>>>>>>>>>>>t>5<<<I>>>_>>>>>a<<<<<<a>>>>>>d<<<<y>>>r
```

Y por último este python script para dejar en texto plano el resultado del comando anterior:

```python
import sys

in_str = sys.argv[1]
output = []
index = 0

for x in in_str:
    if '<' in x:
        index -= 1
    elif '>' in x:
        index += 1
    else:
        output.insert(index, x)
        index += 1

print('\nOutput:')
print(''.join(output) + '\n')
```

Output:
```java
HTB{If_It_Quack5_It'5_a_K3yb0ard...}
```