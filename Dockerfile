# An image with a command line interface for steam
FROM cm2network/steamcmd
MAINTAINER t3l3ltubie
USER steam
RUN chmod 755 /home/steam/steamcmd
USER root
WORKDIR /home/steam
RUN apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                mono-complete \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN useradd -m scp
USER scp
RUN mkdir -p "/home/scp/scp_server"
ENV EXECUTABLE "/home/steam/steamcmd"
ENV STEAM_USERNAME "anonymous"
ENV FORCE_INSTALL_DIR "/home/scp/scp_server"
ENV APPID "786920 -beta beta"
ENV VALIDATE "validate"
RUN $EXECUTABLE \
+login $STEAM_USERNAME \
+force_install_dir $FORCE_INSTALL_DIR \
+app_update $APPID $VALIDATE \
+quit
RUN mkdir -p /home/steam/scp_server/servers/server1/
RUN cp /home/steam/scp_server/config_template.txt /home/steam/scp_server/servers/server1/config.txt
WORKDIR /home/steam/scp_server
# # May not be needed with multiadmin pre-installed
# RUN wget "https://github.com/Grover-c13/MultiAdmin/releases/download/3.0.0/MultiAdmin.exe" -O "/home/steam/scp_server/MultiAdmin.exe"
# Make storage persistent for the server
VOLUME /home/steam/scp_server
# MultiAdmin runs from the root directory
RUN mono MultiAdmin.exe
