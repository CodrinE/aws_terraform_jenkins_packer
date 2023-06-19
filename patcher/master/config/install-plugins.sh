#!/bin/bash

set -e

PLUGIN_DIRECTORY=/var/lib/jenkins/plugins
FILE_OWNER=jenkins.jenkins

mkdir -p $PLUGIN_DIRECTORY

installPlugin() {
  if [ -f ${PLUGIN_DIRECTORY}/${1}.hpi -o -f ${PLUGIN_DIRECTORY}/${1}.jpi ];then
    if [ "$2"  == "$1" ];then
      return 1
    fi
    echo "Skipping: $1 (installed already)"
    return 0
  else
    echo "Installing: $1"
    curl -L --silent --output ${PLUGIN_DIRECTORY}${1}.hpi https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

while read -r plugin
do
  installPlugin "$plugin"
done < "/tmp/config/plugins.txt"

changed=1
maxloops=100

while [ "$changed" == "1" ]; do
  echo "Checking for missing dependencies ..."
  if [ $maxloops -lt 1 ];then
    echo "Max loops reached, check the script for bugs"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in ${PLUGIN_DIRECTORY}/*.hpi;do
    # without optionals
    #dependencies=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    dependencies=$( unzip -p ${f} META-INF/MANIFEST.MF| tr -d '\r' | sed -e sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $dependencies;do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done

echo "Configuring permissions"
chown -R ${FILE_OWNER} ${PLUGIN_DIRECTORY}

echo "done"