#!/bin/bash
source /custom-cont-init.d/common.sh || exit 1

SRC="/custom-cont-init.d/TradingViewAgent.desktop"

sync_desktop_file "$SRC" "/config/.config/autostart/TradingViewAgent.desktop"
sync_desktop_file "$SRC" "/config/Desktop/TradingViewAgent.desktop"
