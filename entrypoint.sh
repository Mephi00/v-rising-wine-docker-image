#!/bin/sh


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

envsubst /templates/ServerGameSettings.templ >> /home/steam/Steam/steamapps/common/VRisingDedicatedServer/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json &

envsubst /templates/ServerHostSetting.templ >> /home/steam/Steam/steamapps/common/VRisingDedicatedServer/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json &

sh