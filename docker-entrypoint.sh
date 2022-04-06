#!/bin/sh
cd /opt/
mkdir -p /opt/ftp/anonymous
mkdir -p /opt/ftp/user
chmod -R  777  /opt/ftp/user
chmod -R  777  /opt/ftp/anonymous
python3 MyFtpServer.py
