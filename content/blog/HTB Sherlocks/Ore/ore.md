---
title: Ore
description: >
  HackTheBox Sherlocks - Medium<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/ore)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","medium","sherlock", "wireshark"]
---


---
### Enunciado del problema

One of our technical partners are currently managing our AWS infrastructure. We requested the deployment of some technology into the cloud. The solution proposed was an EC2 instance hosting the Grafana application. Not too long after the EC2 was deployed the CPU usage ended up sitting at a continuous 98%+ for a process named "xmrig". Important Information Our organisation's office public facing IP is 86.5.206.121, upon the deployment of the application we carried out some basic vulnerability testing and maintenance.

---

##### Which CVE lead to the initial compromise of the EC2? -> CVE-2021-43798

Nos metemos dentro de: `/usr/share/grafana/` y leyendo `VERSION` podemos saber que estamos frente a un grafana 8.2.0, si lo buscamos en google, la primera página web recomendable es un CVE con exploit incluido:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505204752.png)

##### Which account to the TA utilise to authenticate to the host OS? -> grafana

Es el mismo sistema operativo que la primera pregunta.

##### Where was the crypto mining binary & config file initially downloaded to? -> /opt/automation

En el historial de comandos de root encontramos como crean al usuario *grafana* y la creación de un nuevo archivo en un nuevo directorio

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505210112.png)

---
No tiene que ver aun con ninguna respuesta pero vemos en: `/usr/share/grafana`(home de grafana) como se conecta a una IP con nc: `nc 44.204.18.94 80`, además vemos este archivo con más IPs que nos pueden servir en un futuro:

###### Please detail all malicious IP addresses used by the threat actor (TA) targeting our organisation. -> 44.204.18.94,95.181.232.32,195.80.150.137

```bash
$> cat ip-172-31-13-147-20221124-1501-last-btmp.txt 

root     ssh:notty    Thu Nov 24 14:59:41 2022   gone - no logout                      61.177.172.145
root     ssh:notty    Thu Nov 24 14:59:38 2022 - Thu Nov 24 14:59:41 2022  (00:00)     61.177.172.145
root     ssh:notty    Thu Nov 24 14:59:36 2022 - Thu Nov 24 14:59:38 2022  (00:00)     61.177.172.145
admin    ssh:notty    Thu Nov 24 08:18:33 2022 - Thu Nov 24 14:59:36 2022  (06:41)     180.32.133.115
admin    ssh:notty    Thu Nov 24 08:18:31 2022 - Thu Nov 24 08:18:33 2022  (00:00)     180.32.133.115
grafana  ssh:notty    Wed Nov 23 11:17:07 2022 - Thu Nov 24 08:18:31 2022  (21:01)     195.80.150.137
admin    ssh:notty    Wed Nov 23 01:08:25 2022 - Wed Nov 23 10:20:32 2022  (09:12)     118.34.123.43
username ssh:notty    Tue Nov 22 23:06:04 2022 - Wed Nov 23 01:08:25 2022  (02:02)     18.206.177.8
admin    ssh:notty    Tue Nov 22 18:47:22 2022 - Tue Nov 22 23:06:04 2022  (04:18)     121.154.69.21
pi       ssh:notty    Tue Nov 22 18:45:06 2022 - Tue Nov 22 18:47:22 2022  (00:02)     86.9.201.96
pi       ssh:notty    Tue Nov 22 18:45:06 2022 - Tue Nov 22 18:45:06 2022  (00:00)     86.9.201.96
admin    ssh:notty    Tue Nov 22 16:05:27 2022 - Tue Nov 22 18:45:06 2022  (02:39)     14.47.57.72

btmp begins Tue Nov 22 16:05:27 2022
```


Una ip que se repite aparte de `44.204.18.94 80` es `195.80.150.137` que aparecen en los logs de *grafana* registrandose como admin, también encontramos a la ip: `95.181.232.32` haciendo lo mismo y path traversal

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505222006.png)

---

##### We couldn't locate the crypto mining binary and configuration file in the original download location. Where did the TA move them to on the file system? -> /usr/share/.logstxt/

Si nos dirigimos a: `/catscale_out/Process_and_Network` y buscamos sobre el proceso que consume mucha CPU (que lo vamos a considerar el minero de criptomonedas), nos aparecerá que root ejecuta este comando en el directorio indicado.

```bash
$> strings *.txt | grep xmrig                      

/usr/share/.logstxt/xmrig
Name:	xmrig
root      1089     1 2829088 9944 ?        Ssl  14:32 00:29:28 /usr/share/.logstxt/xmrig -c /usr/share/.logstxt/config.json -- threads=0
lrwxrwxrwx 1 root             root             0 Nov 24 14:46 /proc/1089/exe -> /usr/share/.logstxt/xmrig
lr-------- 1 root   root   64 Nov 24 15:01 /proc/1089/map_files/400000-c37000 -> /usr/share/.logstxt/xmrig
lr-------- 1 root   root   64 Nov 24 15:01 /proc/1089/map_files/e37000-e6b000 -> /usr/share/.logstxt/xmrig
lr-------- 1 root   root   64 Nov 24 15:01 /proc/1089/map_files/e6b000-e79000 -> /usr/share/.logstxt/xmrig
lr-------- 1 root root 64 Nov 24 15:01 400000-c37000 -> /usr/share/.logstxt/xmrig
lr-------- 1 root root 64 Nov 24 15:01 e37000-e6b000 -> /usr/share/.logstxt/xmrig
lr-------- 1 root root 64 Nov 24 15:01 e6b000-e79000 -> /usr/share/.logstxt/xmrig
u_strESTAB  0      0                                               * 20361                                                 * 21634                               users:(("xmrig",pid=1089,fd=2),("xmrig",pid=1089,fd=1)) -->                    
tcp  ESTAB  0      0                                   172.31.13.147:56150                                     141.95.126.31:10191                               users:(("xmrig",pid=1089,fd=13)) timer:(keepalive,18sec,0) ino:22930 sk:a9 <-> 

```

##### Which file did the TA modify in order to escalate privileges and run the mining service as "root"? -> /opt/automation/updater.sh

Como sabemos que el minero se creo en `/opt/automation` lo podemos relacionar con `updater.sh`, también porque no suele ser normal y común poner los permisos máximos a un archivo creado por root, como sabemos que esta pivotando entre root y grafana, ahora miraremos en el historial de grafana para verificar que ha ejecutado el archivo: `/opt/automation/updater.sh`

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505211705.png)

Y si, lo podemos confirmar, además justo después del inicio de sesión por netcat:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505212039.png)

##### Please confirm the password left by the system administrator in some Grafana configuration files. -> f0rela96789!

Los usuarios suele tener sus archivos de configuración en su home, como grafana lo tenía en: `/usr/share/grafana` nos metemos en ese directorio, donde nos llama la atención los archivos alojados en `conf`, principalmente uno llamado: `defaults.ini`, para agilizar la busqueda grepeamos por *password* y nos devuelve una contraseña del administrador:

```bash
$> cat defaults.ini | grep password

# You can configure the database connection by specifying type, host, name, user and password
# If the password contains # or ; you have to wrap it with triple quotes. Ex """#password;"""
password =
# default admin password, can be changed before first start of grafana, or in profile settings
admin_password = f0rela96789!
password_hint = password
# If the password contains # or ; you have to wrap it with triple quotes. Ex """#password;"""
password =
basic_auth_password =
password =
```


##### How often does the cronjob created by our IT admins run for the script modified by the TA? -> daily - 08:30

Las cronjob las suelen usar los hackers para proporcionar persistencia, entonces nos metemos en `catscale_out/Persistence` y leemos: `ip-172-31-13-147-20221124-1501-cron-tab-list.txt`, como su nombre indica nos mostrará la lista de contrabs que tiene la victima.

```bash
# m h  dom mon dow   command
30 8 * * * /opt/automation/updater.sh
```

Como vemos esta ejecutando el virus cada 8 horas, 30 minutos, y cada día, cada semana, cada mes; de aquí sacamos: *daily - 08:30*.

###### What was the mining threads value set to when xmrig was initiated? -> 0

```bash
$> cat ip-172-31-13-147-20221124-1501-persistence-systemdlist.txt | grep "xmrig|Threads" -Ei
 
ExecStart=/usr/share/.logstxt/xmrig -c /usr/share/.logstxt/config.json --      threads=0
ExecStart=/usr/share/.logstxt/xmrig -c /usr/share/.logstxt/config.json --      threads=0
``` 

##### We need to confirm the exact time the SOC team began artefact collection as this was not included in the report. They utilise the same public facing IP address as our system administrators in Lincoln. ->

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240505223522.png)

