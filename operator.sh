#!/bin/sh
# $1 = App ID (eg. 295230 for Fistful of Frags)
# $2 = Current Version (eg. 10228840)
# $3 = Server Container Prefix (eg. fof_)

echo "SRCDS Server Operator Started"

echo "Checking newer version of app id $1, current version = $2"

APP_ID=$1
CURRENT_VERSION="\"$2\""
SERVER_CONTAINER_PREFIX=$3

SLEEP_DURATION=5m
SLEEP_BEFORE_UPDATE=5m

NEED_TO_UPDATE=false

# Query until find new update
while ! $NEED_TO_UPDATE; do
  echo "Querying new version..."
  LAST_VERSION=$(curl https://api.steamcmd.net/v1/info/$1 | jq ".data[\"$1\"].depots.branches.public.buildid")
  echo "New version = $LAST_VERSION"
  if [ ${#LAST_VERSION} -le 10 ] && [ $LAST_VERSION != $CURRENT_VERSION ]; then
    NEED_TO_UPDATE=true
  fi
  if ! $NEED_TO_UPDATE; then
    echo "No need to update, Sleep for $SLEEP_DURATION"
    sleep $SLEEP_DURATION
  fi
done

# Send RCON message to every server
# blahblah

# Sleep until perform update
sleep $SLEEP_BEFORE_UPDATE

# Stop and remove all container
CONTAINER_LIST=$(podman ps -a --format="{{.Names}}")
$CONTAINER_LIST | xargs podman stop
$CONTAINER_LIST | xargs podman rm

# Perform update image

# Start all container

