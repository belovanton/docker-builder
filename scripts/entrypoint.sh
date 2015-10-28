#!/bin/bash
set -e

echo >&2 "Initializing xdebug"

#source ~/.profile

exec "$@"
