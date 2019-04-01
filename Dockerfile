FROM mono:latest
MAINTAINER t3l3ltubie

# # INSTALL STEAMCMD
# # --------------------------------------------------

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       lib32stdc++6 \
                    lib32gcc1 \
                              wget \
                                   ca-certificates \
                                   && useradd -m steam \

                                   && su steam -c \
                                      "mkdir -p /home/steam/steamcmd \
                                             && cd /home/steam/steamcmd \
                                                && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/

# # END INSTALL CMD
# # --------------------------------------------------

# FROM cm2network/steamcmd
USER root
WORKDIR /home/steam
ENV DEBIAN_FRONTEND noninteractive
# Bad JUJU, fix this!
RUN chmod 777 -R /home/steam/
RUN useradd -m scp
RUN mkdir -p "/home/scp/scp_server"
ENV EXECUTABLE "/home/steam/steamcmd/steamcmd.sh"
ENV STEAM_USERNAME "anonymous"
ENV FORCE_INSTALL_DIR "/home/scp/scp_server"
# 700330 is base game
# https://steamdb.info/app/700330/
# 786920 is multiadmin+servermod
# https://steamdb.info/app/786920/
# 996560 is dedicated server
# https://steamdb.info/app/996560/

ENV APPID "786920 -beta linux"
ENV VALIDATE "validate"
RUN chmod 777 -R /home/scp/
RUN $EXECUTABLE \
+login $STEAM_USERNAME \
+force_install_dir $FORCE_INSTALL_DIR \
+app_update $APPID $VALIDATE \
+quit


RUN mkdir -p /home/steam/scp_server/servers/server1/
WORKDIR /home/scp/scp_server


USER root
RUN ["mkdir", "-p", "/root/.config/SCP Secret Laboratory/"]
# # basic config
COPY ["config_gameplay.txt", "/root/.config/SCP Secret Laboratory/"]

# Make storage persistent for the server
VOLUME /home/steam/steamcmd
VOLUME /home/steam/scp_server

# MultiAdmin runs from the root directory
ENTRYPOINT mono MultiAdmin.exe

# Make networking available (only udp should be needed)
EXPOSE 7777/udp 7778/udp 7779/udp 7780/udp 7781/udp 7782/udp 7783/udp 7784/udp
EXPOSE 7777/tcp 7778/tcp 7779/tcp 7780/tcp 7781/tcp 7782/tcp 7783/tcp 7784/tcp
