---
title: UnforgottenBits
description: >
  PicoCTF Forensics Challenge - Hard
date: 2024-05-08
weight: 10
tags: ["picoctf","forensics","hard","picoctf2023", "disk"]
---
---
# Enunciado del problema

Download this disk image and find the flag. Note: if you are using the webshell, download and extract the disk image into `/tmp` not your home directory.

- [Download compressed disk image](https://artifacts.picoctf.net/c/488/disk.flag.img.gz)

---
# Resolución

Aun no he empezado el reto pero estoy ilusionado de tocar retos relacionados con discos, con experiencia de otros retos recuerdo el comando: *nnls* para listar las unidades del disco, aquí podemos ver que estamos frente a un Solaris x86:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619172317.png)

Y bueno, ya para verificar usamos el comando *file*:

```bash
$> file disk.flag.img

disk.flag.img: DOS/MBR boot sector; partition 1 : ID=0x83, active, start-CHS (0x0,32,33), end-CHS (0xc,223,19), startsector 2048, 204800 sectors; partition 2 : ID=0x82, start-CHS (0xc,223,20), end-CHS (0x2d,130,21), startsector 206848, 524288 sectors; partition 3 : ID=0x83, start-CHS (0x2d,130,22), end-CHS (0x82,138,8), startsector 731136, 1366016 sectors
```

Cuando intentamos montar el disco en windows tenemos un error, porque el archivo esta corrupto:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619172500.png)

Buscando en google podemos ver que los magic numbers de este formato de archivo es: 0xAA55, pero no cambia nada, entonces procedemos a abrir autopsy, pero curiosamente da un error cuando intenta cargar la particiñón mencionada antes: Linux Swap / Solaris x86... me suena que vamos a tener que dividir el disco para cargar solo una parte... pero primero hay que ver el disco:

```
Errors occurred while ingesting image 
1. Cannot determine file system type (Sector offset: 206848, Partition Type: Linux Swap / Solaris x86 (0x82)) 
```

El disco como hemos visto al principio esta separado por 4 volumes, el primero esta "Unallocated" que puedo suponer que estamos hablando de un archivo que esta entre ese espacio de memoria que no carga el ordenador... 

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619173619.png)

Pero viendo el volumen de linux podemos encontrar un par de pistas como en el home de **yone**, aqui encontramos 3 archivos txt que contienen las siguientes palabras:

_Path: /home/yone/notes/_

```bash
1.txt
chizazerite

2.txt
guldulheen

3.txt
I keep forgetting this, but it starts like: yasuoaatrox...
```

Tambien podemos encontrar el siguiente email que recibio: yone:

_Path: /home/yune/Maildir/new/_

```bash
subject: Deleting emails
to: Sten Walker <yone786@gmail.com>
from: Bob Bobberson <azerite17@gmail.com>

Yone,

This is just a reminder to delete all of our emails and scrub your trash can as well. We don't want our precious light falling into the wrong hands. You know the punishment for such 'crimes'.

To the Light and All it reveals,
- The Azerite Master
```

Sabiendo que yone ha eliminado unos emails podemos ver si siguen estando por la carpeta *./Maildir/cur*. Estamos en lo cierto pero no es de mucha ayuda... encontramos varios emails, todos relacionados con un premio de, puede ser, un torneo o campeonato, pero al grano hay 3 emails borrados, 2 no tienen contenido visible y el último tiene las palabras:

_Path: /home/yune/Maildir/cur/_
```bash
su root
```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619174533.png)

Viendo que tanto en el correo como en una de las notas de yune, se esta loggeando como root, nos vamos al directorio root y vemos su ._bash_history_, Y... solo tiene dos comandos...

_Path: /root/.bash_history_
```bash
ls -al
halt
```

Buscando en google el comando: *halt* vemos que es un comando para apagar el dispositivo de manera forzosa sin importar que procesos estén ejecutandose, por eso puede haber un apartado del volumen en estado: "Unallocated".

> The HALT command **forces an abrupt shutdown, which cancels all the administrative and client node sessions even if they are not completed**.

Como no vemos nada más en el directorio root, volvemos a _/home/yune_ donde estamos sacando mucha información y vemos unos los de irc, aplicación que se usaba en 1990-2000s para jugar a videojuegos, básicamente un discord antiguo. 

Empezamos leyendo el primer log:

_Path: /home/yune/irclogs/01/04/#avidreader13.log_
```bash
[08:12] <yone786> Ok, let me give you the keys for the light.
[08:12] <avidreader13> I’m ready.
[08:15] <yone786> First it’s steghide.
[08:15] <yone786> Use password: akalibardzyratrundle
[08:16] <avidreader13> Huh, is that a different language?
[08:18] <yone786> Not really, don’t worry about it.
[08:18] <yone786> The next is the encryption. Use openssl, AES, cbc.
[08:19] <yone786> salt=0f3fa17eeacd53a9 key=58593a7522257f2a95cce9a68886ff78546784ad7db4473dbd91aecd9eefd508 iv=7a12fd4dc1898efcd997a1b9496e7591
[08:19] <avidreader13> Damn! Ever heard of passphrases?
[08:19] <yone786> Don’t trust em. I seed my crypto keys with uuids.
[08:20] <avidreader13> Ok, I get it, you’re paranoid.
[08:20] <avidreader13> But I have no idea if that would work.
[08:21] <yone786> Haha, I’m not paranoid. I know you’re not a good hacker dude.
[08:21] <avidreader13> Is there a better way?
[08:22] * yone786 yawns.
[08:24] <yone786> You’re ok at hacking. I’m good at writing code and using it
[08:24] <avidreader13> What language are you writing in?
[08:26] <yone786> C
[08:26] <avidreader13> Oh, I see.
[08:26] <yone786> I’m glad you like it. I’m sure you wouldn’t understand half of what I was doing.
[08:28] <avidreader13> I understand enough, but I do wish you wouldn’t take so much time with it.
[08:28] <yone786> Sorry. Well, I wish you could learn some things.
[08:29] <avidreader13> But it’s an incredible amount of time you spend on it.
[08:29] <yone786> Haha, don’t take it like that.
```

En pocas palabras, es una conversación entre yune y un compañero suyo, supuesto hacker, que le esta pasando las credenciales y los pasos para sacar información un archivo... aun no os he comentado acerca de un directorio *gallery* pero tiene pinta que es por esos tiros.

Aquí las credenciales estructuradas:

```bash
Steghide password: akalibardzyratrundle

Openssl AES CBC
salt: 0f3fa17eeacd53a9
key: 58593a7522257f2a95cce9a68886ff78546784ad7db4473dbd91aecd9eefd508
iv: 7a12fd4dc1898efcd997a1b9496e7591
```

Hay otros muchos archivos logs:
- _02/04/leagueoflegends.log_: Conversación entre un indio y yone acerca de un pago de un código, nada importante. [21:23-21:30]
- _02/07/leagueoflegends.log_: Conversación entre los mismos del *02/04*, nada importante. [21:25-21:35]
- _02/09/leagueoflegends_: Conversación fuera de contexto con la misma gente que los otros 2 registros, a lo mejor entran terceras personas pero nada destacable. [21:24-21:34]
- *07/17/common.log*: Conversación acerca de "light" y unos emails, pero no nos dicen nada de información relevante. [15:28-18:19]

Ahora como ya os he comentado podemos entrar en el directorio: *gallery* donde encontraremos 4 imagenes, 3 de ellas que están marcadas como: 
	_Has an likely notable analisys result score_

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619181204.png)

Asique dicho esto procedemos a recuperar todas las imagenes, una vez extraidas las imagenes podemos empezar a usar binwalk y otras herramientas para verificar si tienen algun archivo oculto o no:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619182547.png)

Y usando binwalk no vemos nada que llame mucho la anteción, cosas como el firmware y microcodes... sinceramente no se si estoy de verdad sirve de algo o no:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619182715.png)

Centrandonos en el objetivo, usaremos el comando steghide con la contraseña: `akalibardzyratrundle`, y wow sinceramente que suerte tuve de sacar a la primera el archivo con contenido dentro, en este caso fue el archivo: *154-2.bmp* donde si usamos el comando:

```bash
steghide extract -sf 154-2.bmp --passphrase akalibardzyratrundle
```

Nos devolvera un archivo llamado: **dracula.txt.enc**, que no hace falta ser genios que tenemos que usar el comando: *openssl* para descodearlo, yo como no se usarlo, usare cyberchef:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619183250.png)

Que nos detecta un archivo txt, para más comodidad lo descargamos y lo leemos en nuestra terminal.... y no es nada más que el libro de dracula de Bram Stoker, asique vamos a probar con el resto de imagenes, y desgraciadamente no se encuentra la flag en ninguna de las 3 imagenes, son todos libros... una de ellas nos dice que la contraseña es incorrecta y nos hace pensar que tiene que ver con una contraseña que empieza por: `yasuoaatrox` de archivo: *3.txt*

Sacamos conclusiones que la contraseña puede ser el nombre de un jugador del lol, entonces buscando en google encontramos un listado, y haciendo un pequeño bruteforce gracias a chatgpt, podemos encontrar que la contraseña es: `yasuoaatroxashecassiopeia`:

```bash
$> openssl enc -d -aes256 -in ledger.1.txt.enc -out ledger.1.txt -S 0f3fa17eeacd53a9 -K 58593a7522257f2a95cce9a68886ff78546784ad7db4473dbd91aecd9eefd508 -iv 7a12fd4dc1898efcd997a1b9496e7591

bad decrypt
80CB1BA9757F0000:error:1C800064:Provider routines:ossl_cipher_unpadblock:bad decrypt:../providers/implementations/ciphers/ciphercommon_block.c:124:
```

Pero al hacerlo nos da un error, buscando con el filtro de autopsy palabras como key, iv... palabras que nos puedan ayudar nada interesante, entonces como mencione al principio del writeup puede tener algo que ver con el espacio: "Unallocated" también conocido como slacks en la memoria, entonces lo buscamos desde autopsy

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619185042.png)

Y pues simplemente a buscar, no tardamos en darnos cuenta que el slack que estamos buscando es el del archivo: *1.txt*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619185234.png)

Si tienes curiosidad los slack son nombrados de la siguiente manera: `<archivo>-slack`. Yendo al grano, este tipo de formato lo hemos visto en el archivo de browser.log del directorio Lynk.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/PicoCTF/Forensics/Pasted%20image%2020240619185524.png)

Con el siguiente código en python podemos sacar de phinario a ascii:


```python
from math import ceil  
from scipy.constants import golden  
  
def phinary_to_decimal(phigit):  
    integer, fraction = phigit.split(".")  
    integer = integer[::-1]
  
    number = 0  
  
    for i, x in enumerate(integer):  
        if x == "1":  
            number = number + golden ** (i)  
    for i, x in enumerate(fraction):  
        if x == "1":  
            number = number + golden ** -(i+1)  
      
    return number  
  
if __name__ == "__main__":  
    with open("phinario.txt") as f:  
        string = f.read()  
        string = string.rstrip("\n")  
      
    #Split string every 15th character  
    phigits = [string[i: i + 15] for i in range(0, len(string), 15)]  
      
    decoded_phi = []  
  
    for phigit in phigits:  
        decoded_phi.append(ceil(phinary_to_decimal(phigit)))  
  
    print(''.join(map(chr,decoded_phi)))
```

El output nos daría:

```bash
$> python3 phi_decoder.py  

salt=2350e88cbeaf16c9  
key=a9f86b874bd927057a05408d274ee3a88a83ad972217b81fdc2bb8e8ca8736da  
iv=908458e48fc8db1c5a46f18f0feb119f
```

Que volviendo a usar openssl o cyberchef nos devolverá el siguiente texto:

```cleartext
avidreader13                                                 PAID
    Les Mis, Dracula, Frankenstein, Swiss Family
    Robinson, Don Quixote, A Tale of Two Cities

513u7h                                                       PAID
    Don Quixote

masterOfSp1n                                                 PAID
    Swiss Family Robinson, A Tale of Two Cities

AwolCoyote                                                   PAID
    Les Mis, Dracula

picoCTF                                                    UNPAID
    picoCTF{f473_53413d_8a5065d1}
```