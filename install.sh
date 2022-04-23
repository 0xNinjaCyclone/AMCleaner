#!/bin/bash

source "$(dirname $0)/utils.sh"


InstallPackage() {
    apt install $1 -y &>/dev/null
}


if [ "$EUID" -ne 0 ]; then 
    print_fail "Please run as root"
    exit 1
fi

print_status "Setup dependencies"
apt update &>/dev/null
chmod 755 "$(dirname $0)/AMCleaner.sh"

if ! CheckCommandExist "apktool"; then
    print "Try to install 'apktool'"
    InstallPackage "apktool"
fi

if ! CheckCommandExist "keytool"; then
    print "Try to install 'keytool'"
    InstallPackage "keytool"
fi

if ! CheckCommandExist "jarsigner"; then
    print "Try to install 'jarsigner'"
    InstallPackage "jarsigner"
fi

if ! CheckCommandExist "zipalign"; then
    print "Try to install 'zipalign'"
    InstallPackage "zipalign"
fi

if ! isFileExist "/usr/share/dict/words"; then
    print_indicate "dict does not exist !"
    print_status "Try to install 'dict'"
    InstallPackage "wamerican"
fi

if ! CheckCommandExist "msfvenom"; then
    print_indicate "'msfvenom' does not exist !"
    print_status "Try to install & setup Metasploit framework"
    InstallPackage "metasploit-framework"
fi

print_succeed "Setup finished"