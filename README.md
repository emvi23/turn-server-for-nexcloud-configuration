# turn-server-for-nexcloud-configuration

Hello,
I made this script to achieve video conferencing with my family over mobile phone internet connection.
After testing on Debian 11 and Nextcloud 23.0.0, I was able to communicate with high quality image using Firefox on desktop and Nextcloud Talk on iPhone and Android.

Run this to deploy Turn server on your Nextcloud instance.
This script should work on Debian based distros and Nextcloud  Latest stable version: 23.0.0.
You don't need to run this for LAN connections to use Nexcloud Talk.

You should be root and previously heaved setup your Nextcloud server and DMZ or port-forward 3478 to you server IP.

A secret will be generated at the end of this script and you should copy.
If you fail to copy you can locate the secret in the file located under /etc/turnserver.conf

After rebooting go to Web interface and login with your administrator account > Nextcloud -> Settings -> Administration -> Talk " Copy the Secret  and Go to section TURN servers -> Select turn only -> domain: FQDN:3478 -> SECRET -> TCP only " , if you see the check mark it means that is working.

Enjoy!!
https://github.com/emvi23/turn-server-for-nexcloud-configuration
