#/bin/bash

if test -n "$DB_PORT_1521_TCP_ADDR"
then

		ORACLE_DBA_URL="jdbc:oracle:thin:@${DB_PORT_1521_TCP_ADDR}:${DB_PORT_1521_TCP_PORT}:XE"

fi

echo "ORACLE_DBA_URL=$ORACLE_DBA_URL (can be set. normally inferred from db link)"

MY_IP=$(/sbin/ifconfig | grep eth0 -A 1 | grep "inet addr" | awk '{print $2}' | cut -d: -f2)

echo "MY_IP=$MY_IP"


if test -n "$PUBLIC_URL"
then
	PUBLIC_URL="http://$MY_IP:8080"
fi

# else use what was set in the docker run

echo "PUBLIC_URL=$PUBLIC_URL (can be set through environment)"

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

