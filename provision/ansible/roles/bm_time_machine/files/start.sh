#!/bin/bash
setterm --blank 0
setterm --powersave off
setterm --powerdown 0
xset dpms 0 0 0 && xset s noblank && xset s off
DISPLAY=:0 chromium \
	--app=http://localhost/~subject/universe.html \
	--window-position=0,0 \
	--window-size=1920,1080
