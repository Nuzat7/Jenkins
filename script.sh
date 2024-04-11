#!/bin/bash

cd/public/ntabassu
docker pull jenkins/jenkins:lts-jdk11
build it docker build -t modifyjenkins:v4 .

docker run -d -v jenkins_home:/var/new_volume -p 8080:8080 -p 50000:50000 -e PLUGINS_FORCE_UPGRADE=true -e TRY_UPGRADE_IF_NO_MARKER=true --restart=on-failure modifyjenkins:v4
JENKINS_HOST=http://bbl2xr00.bbl.ms.philips.com:8080
curl -sSL -u ntabassu:5 "$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+)()(<\/\w+>)+/\1 \n/g'> plugins.txt

docker cp modifyjenkins:/var/jenkins_home/plugins/tfs.jpi /public/ntabassu 
