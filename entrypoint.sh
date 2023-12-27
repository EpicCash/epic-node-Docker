#!/bin/bash

if [ -e ~/.epic/main/foundation.json ]
then
	echo "Skipping"
else
	echo "Finishing Up..."
	mkdir -p ~/.epic
	mkdir -p ~/.epic/main
	echo "Done"
fi

echo "Setting locale and Starting Node Server..."
cp /epic/* ~/.epic/main
locale-gen en_US.UTF-8
/bin/screen -dmS node-server /root/epic-node
tail -f /dev/null

