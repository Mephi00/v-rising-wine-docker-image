#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer
check_req_vars() {
if [ -z "${V_RISING_NAME}" ]; then
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

if [ -z "${V_RISING_PUBLIC_LIST}" ]; then
    echo "V_RISING_PUBLIC_LIST has to be set"

    exit
fi
}

setServerHostSettings() {
    rm $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json
    envsubst < /templates/ServerHostSetting.templ >> $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json
}

setServerGameSettings() {
    rm $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json
    envsubst < /templates/ServerGameSettings.templ >> $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json
}

if [ -d "/var/settings" ]; then
    echo "/var/settings exists"
    if [ -f "/var/settings/ServerGameSettings.json" ]; then
        cp /var/settings/ServerGameSettings.json $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json
    else
        setServerGameSettings
    fi

    if [ -f "/var/settings/ServerHostSettings.json" ]; then
        cp /var/settings/ServerHostSettings.json $GAME_DIR/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json
    else
        check_req_vars
        setServerHostSettingss
    fi
else
    setServerGameSettings
    check_req_vars
    setServerHostSettings
fi

./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit
rm -r /tmp/.X0-lock


cd $GAME_DIR
Xvfb :0 -screen 0 1024x768x16 & \
DISPLAY=:0.0 wine VRisingServer.exe -persistentDataPath Z:\saves
