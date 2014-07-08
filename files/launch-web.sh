#/bin/bash

if test -n $DB_PORT_1521_TCP_ADDR
then

		ORACLE_DBA_URL="jdbc:oracle:thin:@${DB_PORT_1521_TCP_ADDR}:${DB_PORT_1521_TCP_PORT}:XE"

fi

MY_IP=$(/sbin/ifconfig | grep eth0 -A 1 | grep "inet addr" | awk '{print $2}' | cut -d: -f2)

echo "MY_IP=$MY_IP"

PUBLIC_URL="http://$MY_IP:8080"

# do some substitutions
sed -i.bak \
    -e "s#\${public.url}#${PUBLIC_URL}#g" \
    -e "s#\${jdbc.url}#${ORACLE_DBA_URL}#g" \
    -e 's#${jdbc.username}#KSBUNDLED#g' \
    -e 's#${jdbc.password}#KSBUNDLED#g' \
   -e 's#${jdbc.pool.size.max}#20#g' \
   -e 's#${keystore.file.default}#/ks-bundled/rice.keystore#g' \
   /root/kuali/main/dev/ks-with-rice-bundled-config.xml

/usr/share/tomcat/bin/startup.sh && tail -F /usr/share/tomcat/logs/catalina.out

