#!/bin/sh

#----------------------#
# To toggle port state #
#----------------------#


IP_ADDRESS=192.168.0.104    # example IP Address
OUTLET_NUM=0                # index starts at 0
COMMAND=rb									# "rb" will restart, "rly" will toggle
USERNAME=admin
PASSWORD=admin


#----------#
# HTTP API #
#----------#

# with curl (assumes http and port 80)
curl -u ${USERNAME}:${PASSWORD} http://${IP_ADDRESS}/cmd.cgi?${COMMAND}=${OUTLET_NUM} 

# resolves to => curl -u admin:admin http://192.168.0.104/cmd.cgi?rb=0

# with wget (-o/dev/null argument to not save output status)
wget -o/dev/null --user=${USERNAME} --password=${PASSWORD} http://${IP_ADDRESS}/cmd.cgi?${COMMAND}=${OUTLET_NUM}

# resolves to => wget -o/dev/null --user=admin --password=admin http://192.168.0.104/cmd.cgi?rb=0


#------------#
# Telnet API #
#------------#

{
	sleep 1;
	echo $USERNAME;
	sleep 1
	echo $PASSWORD;
	sleep 1
	echo "rb 1\r";
} | telnet ${IP_ADDRESS}

##### Available Options
# cs n        Display AC Current Draw Status(1-display, 0-erase max value)
# emailsend   Sends a test email
# ip     v    Sets IP & Mask addr "ip x.x.x.x  x.x.x.x"
# ipsrc  v    Designated source IP To Access. To Allow All (0.0.0.0)
# ipsrcm v    Designated source IP subnet mask
# gw     v    Sets Static gateway IP
# dhcp   v    Sets IP in static(v=0) or DHCP (v=1) mode.
# help or ?   Displays Help menu
# http   v    Sets http port #
# telnet v    Sets telnet port number
# login       Enters user login.
# logout      Exits current logi
# mac         Displays Ethernet port Mac address
# nwset       Restarts Ethernet network interface
# nwshow      Displays network Status
# ping        Pings a host. E.g.: ping 192.168.0.1, or ping yahoo.com
# pset n v    Sets outlet #n to v(value 1-on,0-off)
# gpset v     Sets outlet group to v(value 1-on,0-off)
# ps v        Sets all power outlets to v(value 1-on,0-off)
# pshow       Displays outlet status
# rb n        Reboots outlet #n
# grb         Reboots outlet group
# sysshow     Displays system information
# time        Displays current time
# timeset     Sets date and time. Format:mm/dd/yyyy hh:mm:ss
# ver         Displays hardware and software versions
# web v       Turns Web access ON/OFF. "1"=ON. "0"-OFF


#---------------------#
# ADDITIONAL HTTP API #
#---------------------#
# requires base64 executable
BASE64_AUTH=$(echo -n ${USERNAME}:${PASSWORD} | base64)

### SET OUTLET ON/OFF ###
COMMAND="\$A3" # forward slash to escape $
ARG1=1 # for outlet 1
ARG2=1 # 1=on 0=off

curl -s "http://$IP_ADDRESS/cmd.cgi?$COMMAND%20$ARG1%20$ARG2" \
	-H "Authorization: Basic $BASE64_AUTH"

## resolves to => curl -H "Authorization: Basic $(echo -n admin:admin | base64)" http:192.168.0.104/cmd.cgi?$A3%201%201

## REBOOT OUTLET ###
COMMAND="\$A4"
ARG1=1 # for first outlet
# no arg2 needed

curl -s "http://$IP_ADDRESS/cmd.cgi?$COMMAND%20$ARG1" \
	-H "Authorization: Basic $BASE64_AUTH"

## resolves to => curl -H "Authorization: Basic $(echo -n admin:admin | base64)" http:192.168.0.104/cmd.cgi?$A4%201


## RETURNS ##
# $A0 is OK
# $AF is Failed or Unknown Code


# More info available at https://static1.squarespace.com/static/54d27fb4e4b024eccdd9e569/t/5b242bd30e2e729c8d7573da/1529097173304/1094_NPStartup_V20.pdf

