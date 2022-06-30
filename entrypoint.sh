#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer
SETTINGS_DIR=$GAME_DIR/VRisingServer_Data/StreamingAssets/Settings

onExit() {
    kill -INT -$(ps -A | grep 'VRising' | awk '{print $1}') &>> /saves/wtf
    wait $!
}

check_req_vars() {
    if [ -z "${V_RISING_NAME}" ]; then
        echo "V_RISING_NAME has to be set"

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
    check_req_vars
    WRITE_DIR=$SETTINGS_DIR

    # if [ -d "/saves/Settings" ]; then
    #     WRITE_DIR=/saves/Settings
    # fi

    echo "Using env vars for ServerHostSettings"
    envsubst < /templates/ServerHostSetting.templ > $WRITE_DIR/ServerHostSettings.json
}

setServerGameSettings() {
    WRITE_DIR=$SETTINGS_DIR

    echo "Using env vars for ServerGameSettings"
    envsubst < /templates/ServerGameSettings.templ > $WRITE_DIR/ServerGameSettings.json
}

createSettingsSaves() {
    if [ ! -d "/saves/Settings" ]; then
        mkdir /saves/Settings
    fi
}

# This logic is flawed and I don't have the energy to fix this
checkGameSettings() {
    if [ ! -f "/saves/Settings/ServerGameSettings.json" ]; then
        # necessary for backwards compatabiltiy
        if [ -f "/var/settings/ServerGameSettings.json" ]; then
            cp /var/settings/ServerGameSettings.json /saves/Settings/ServerGameSettings.json
        else
            setServerGameSettings
        fi
    else
        echo "Using /saves/Settings/ServerGameSettings.json for settings"
    fi
}

# This logic is flawed and I don't have the energy to fix this
checkHostSettings() {
    if [ ! -f "/saves/Settings/ServerHostSettings.json" ]; then
        # necessary for backwards compatabiltiy
        if [ -f "/var/settings/ServerHostSettings.json" ]; then
            cp /var/settings/ServerHostSettings.json /saves/Settings/ServerHostSettings.json
            checkGameSettings
        else
            check_req_vars
            setServerHostSettings
        fi
    else
        echo "Using /saves/Settings/ServerHostSettings.json for settings"
    fi
}

./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit

if [ -d "/saves" ]; then
    createSettingsSaves
    checkGameSettings
    checkHostSettings
else
    setServerGameSettings
    setServerHostSettings
fi

trap onExit INT TERM KILL

cd $GAME_DIR
Xvfb :0 -screen 0 1024x768x16 &
setsid '/launch_server.sh' &

echo $!
wait $!