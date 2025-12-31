#!/bin/bash
if [ -e ~/.epic/main/bs ]
then
	echo "chain_data exists - no bootstrap needed..."
else
	echo "Setting up bootstrap chain_data file..."
	wget -nv --show-progress --no-check-certificate https://bootstrap.epiccash.com/bootstrap.zip -P ~/.epic/main
	rm -R ~/.epic/main/chain_data
	unzip ~/.epic/main/bootstrap.zip -d ~/.epic/main
	rm ~/.epic/main/bootstrap.zip
	touch ~/.epic/main/bs
	echo "Done"
fi

/usr/bin/screen -dmS epicnode /home/epicsvcs/epic-node
#/usr/bin/screen -dmS epicbox /home/epicsvcs/epicbox

# check for cert if not there then run certbot to create certs

if [ -e /etc/letsencrypt/live/node.mydomain.somedomain.dom/fullchain.pem ]
then
   echo "Certs Exist"
else
   sudo certbot --nginx --non-interactive --agree-tos -m webmaster@example.com -d node.mydomain.somedomain.dom
fi
tail -f /dev/null


