FROM java:8-jre

MAINTAINER mail@rusty.info

ENV JTS3SERVERMOD_URL https://www.stefan1200.de/dlrequest.php?file=jts3servermod&type=.zip
ENV JTS3_DIR "/opt/jts3"
ENV JTS3_TEMP_DIR "/opt/jts3/tmp"
ENV JTS3_JAVA_ARGS "-Xmx256M"
ENV JTS3_USER "jts3"
ENV JTS3_UID 1000

ADD start.sh /start.sh

#Install Updates & Software
RUN apt-get -qq update && apt-get -qq install -y unzip
#Cleanup
RUN apt-get -qq clean && apt-get -qq autoremove --purge -y
#Create User
RUN useradd -u ${JTS3_UID} ${JTS3_USER}
#Create Paths
RUN mkdir -p ${JTS3_DIR} && mkdir -p ${JTS3_TEMP_DIR}
#Download JTS3 Packet
RUN wget -qq -O ${JTS3_TEMP_DIR}/jts3latest.zip ${JTS3SERVERMOD_URL}
#Unzip App
RUN unzip -qq -d ${JTS3_TEMP_DIR} ${JTS3_TEMP_DIR}/jts3latest.zip
#Move
RUN mv ${JTS3_TEMP_DIR}/JTS3ServerMod/* ${JTS3_DIR}
#own directories
RUN chown ${JTS3_USER} /start.sh && chown -R ${JTS3_USER} ${JTS3_DIR} && chown -R ${JTS3_USER} ${JTS3_TEMP_DIR}
#File Permissions
RUN chmod 755 /start.sh
#Cleanup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ${JTS3_TEMP_DIR}/*

WORKDIR ${JTS3_DIR}

USER ${JTS3_USER}

ENTRYPOINT ["/start.sh"]

VOLUME [${JTS3_DIR}]
