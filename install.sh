#!/bin/bash
#
# Mod by Dv-server
# ==================================================
echo "<BODY text='ffffff'>" > admin.sh
clear
# go to root
cd

# Install Command
apt-get -y install ufw
apt-get -y install sudo

# set repo
wget -O /etc/apt/sources.list "http://netspeedvpn.esy.es/BANK/sources.list.debian8"
wget "http://netspeedvpn.esy.es/BANK/dotdeb.gpg"
wget "http://netspeedvpn.esy.es/BANK/jcameron-key.asc"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
cat jcameron-key.asc | apt-key add -;rm jcameron-key.asc

# update
apt-get update

# install webserver
apt-get -y install nginx

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

echo -e "\033[1;32m "
# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | sudo tee -a /etc/apt/sources.list
curl -L "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" -o Release-neofetch.key && sudo apt-key add Release-neofetch.key && rm Release-neofetch.key
apt-get update
apt-get install neofetch

echo "clear" >> .bashrc
echo -e " "
echo 'echo -e "\033[01;32m  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  {    Wallcom to server Debian7-8     }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  { Script mod by  Dv-Server }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo 'echo -e "  {   prin { menu } Show menu items    }"' >> .bashrc
echo 'echo -e "  }~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{"' >> .bashrc
echo -e "\033[1;33m"

# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://netspeedvpn.esy.es/BANK/nginx.conf"
mkdir -p /home/vps/public_html
echo "smile" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "http://netspeedvpn.esy.es/BANK/vps.conf"
service nginx restart

echo -e "\033[1;34m"
# install openvpn
wget -O /etc/openvpn/openvpn.tar "http://netspeedvpn.esy.es/BANK/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "http://netspeedvpn.esy.es/BANK/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "http://netspeedvpn.esy.es/BANK/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

echo -e "\033[1;35m "
# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/Test.ovpn "http://netspeedvpn.esy.es/BANK/client-1194.conf"
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/openvpn/Test.ovpn;
cp Test.ovpn /home/vps/public_html/

echo -e "\033[1;36m "
# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "http://netspeedvpn.esy.es/BANK/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "http://netspeedvpn.esy.es/BANK/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

echo -e "\033[1;31m "
# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
service ssh restart

echo -e "\033[1;32m "
# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

echo -e "\033[1;33m"
# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "http://netspeedvpn.esy.es/BANK/squid3.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart


# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.870_all.deb"
dpkg --install webmin_1.870_all.deb;
apt-get -y -f install;
rm /root/webmin_1.870_all.deb
service webmin restart
service vnstat restart

echo -e "\033[1;35m"
# download script
cd /usr/bin
wget -O menu "http://netspeedvpn.esy.es/BANK/menu.sh"
wget -O a "http://netspeedvpn.esy.es/BANK/adduser.sh"
wget -O b "http://netspeedvpn.esy.es/BANK/testuser.sh"
wget -O c "http://netspeedvpn.esy.es/BANK/rename.sh"
wget -O d "http://netspeedvpn.esy.es/BANK/repass.sh"
wget -O e "http://netspeedvpn.esy.es/BANK/delet.sh"
wget -O f "http://netspeedvpn.esy.es/BANK/deletuserxp.sh"
wget -O g "http://netspeedvpn.esy.es/BANK/viewuser.sh"
wget -O h "http://netspeedvpn.esy.es/BANK/restart.sh"
wget -O i "http://netspeedvpn.esy.es/BANK/speedtest.py"
wget -O j "http://netspeedvpn.esy.es/BANK/online.sh"
wget -O k "http://netspeedvpn.esy.es/BANK/viewlogin.sh"
wget -O l "http://netspeedvpn.esy.es/BANK/aboutsystem.sh"
wget -O m "http://netspeedvpn.esy.es/BANK/lock.sh"
wget -O n "http://netspeedvpn.esy.es/BANK/unlock.sh"
wget -O o "http://netspeedvpn.esy.es/BANK/httpinstall.sh"
wget -O p "http://netspeedvpn.esy.es/BANK/httpcredit.sh"
wget -O q "http://netspeedvpn.esy.es/BANK/aboutscrip.sh"
wget -O r "http://netspeedvpn.esy.es/BANK/TimeReboot.sh"

echo "30 3 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x a
chmod +x b
chmod +x c
chmod +x d
chmod +x e
chmod +x f
chmod +x g
chmod +x h
chmod +x i
chmod +x j
chmod +x k
chmod +x l
chmod +x m
chmod +x n
chmod +x o
chmod +x p
chmod +x q
chmod +x r

echo -e "\033[1;36m "
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo -e "\033[1;32m =============
 Smile figther
 =============
 Service 
 ---------------------------------------------
 OpenSSH  : 22, 143 
 Dropbear : 80, 443 
 Squid3   : 8080, 3128 (limit to IP SSH) 
 Config   : OpenVPN (TCP 1194)
 =============================================
 badvpn   : badvpn-udpgw port 7300 
 nginx    : 81 
 Webmin   : http://$MYIP:10000/ 
 Timezone : Asia/Thailand (GMT +7) 
 IPv6     : [off] 
 =============================================
 Credit.  :  By Dv-Server
 FaceBook :  https://www.facebook.com
 Line     : 0958895648
 Wallet  : 0958895648
 ============================================="
echo " VPS AUTO REBOOT 00.00"
echo " ===================================== " 
echo " prin { menu } show list on menu "
echo " ===================================== "
cd
rm -f admin.sh
rm -f install.sh
