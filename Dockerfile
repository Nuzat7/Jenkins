FROM jenkins/jenkins:lts-jdk11

USER root

ENV HTTPS_PROXY=http://umbrella.philips.com:443/

ENV https_proxy=http://umbrella.philips.com:443/

ENV HTTP_PROXY=http://umbrella.philips.com:80/

ENV http_proxy=http://umbrella.philips.com:80/

ENV FTP_PROXY=http://umbrella.philips.com:80/

ENV ftp_proxy=http://umbrella.philips.com:80/

ENV NO_PROXY=localhost,127.0.0.1,localaddress,.bbl.ms.philips.com,.ta.philips.com,.code1.emi.philips.com 

WORKDIR /thomas

RUN openssl s_client -showcerts -connect updates.jenkins.io:443 < /dev/null 2> /dev/null |awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".pem"; print >out}'; \

for cert in *.pem; do newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem;    mv $cert $newname ; done; \

for cert in *.pem; do keytool -import -alias $cert -storepass changeit -noprompt -trustcacerts -cacerts -file $cert ; done

USER jenkins 

ENV HTTPS_PROXY=http://umbrella.philips.com:443/

ENV https_proxy=http://umbrella.philips.com:443/

ENV HTTP_PROXY=http://umbrella.philips.com:80/

ENV http_proxy=http://umbrella.philips.com:80/

ENV FTP_PROXY=http://umbrella.philips.com:80/

ENV ftp_proxy=http://umbrella.philips.com:80/

ENV NO_PROXY=localhost,127.0.0.1,localaddress,.bbl.ms.philips.com,.ta.philips.com,.code1.emi.philips.com 

ENV JAVA_OPTS="-Djavax.net.ssl.trustStore=$JAVA_HOME/lib/security/cacerts"

RUN jenkins-plugin-cli --plugins blueocean

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
