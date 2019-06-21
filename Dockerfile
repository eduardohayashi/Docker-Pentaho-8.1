FROM ubuntu:18.04

ENV PENTAHO_HOME /opt/pentaho
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN . /etc/environment

RUN apt-get update; apt-get install software-properties-common zip netcat -y; \
    apt-get install wget unzip git vim cron libwebkitgtk-1.0-0 postgresql-client -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get install openjdk-8-jdk -y

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

RUN mkdir /work

VOLUME /etc/cron.d
VOLUME /work

#RUN wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.1/server/pentaho-server-ce-8.1.0.0-365.zip -O /tmp/pentaho-server.zip
COPY ./pentaho-server-ce-8.1.0.0-365.zip /tmp/pentaho-server.zip
RUN /usr/bin/unzip -q /tmp/pentaho-server.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/pentaho-server.zip; 
RUN rm -f /opt/pentaho/pentaho-server/promptuser.sh

EXPOSE 8080

COPY run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh
CMD /usr/local/bin/run.sh
