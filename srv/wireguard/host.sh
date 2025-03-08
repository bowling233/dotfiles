#!/bin/bash
set -x

case $1 in
  "up")
    wg-quick up config/wg_confs/wg0.conf
    # systemctl enable wg-quick@wg0.service
    # systemctl start wg-quick@wg0.service
    ;;
  "down")
    wg-quick down config/wg_confs/wg0.conf
    # systemctl disable wg-quick@wg0.service
    # systemctl stop wg-quick@wg0.service
    ;;
  *)
    echo "Invalid argument"
    ;;
esac

