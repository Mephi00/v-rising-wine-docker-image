#!/bin/sh
GAME_DIR = /home/steam/Steam/steamapps/common/VRisingDedicatedServer
check_req_vars() {
if [ -z "${V_RISING_NAME+}" ]; then
    echo "V_RISING_NAME has to be set"

    exit
fi

if [ -z "${V_RISING_PASSW}" ]; then
    echo "V_RISING_PASSW has to be set"

    exit
fi

if [ -z "${V_RISING_SAVE_NAME}" ]; then
    echo "V_RISING_SAVE_NAME has to be set"

    exit
fi
}

if [ -d "/var/settings" ]; then 
    if [ -f "/var/settings/ServerGameSettings.json" ]; then
        cp /var/settings/ServerGameSettings.json $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json
    else
        envsubst /templates/ServerGameSettings.templ >> $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json &
    fi

    if [ -f "/var/settings/ServerHostSettings.json" ]; then
        cp /var/settings/ServerHostSettings.json $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json
    else
        check_req_vars
        envsubst /templates/ServerHostSetting.templ >> $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json &
    fi
fi

wine64 $GAME_DIR/VRisingServer.exe -persistentDataPath C:\\\\saves
