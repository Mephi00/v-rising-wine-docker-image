#!/bin/sh

DISPLAY=:0.0 wine VRisingServer.exe -persistentDataPath Z:\\saves -rconEnabled true -rconPort ${VR_RCON_PORT} -apiEnabled true -apiPort ${VR_API_PORT}