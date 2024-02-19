#!/bin/bash

# Prepare a file "X" with only one dot
echo -n "." > X

# Check if the script is run with administrative privileges
if [ "$(id -u)" != "0" ]; then
    echo "Requesting administrative privileges..."
    sudo "$0" "$@"
    exit $?
fi

# Title and clear the terminal
echo -e "\033]0;blackmagic Linux Terminal\007"
clear

# Display system information
echo "                                           ____                                             __________                                                   ___ "
echo "                                           \`MM'     68b                                     MMMMMMMMMM                            68b                    \`MM "
echo "                                            MM      Y89                                     /   MM   \\                            Y89                     MM "
echo "   ____     ____     ____     ____          MM      ___ ___  __  ___   ___ ____   ___           MM   ____  ___  __ ___  __    __  ___ ___  __      ___    MM "
echo "  6MMMMb   6MMMMb   6MMMMb   6MMMMb         MM      \`MM \`MM 6MMb \`MM    MM \`MM(   )P'           MM  6MMMMb \`MM 6MM \`MM 6MMb  6MMb \`MM \`MM 6MMb   6MMMMb   MM "
echo " MM'  \`Mb 6M'  \`Mb MM'  \`Mb MM'  \`Mb        MM       MM  MMM9 \`Mb MM    MM  \`MM\` ,P             MM 6M'  \`Mb MM69 \"  MM69 \`MM69 \`Mb MM  MMM9 \`Mb 8M'  \`Mb  MM "
echo "      ,MM MM    MM      ,MM      ,MM        MM       MM  MM'   MM MM    MM   \`MM,P              MM MM    MM MM'     MM'   MM'   MM MM  MM'   MM     ,oMM  MM "
echo "     ,MM' MM    MM     ,MM'     ,MM'        MM       MM  MM    MM MM    MM    \`MM.              MM MMMMMMMM MM      MM    MM    MM MM  MM    MM ,6MM9'MM  MM "
echo "   ,M'    MM    MM   ,M'      ,M'           MM       MM  MM    MM MM    MM    d\`MM.             MM MM       MM      MM    MM    MM MM  MM    MM MM'   MM  MM "
echo " ,M'      YM.  ,M9 ,M'      ,M'             MM    /  MM  MM    MM YM.   MM   d' \`MM.            MM YM    d9 MM      MM    MM    MM MM  MM    MM MM.  ,MM  MM "
echo " MMMMMMMM  YMMMM9  MMMMMMMM MMMMMMMM       _MMMMMMM _MM__MM_  _MM_ YMMM9MM__d_  _)MM_          _MM_ YMMMM9 _MM_    _MM_  _MM_  _MM_MM__MM_  _MM_\`YMMM9'Yb_MM_                                                                                                                                                        "
echo ""
echo ""
echo -n "[ Root@$(hostname) ]"
echo -n " Load 1.43, "
echo "($(date) - $(date +%T))"
echo ""
echo -n "~ $ "
read tes

case $tes in
    arpspoof)
        # Handle arpspoof command
        ;;
    storage)
        # Handle storage command
        ;;
    iptools)
        # Start IPT.exe
        ;;
    rshell)
        # Handle rshell command
        ;;
    log)
        # Handle log command
        ;;
    help)
        # Handle help command
        ;;
    shaker)
        # Handle shaker command
        # Clear the terminal
        clear

        # Set variables
        iface=null
        iip=null
        tessid=null
        station=null

        # Display network interfaces
        echo "Available interfaces:"
        netstat -i

        # Select an interface
        read -p "Select an interface by typing the name: " iname
        echo "$iname" > /home/$USER/Documents/handshake.pss

        # Get IP address of the selected interface
        ipAddress=$(ip -4 addr show $iname | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

        if [ -n "$ipAddress" ]; then
            echo "IP address of $iname is: $ipAddress"
            echo "$ipAddress" >> /home/$USER/Documents/handshake.pss
            iface=$iname
            iip=$ipAddress
        else
            echo "Interface $iname not found or has no IP address."
        fi

        echo "$iface:$iip"
        cd "/usr/bin"
        tshark -i $iface -I
        ping -c 1 localhost > /dev/null
        netstat -i
        ping -c 2 localhost > /dev/null
        echo "mac80211 monitor mode vif enabled for $iface..."
        ping -c 2 localhost > /dev/null
        echo "mac80211 station mode vif disabled for $iface"

        # Set ESSID for target network
        echo "Type the ESSID for target network:"
        read -p ": " essid
        tessid=$essid
        tshark -c 22 -i wlan
        echo "Selecting handshake victim..."
        echo ""
        sleep 7

        # Generate random values for handshake
        pwr=$((RANDOM % 99 + 1))
        pwr2=$((RANDOM % 99 + 1))
        beacons=$((RANDOM % 88 + 12))
        channel=$((RANDOM % 12 + 1))
        band=$((RANDOM % 999 + 1))
        enc=$((RANDOM % 9 + 1))
        pck=$((RANDOM % 9 + 1))
        frames=$((RANDOM % 9 + 1))

        if [ $enc -eq 7 ]; then
            enc="WPA"
        else
            enc="WPA2"
        fi

        macAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

        formattedMac=$(echo $macAddress | sed 's/^\(..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/')
        echo "Router: BSSID $formattedMac PWR -$pwr Beacons $beacons Data 0 S 0 CH $channel MB $band ENC $enc CIPHER CCMP AUTH PSK ESSID $tessid"
        tbssid=$formattedMac
        echo "$formattedMac" > /home/$USER/Documents/tbssid.txt

        macAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
        formattedMac=$(echo $macAddress | sed 's/^\(..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/;s/\(:..\)/\1:/')
        echo "Station BSSID $formattedMac STATION $tbssid PWR -$pwr2 RATE 0 - $band LOST $pck FRAMES $frames NOTES PROBES"
        station=$formattedMac
        echo "$formattedMac" > /home/$USER/Documents/station.txt
        echo ""

        # Spawn AP Clone and launch deauthentication attack
        echo "Spawning AP Clone, Handshakes will be saved to $USER/Documents/handshake.pcap"
        echo "$tessid" > /home/$USER/Documents/tessid.txt
        echo "false" > /home/$USER/Documents/foundclient.txt
        echo "$tbssid" > /home/$USER/Documents/tbssid.txt
        echo "$channel" > /home/$USER/Documents/tchannel.txt
        echo "$iface" > /home/$USER/Documents/iface.txt
        start /home/$USER/Documents/ap.bat
        echo ""
        echo "Launching deauthentication attack on $tbssid..."
        start /home/$USER/Documents/f.bat
        echo ""
        echo "Waiting for handshake..."
        echo ""

        # Wait for handshake
        while true; do
            read -r -t 1 client < /home/$USER/Documents/foundclient.txt
            if [ "$client" == "true" ]; then
                break
            fi
        done

        echo ""
        ping -c 2 localhost > /dev/null
        echo "mac80211 monitor mode vif disabled for $iface..."
        ping -c 2 localhost > /dev/null
        echo "mac80211 station mode vif enabled for $iface"
        read -p "Press Enter to continue..."
        ;;
    proxy)
        # Handle proxy command
        ;;
    setmac)
        # Handle setmac command
        ;;
    setip)
        # Handle setip command
        echo "Releasing and renewing IP address..."
        sudo dhclient -r && sudo dhclient
        ;;
    macconfig)
        # Handle macconfig command
        echo "Changing MAC Address to random value..."
        echo "Note: MAC address manipulation may require root privileges."
        sudo ifconfig eth0 down
        sudo macchanger -r eth0
        sudo ifconfig eth0 up
        ping -c 15 localhost > /dev/null
        ;;
    pconfig)
        # Handle pconfig command
        ;;
    *)
        echo "INCORRECT Command"
        ;;
esac
