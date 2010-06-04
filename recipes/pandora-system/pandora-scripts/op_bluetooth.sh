#!/bin/sh
#
# Released under the GPL

INTERFACE="`hciconfig | grep "^hci" | cut -d ':' -f 1`"

if [ ${1} = "startup" ]; then
	[ -f ~/.op_btenabled ] && sudo /usr/sbin/hciconfig ${INTERFACE} up pscan && sudo /usr/sbin/bluetoothd ||echo "Bluetooth: User has not enabled Bluetooth." 
else
	
	# Figure out if Bluetooth is running or not
	
	if [ "`hciconfig ${INTERFACE} | grep UP`" ]
	then
		notify-send -u normal "Bluetooth" "Bluetooth is being disabled..." -i /usr/share/icons/hicolor/32x32/apps/blueman.png
		sudo /usr/sbin/hciconfig ${INTERFACE} down
		sudo killall btaddconn
                sudo killall btdelconn
		rm ~/.op_btenabled
	else
		pgrep bluetoothd
		echo $INTERFACE
                if [ $? -ne 1 ]; then
			notify-send -u normal "Bluetooth" "Bluetooth is being enabled..." -i /usr/share/icons/hicolor/32x32/apps/blueman.png
			sudo /usr/sbin/hciconfig ${INTERFACE} down
			sudo /usr/sbin/hciconfig ${INTERFACE} up pscan
			sudo /usr/sbin/bluetoothd
			rm ~/.op_btenabled
			echo true > ~/.op_btenabled
		fi
	fi
fi
