#!/bin/bash
sudo apt update
sudo apt install openjdk-8-jre -y
mkdir -p /data/streama/ /data/streama/files
wget https://github.com/streamaserver/streama/releases/download/v1.10.4/streama-1.10.4.jar
mv streama-1.10.4.jar /data/streama/streama-1.10.4.jar
chmod +x /data/streama/streama-1.10.4.jar
java -jar /data/streama/streama-1.10.4.jar
