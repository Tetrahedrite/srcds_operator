#!/bin/bash
# $1 = App ID (eg. 295230 for Fistful of Frags)
# $2 = Current Version (eg. 10228840)
# $3 = Server Container Prefix (eg. fof_)

export podman="/usr/bin/podman --remote "

echo "SRCDS Server Operator Started"


APP_ID=$1
CURRENT_VERSION="$2"
SERVER_CONTAINER_PREFIX=$3

SLEEP_DURATION=5m
SLEEP_BEFORE_UPDATE=1m
IMAGE_PATH=/app/build
IMAGE_NAME=fof_server

while true; do
echo "Checking newer version of app id $APP_ID, current version = $CURRENT_VERSION"
NEED_TO_UPDATE=false
# Query until find new update
while ! $NEED_TO_UPDATE; do
  echo "Querying new version..."
  LAST_VERSION=$(curl https://api.steamcmd.net/v1/info/$1 | jq ".data[\"$1\"].depots.branches.public.buildid" | tr -d '"')
  echo "New version = $LAST_VERSION"
  if [ ${#LAST_VERSION} -le 10 ] && [ $LAST_VERSION != $CURRENT_VERSION ]; then
    NEED_TO_UPDATE=true
  fi
  if ! $NEED_TO_UPDATE; then
    echo "No need to update, Sleep for $SLEEP_DURATION"
    sleep $SLEEP_DURATION
  fi
done

echo "Found update: try to upgrade $CURRENT_VERSION to $LAST_VERSION"

# Get all server container
echo "Getting server RCON ports..."
PORT=$($podman ps --format="{{.Names}}" | xargs -n 1 $podman inspect | jq ".[0].Config.Env" | grep "\"PORT=" | cut -d\" -f2 | cut -d= -f2)
echo "Got RCON ports: $PORT"

# Send RCON message to every server
echo "Sending RCON message to server..."
echo "$PORT" | xargs -n 1 -I % sh -c 'node srcds-rcon.js 172.16.4.1 % "There is server update. Server will be restarted after 1 minute. Thank you very much!"'
echo "$PORT" | xargs -n 1 -I % sh -c 'node srcds-rcon.js 172.16.4.1 % "서버 업데이트가 준비되어 있습니다. 1분 후 업데이트와 함께 서버가 재시작 될 예정입니다. 감사합니다!"'

# Sleep until perform update
echo "Sleeping $SLEEP_BEFORE_UPDATE until perform update..."
sleep $SLEEP_BEFORE_UPDATE

# Stop and remove all container
# CONTAINER_LIST=$($podman ps -a --format="{{.Names}}")
# echo $CONTAINER_LIST | xargs $podman stop
# echo $CONTAINER_LIST | xargs $podman rm
echo "Stopping all servers..."
./rm_all_server.sh
# podman ps -a --format="{{.Names}}" | grep fof_ | xargs podman stop | xargs podman rm

# Perform update image
echo "Performing update image..."
pushd $IMAGE_PATH
$podman build -t fof_server:latest .
$podman build -t fof_server:$LAST_VERSION .
popd

# Run all container
echo "Run all server back!"
pushd $IMAGE_PATH
$(dirs +1)/run_all_server.sh /home/core/buildtest
popd

CURRENT_VERSION=$LAST_VERSION

echo "Retry to checking another update. with current version $CURRENT_VERSION"

done
