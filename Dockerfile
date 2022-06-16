FROM cm2network/steamcmd:latest

USER root

RUN apt-get update -y

RUN apt-get install wine -y

RUN apt-get install gettext-base -y

RUN apt-get install xvfb -y

RUN apt-get install x11-utils -y

RUN apt-get install procps -y

RUN apt-get install tini -y

RUN dpkg --add-architecture i386 && apt-get update && apt-get install wine32 -y

RUN mkdir /saves

RUN chown steam /saves

ENV DISPLAY=:99

RUN winecfg

USER steam

RUN ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit

ENV V_RISING_MAX_HEALTH_MOD=1.0
ENV V_RISING_MAX_HEALTH_GLOBAL_MOD=1.0
ENV V_RISING_RESOURCE_YIELD_MOD=1.0

ENV V_RISING_DAY_DURATION_SECONDS=1080.0
ENV V_RISING_DAY_START_HOUR=9
ENV V_RISING_DAY_END_HOUR=17

ENV V_RISING_TOMB_LIMIT=12
ENV V_RISING_NEST_LIMIT=4

ENV V_RISING_MAX_USER=40
ENV V_RISING_MAX_ADMIN=4
ENV V_RISING_DESC=""
ENV V_RISING_PASSW=""
ENV V_RISING_CLAN_SIZE=4
ENV V_RISING_PORT=9876
ENV V_RISING_QUERY_PORT=9877

ENV V_RISING_SETTING_PRESET=""
ENV V_RISING_DEATH_CONTAINER_PERMISSIONS="Anyone"
ENV V_RISING_GAME_MODE="PvP"

COPY ./templates /templates

COPY entrypoint.sh /

COPY launch_server.sh /

USER root

RUN chown -R steam /saves

RUN chmod +x /launch_server.sh

RUN chmod +x /entrypoint.sh

USER steam

ENTRYPOINT [ "/entrypoint.sh" ]
