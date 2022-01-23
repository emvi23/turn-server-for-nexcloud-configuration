#!/bin/bash
#!/bin/sh

#pre-requisite: enter sudo mode
#ROOTUID="0"

#if [ "$(id -u)" -ne "$ROOTUID" ] ; then´
#echo "Try with sudo. You may not have administrative rights to run this script."
#    exit 1
#fi

echo ""
echo "##############################################"
$SUDO hostname -I
echo "##############################################"
echo ""
$SUDO lsb_release -d -c
$SUDO hostname


echo ""
echo "##############################################"
echo "  Script that configures your Nextcloud installation " 
echo "     to run Nextcloud Talk via Internet "
echo "##############################################"
echo ""


echo "Set your Relm (FQDN):"
read FQDN

$SUDO apt update && apt -y upgrade

echo ""
echo "##############################################"
echo "  Install turn server on Nextcloud "
echo "##############################################"
echo ""

$SUDO apt install coturn ufw pcregrep -y
$SUDO systemctl stop coturn


echo ""
echo "##############################################"
echo "    Changes made to /etc/default/coturn "
echo "##############################################"
echo ""

$SUDO sed -i "s|#TURNSERVER_ENABLED=1|TURNSERVER_ENABLED=1|g" /etc/default/coturn

echo ""
echo "##############################################"
echo "      Changes made to /etc/turnserver.conf"
echo "##############################################"
echo ""

$SUDO sed -i "s|#listening-port=3478|listening-port=3478|g" /etc/turnserver.conf
$SUDO sed -i "s|#fingerprint|fingerprint|g" /etc/turnserver.conf
$SUDO sed -i "s|#lt-cred-mech|lt-cred-mech|g" /etc/turnserver.conf
$SUDO sed -i "s|#use-auth-secret|use-auth-secret|g" /etc/turnserver.conf
#This generates the server secret
$SUDO sed -i "s|#static-auth-secret=north|static-auth-secret=$(openssl rand -hex 32)|g" /etc/turnserver.conf
$SUDO sed -i "s|#realm=mycompany.org|realm=$FQDN|g" /etc/turnserver.conf
$SUDO sed -i "s|# bps-capacity=0|bps-capacity=0|g" /etc/turnserver.conf
$SUDO sed -i "s|#total-quota=0|total-quota=0|g" /etc/turnserver.conf
$SUDO sed -i "s|#stale-nonce=600|stale-nonce=600|g" /etc/turnserver.conf
$SUDO sed -i "s|#allow-loopback-peers|no-loopback-peers|g" /etc/turnserver.conf
$SUDO sed -i "s|#no-multicast-peers|no-multicast-peers|g" /etc/turnserver.conf
$SUDO systemctl enable coturn
$SUDO systemctl start coturn

echo ""
echo "##############################################"
echo "    Add entry to ufw firewall "
echo "##############################################"
echo ""

$SUDO sudo ufw allow 3478/tcp

echo ""
echo "#######################################################"
echo " After rebooting go to Nextcloud -> Settings -> Administration -> Talk "
echo " Copy the Secret bellow and Go to section TURN servers -> Select turn only -> domain: $FQDN:3478 -> SECRET -> TCP only "
echo "#######################################################"
echo ""
#Get the Secret from file /etc/turnserver.conf

$SUDO sudo pcregrep -o1 'static-auth-secret=(.*)' /etc/turnserver.conf

echo ""
echo "#######################################################"
echo "  A restart is needed, please hit any key  "
echo "#######################################################"
echo ""
read rebooting
$SUDO sudo poweroff --r
