#!/bin/bash
# Script to play an inaudible mp3 periodically, perhaps to keep a soundbar from entering power save mode and turning off all the time?
ffplay -volume 4 /var/home/me/configs/scripts/keepalive/keepalive.mp3 -autoexit -nodisp 

