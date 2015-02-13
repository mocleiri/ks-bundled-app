FROM dockerfile/java:oracle-java7

MAINTAINER Michael O'Cleirigh https://github.com/mocleiri

RUN mkdir -p /ks-bundled/lib
RUN mkdir -p /ks-bundled/app

# maven settings file
ADD files/settings.xml /root/.m2/settings.xml

ENV OJDBC_VERSION 11.2.0.2

# default to what we get with wnameless/oracle-xe-11g
ENV ORACLE_DBA_PASSWORD oracle

# oracle driver
ADD files/ojdbc6_g-$OJDBC_VERSION.jar /ks-bundled/lib/ojdbc6_g-$OJDBC_VERSION.jar


ADD files/launch-web.sh /ks-bundled/launch-web.sh
ADD files/rice.keystore /ks-bundled/rice.keystore

RUN chmod +x /ks-bundled/launch-web.sh

# install maven

RUN apt-get update
RUN apt-get -y install wget

ENV BUILD_NUMBER 917

# add in the war file parts
ADD files/ks-with-rice-bundled-2.1.1-FR2-M1-build-${BUILD_NUMBER}.{aa,ab,ac} /ks-bundled/app/

# reconstitute the > 100 MB file and delete the source parts
RUN cat /ks-bundled/app/ks-with-rice-bundled-2.1.1-FR2-M1-build-${BUILD_NUMBER}.war.?? > /ks-bundled/app/ks-with-rice-bundled-2.1.1-FR2-M1-build-${BUILD_NUMBER}.war && rm /ks-bundled/app/ks-with-rice-bundled-2.1.1-FR2-M1-build-${BUILD_NUMBER}.{aa,ab,ac}

# tomcat
ENV TOMCAT_VERSION 6.0.37
RUN mkdir -p /usr/share/tomcat
RUN wget --no-verbose -O /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz \
    http://archive.apache.org/dist/tomcat/tomcat-6/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

# stop building if md5sum does not match
RUN echo "f90b100cf51ae0a444bef5acd7b6edb2  /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz" | \
    md5sum -c

# install tomcat in /usr/share/tomcat
RUN tar xzf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz --strip-components=1 -C /usr/share/tomcat
RUN rm -f /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV CATALINA_HOME /usr/share/tomcat
ENV CATALINA_OPTS -Xmx1g -XX:MaxPermSize=300m

ADD files/ojdbc6_g-$OJDBC_VERSION.jar /usr/share/tomcat/lib/ojdbc6_g-$OJDBC_VERSION.jar

# copy oracle driver to tomcat lib directory
RUN rm -rf /usr/share/tomcat/webapps/*
ADD files/server.xml /usr/share/tomcat/conf/server.xml

RUN cp /ks-bundled/app/*.war /usr/share/tomcat/webapps/ROOT.war

RUN mkdir -p /root/kuali/main/dev

RUN wget --no-verbose -O /root/kuali/main/dev/ks-with-rice-bundled-config.xml https://github.com/kuali-student/ks-final-milestone/blob/master/ks-deployments/ks-deployment-resources/src/main/resources/org/kuali/student/ks-deployment-resources/deploy/config/ks-with-rice-bundled-config.xml

EXPOSE 8080

CMD cd /ks-bundled && ./launch-web.sh
