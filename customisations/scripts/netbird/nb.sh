#!/bin/bash
netbird status &
sleep 10
#netbird up &
netbird up --management-url https://<enter your netbird server here eg nb.andarton.com.au> --setup-key <enter your netbird key here obtained from the netbird web ui> &
netbird status
