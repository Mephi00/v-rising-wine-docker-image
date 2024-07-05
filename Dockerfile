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

RUN apt-get install winbind -y

RUN mkdir /saves

RUN chown steam /saves

ENV DISPLAY=:99

RUN winecfg

USER steam

RUN ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit

COPY ./templates /templates

COPY entrypoint.sh /

COPY launch_server.sh /

USER root

RUN chown -R steam /saves

RUN chmod +x /launch_server.sh

RUN chmod +x /entrypoint.sh

EXPOSE 27020/udp
EXPOSE 27020/tcp
EXPOSE 27021/udp
EXPOSE 27021/tcp
EXPOSE 27022/udp
EXPOSE 27022/tcp
EXPOSE 27023/udp
EXPOSE 27023/tcp

USER steam

ENTRYPOINT [ "/entrypoint.sh" ]
