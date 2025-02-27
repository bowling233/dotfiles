#!/bin/bash
set -x

case $1 in
  "up")
    wg-quick up config/wg_confs/wg0.conf
    ;;
  "down")
    wg-quick down config/wg_confs/wg0.conf
    ;;
  *)
    echo "Invalid argument"
    ;;
esac
