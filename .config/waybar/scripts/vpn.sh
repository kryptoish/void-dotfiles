#!/usr/bin/env bash

# Find active VPN connection
active_vpn=$(nmcli -t -f TYPE,NAME connection show --active 2>/dev/null | grep -E "^(vpn|wireguard):" | head -n 1 | cut -d: -f2)

if [ "$1" = "toggle" ]; then
    if [ -n "$active_vpn" ]; then
        nmcli connection down "$active_vpn" >/dev/null 2>&1
    else
        # Try to connect to first configured VPN (e.g. UBC myVPN)
        vpn_to_connect=$(nmcli -t -f TYPE,NAME connection show 2>/dev/null | grep -E "^(vpn|wireguard):" | head -n 1 | cut -d: -f2)
        if [ -n "$vpn_to_connect" ]; then
            nmcli connection up "$vpn_to_connect" >/dev/null 2>&1
        fi
    fi
    pkill -RTMIN+8 waybar 2>/dev/null
    exit 0
fi

if [ -n "$active_vpn" ]; then
    echo "{\"text\":\"󰖂 ${active_vpn}\",\"tooltip\":\"VPN Connected: ${active_vpn}\\nLeft-click: Disconnect\\nRight-click: Connection Editor\",\"class\":\"connected\"}"
else
    configured_vpn=$(nmcli -t -f TYPE,NAME connection show 2>/dev/null | grep -E "^(vpn|wireguard):" | head -n 1 | cut -d: -f2)
    if [ -n "$configured_vpn" ]; then
        echo "{\"text\":\"󰖂 VPN: Off\",\"tooltip\":\"VPN Disconnected (${configured_vpn})\\nLeft-click: Connect to ${configured_vpn}\\nRight-click: Connection Editor\",\"class\":\"disconnected\"}"
    else
        echo "{\"text\":\"󰖂 No VPN\",\"tooltip\":\"No VPN configured\\nRight-click: Connection Editor to add VPN\",\"class\":\"disabled\"}"
    fi
fi
