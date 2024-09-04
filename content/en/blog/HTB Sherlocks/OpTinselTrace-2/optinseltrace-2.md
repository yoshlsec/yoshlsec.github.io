---
title: OpTinselTrace-2
description: >
  HackTheBox Sherlocks - Easy<br>
  [Challenge Download](https://app.hackthebox.com/sherlocks/OpTinselTrace-2)
date: 2024-05-08
weight: 10
tags: ["htb","forensics","easy","sherlock", "wireshark"]
---
---
### Enunciado del problema

It seems our precious technology has been leaked to the threat actor. Our head Elf, PixelPepermint, seems to think that there were some hard-coded sensitive URLs within the technology sent. Please audit our Sparky Cloud logs and confirm if anything was stolen! PS - Santa likes his answers in UTC... Please note - these Sherlocks are built to be completed sequentially and in order!

---
### Instalación requerida

Como estamos hablando de un S3 de amazon web service, vamos a tener que usar la herramienta de terminal que nos proporciona AWS:

```bash
docker pull amazon/aws-cli
```

Para mayor comodidad yo añadi un alias a mi `~/.zshrc`:

```bash
echo 'alias "awscli"="docker run --rm -it amazon/aws-cli"' >> ~/.zshrc
```

---
Si recordamos el rabbit hole que nos encontramos del binario veremos que nos menciona un Simple Storage Service de Amazon.

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502171542.png)

Con esto podemos usar la herramienta anteriormente mencionada para ver si tiene algo de información pública:

```bash
$> awscli s3 ls s3://papa-noel

Unable to locate credentials. You can configure credentials by running "aws configure".
```

Como no tenemos credenciales nos adentramos al menu help de la herramienta, y vemos que podemos listar sin necesidad de estas, para ello usamos el argumento: `--no-sign-request`

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502171809.png)

```bash
$> awscli s3 ls s3://papa-noel --no-sign-request

                           PRE NPoleScripts/
2023-10-30 23:23:58     427795 santa-list.csv


$> awscli s3 ls s3://papa-noel/NPoleScripts/ --no-sign-request

                           PRE .git/
2023-11-28 09:47:28        549 backup.py
2023-11-28 09:47:27        421 check.js
2023-11-28 09:47:28       3406 claus.py
2023-11-28 09:47:26        297 disk.ps
2023-11-28 09:47:26        209 organise.rb
2023-11-28 09:47:27     941071 santa_journey_log.csv
2023-11-28 09:47:28        279 update.sh
```

Nos llama la atención ese `.git` entonces usando el comando *cp* que nos viene integrado en *awscli* llevamos el directorio `NPoleScripts` a nuestra máquina local:

```bash
$> mkdir s3_dump
$> awscli s3 cp s3://papa-noel/NPoleScripts/ ./s3_dump/ --recursive --no-sign-request

download: s3://papa-noel/NPoleScripts/.git/HEAD to s3_dump/.git/HEAD
download: s3://papa-noel/NPoleScripts/.git/config to s3_dump/.git/config
download: s3://papa-noel/NPoleScripts/.git/hooks/pre-merge-commit.sample to s3_dump/.git/hooks/pre-merge-commit.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/applypatch-msg.sample to s3_dump/.git/hooks/applypatch-msg.sample
download: s3://papa-noel/NPoleScripts/.git/COMMIT_EDITMSG to s3_dump/.git/COMMIT_EDITMSG
download: s3://papa-noel/NPoleScripts/.git/hooks/commit-msg.sample to s3_dump/.git/hooks/commit-msg.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/fsmonitor-watchman.sample to s3_dump/.git/hooks/fsmonitor-watchman.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/pre-applypatch.sample to s3_dump/.git/hooks/pre-applypatch.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/pre-push.sample to s3_dump/.git/hooks/pre-push.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/post-update.sample to s3_dump/.git/hooks/post-update.sample
download: s3://papa-noel/NPoleScripts/.git/description to s3_dump/.git/description
download: s3://papa-noel/NPoleScripts/.git/hooks/push-to-checkout.sample to s3_dump/.git/hooks/push-to-checkout.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/prepare-commit-msg.sample to s3_dump/.git/hooks/prepare-commit-msg.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/pre-commit.sample to s3_dump/.git/hooks/pre-commit.sample
download: s3://papa-noel/NPoleScripts/.git/hooks/pre-receive.sample to s3_dump/.git/hooks/pre-receive.sample
. . .
```


Y dentro en el git log, encontraremos informacion dentro de un cambio en el archivo **claus.py**

```bash
AWS_ACCESS_KEY = 'AKIA52GPOBQCBTZ6NJXM'
AWS_SECRET_KEY = '5IjUOttNz/7TCvkvdMX9IK6sM3Mkr1Fx/ExA0lDf'
BUCKET_NAME = 'noth-pole-private'
REGION_NAME = 'eu-west-2'
```

Y también tendremos en cuenta las credenciales que obtuvimos en [[OpTinselTrace-1]]

```cpp
user -> elf-admin
password -> 3lfP@ssw0rd
```


---

Una vez que hemos recopilado toda esta información nos iremos a la región **ue-west-2** y haremos un escaneo avanzado en los json cloud.

###### Listado de usuarios

```bash
$> find . -name "*.json" -exec jq -r '.Records[].userIdentity.userName // empty' {} + | sort -u

elfadmin
elfin
snowball
terraform-gumdrop
```

###### Listado de IPs

```bash
$> find . -name "*.json" -exec jq -r '.Records[].sourceIPAddress // empty' {} + | sort -u

109.205.185.126
138.199.59.46
191.101.31.26
191.101.31.57
195.181.170.226
3.236.115.9
3.236.226.247
45.133.193.41
45.148.104.164
86.5.206.121
access-analyzer.amazonaws.com
cloudtrail.amazonaws.com
dynamodb.application-autoscaling.amazonaws.com
resource-explorer-2.amazonaws.com
X.X.X.X
```

###### Listado de "Bucketnames"

```bash
$> find . -name "*.json" -exec jq -r '.Records[] | select(.requestParameters.bucketName != null) .requestParameters.bucketName' {} + | sort -u

north-pole-logs
north-pole-private
npole-cloud-infra
npole-export
npole-fileshare
npole-fileshare-logs
npole-forensic-collection
npole-logstorage
npole-storage
npole-vm-setup
papa-noel
snow-infra-terraform
```

Significa que para cada objeto `Records` en el archivo JSON, selecciona aquellos que tienen `bucketName` no nulo y luego imprime el valor de `bucketName`. (_Grande chatGPT_)

Para no tener que estar utilizando todo el rato el comando find, lo que vamos a hacer es meter todos los archivos en uno solo:

```bash
find . -name "*.json" -exec jq -s "." {} + > emerge.json   
```

si queremos continuar con este reto tenemos que saber la estructura que tiene cada reporte para poder automatizar más las cosas, os dejo aqui un ejemplo de un reporte para ver lo que nos puede ser de ayuda y lo que no:

```json
{
    "Records": [
      {
        "eventVersion": "1.08",
        "userIdentity": {
          "type": "AssumedRole",
          "principalId": "AROA52GPOBQCDUJBLGAGQ:AutoScaling-RetrieveCurrentCapacity",
          "arn": "arn:aws:sts::949622803460:assumed-role/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable/AutoScaling-RetrieveCurrentCapacity",
          "accountId": "949622803460",
          "accessKeyId": "ASIA52GPOBQCEZOLSKJN",
          "sessionContext": {
            "sessionIssuer": {
              "type": "Role",
              "principalId": "AROA52GPOBQCDUJBLGAGQ",
              "arn": "arn:aws:iam::949622803460:role/aws-service-role/dynamodb.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_DynamoDBTable",
              "accountId": "949622803460",
              "userName": "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
            },
            "attributes": {
              "creationDate": "2023-11-27T07:42:57Z",
              "mfaAuthenticated": "false"
            }
          },
          "invokedBy": "dynamodb.application-autoscaling.amazonaws.com"
        },
        "eventTime": "2023-11-27T07:42:57Z",
        "eventSource": "dynamodb.amazonaws.com",
        "eventName": "DescribeTable",
        "awsRegion": "eu-west-2",
        "sourceIPAddress": "dynamodb.application-autoscaling.amazonaws.com",
        "userAgent": "dynamodb.application-autoscaling.amazonaws.com",
        "requestParameters": {
          "tableName": "snow-infra"
        },
        "responseElements": null,
        "requestID": "AA8AN6IIG9B51HE7LNU2KPJN97VV4KQNSO5AEMVJF66Q9ASUAAJG",
        "eventID": "7116e095-c35e-402a-9faa-904f557dc178",
        "readOnly": true,
        "resources": [
          {
            "accountId": "949622803460",
            "type": "AWS::DynamoDB::Table",
            "ARN": "arn:aws:dynamodb:eu-west-2:949622803460:table/snow-infra"
          }
        ],
        "eventType": "AwsApiCall",
        "apiVersion": "2012-08-10",
        "managementEvent": true,
        "recipientAccountId": "949622803460",
        "eventCategory": "Management"
      }
    ]
  }
```

En mi punto de vista vemos importante:
- userIdentity
- eventTime
- sourceIPAddress
- eventType

A lo mejor en un futuro necesitamos otras clases, pero con esto vamos bien, dicho esto, empezamos a contestar las preguntas.

--- 
Para la primera pregunta hay que tener guardado el binario donde hemos sacado toda la información y obtener su MD5:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502185231.png)

---

Si vamos de uno en un filtrando por cada accion realizada por cada ip vamos a ver que: **191.101.31.57** tiene muchos registros, algunos con errores y bucketname que no nos importa

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502201842.png)

y otros que nos llaman la atención y estan en el bucketname = papa-noel, el nombre de estos eventos es **GetObject**:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502201957.png)

Sabiendo los nombres podemos filtrar por estos para ver los registros de *Threat Actor*

```bash
jq '.[].Records[] | select(.eventName == "GetObject" and .sourceIPAddress == "191.101.31.57")' emerge.json | sort -u
```

Como nos estan pidiendo la fecha cuando se ejecuta vamos a añadir el parametro: **eventTime**:

```bash
$> jq '.[].Records[] | select(.eventName == "GetObject" and .sourceIPAddress == "191.101.31.57") | .eventTime' emerge.json | sort -u

"2023-11-29T08:24:07Z"
"2023-11-29T08:24:08Z"
"2023-11-29T08:24:09Z"
"2023-11-29T08:24:10Z"
"2023-11-29T08:24:11Z"
"2023-11-29T08:24:12Z"
"2023-11-29T08:24:13Z"
"2023-11-29T08:24:14Z"
"2023-11-29T08:24:15Z"
"2023-11-29T08:24:16Z"
```

La primera fecha la pasamos al formato que nos pide:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502204329.png)

Pasamos la última fecha al formato que nos pide:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502204437.png)

---

La tercera pregunta no hay que entrar en profundidad....

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502204539.png)

---

Nos estan pidiendo que en que archivos habia introdicido unas credenciales codificadas, para listar todos los archivos usamos:

```bash
jq '.[] | .Records[] | select(.eventName == "GetObject" and .sourceIPAddress == "191.101.31.57") | .requestParameters' emerge.json | sort -u | awk -F':' '{print $2}'
```

Y si nos damos cuenta de los logs que sacamos del git al principio, vemos que esta **claus.py**

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502211131.png)

---

Nos estan pidiendo las IPs que se consideren maliciosas, para ello vamos a introducir las que más hayan hecho cambios, para eso crearemos un script en bash y vemos cuantas peticiones a hecho cada IP que sacamos con el comando:

```bash
$> find . -name "*.json" -exec jq -r '.Records[].sourceIPAddress // empty' {} + | sort -u

109.205.185.126
138.199.59.46
191.101.31.26
191.101.31.57
195.181.170.226
3.236.115.9
3.236.226.247
45.133.193.41
45.148.104.164
86.5.206.121
access-analyzer.amazonaws.com
cloudtrail.amazonaws.com
dynamodb.application-autoscaling.amazonaws.com
resource-explorer-2.amazonaws.com
X.X.X.X
```

Con la magia de la programación podemos hacer un script para que nos automatice y nos muestr solo las ips que hayan hecho más de un reporte:

```bash
#!/bin/bash

ip_list=(
    109.205.185.126
    138.199.59.46
    191.101.31.26
    191.101.31.57
    195.181.170.226
    3.236.115.9
    3.236.226.247
    45.133.193.41
    45.148.104.164
    86.5.206.121
    access-analyzer.amazonaws.com
    cloudtrail.amazonaws.com
    dynamodb.application-autoscaling.amazonaws.com
    resource-explorer-2.amazonaws.com
    X.X.X.X
)

for ip in "${ip_list[@]}"; do
    count=$(jq --arg ip "$ip" '.[].Records[] | select(.eventName == "GetObject" and .sourceIPAddress == $ip) | .eventTime' emerge.json 2>/dev/null | wc -l)
	if [ $count -gt 0 ]; then
		echo "Analizando la IP: $ip"
        echo "Número de líneas para la IP $ip: $count"
		echo
    fi
done

```

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502212306.png)

Ahora si indagamos más en cada IP, vemos que 45.133.193.41 usa los mismos usuarios que 191.101.31.26, probamos y es correcto:

![](https://raw.githubusercontent.com/yoshlsec/page-images/main/Sherlocks%20HTB/Pasted%20image%2020240502212412.png)

----
Las otras 3 preguntas eran de madrugada y me daban pereza, una es filtrar por vpn, ver archivos opvn y su fecha de creación, luego obtener un nombre y un arn, que podias ver todo en mismo report.

https://labs.hackthebox.com/achievement/sherlock/1615089/578