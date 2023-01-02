if [ -z ${podman+x} ]; then
  podman="podman"
fi

# 공통 인수
SET_COMMON_ARGS="COMMON_ARGS=\" \
-itd \
--name \$SERVER_NAME \
-p\$SERVER_PORT \
-p\$SERVER_PORT/udp \
-p\$SERVER_SPORT/udp \
-v $1/\$SERVER_NAME/addons:/app/fof/addons:Z \
-v $1/\$SERVER_NAME/cfg:/app/fof/cfg:Z \
-v $1/\$SERVER_NAME/MOTD.txt:/app/fof/MOTD.txt:Z \
-e PORT=\$((27015 + \$SERVER_NUMBER)) \
-e SPORT=\$((27015 + \$SERVER_NUMBER)) \
-e MAXPLAYERS=\$MAXPLAYERS \
\""

# 4팀 슛아웃
SERVER_NAME=fof_4team_shootout
SERVER_NUMBER=0
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=20

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS fof_server

# 개인전 슛아웃
SERVER_NAME=fof_noteam_shootout
SERVER_NUMBER=1
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=16

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS fof_server

# 팀플레이
SERVER_NAME=fof_teamplay
SERVER_NUMBER=2
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=tp_loothill

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# Versus
SERVER_NAME=fof_versus
SERVER_NUMBER=3
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=vs_desert

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# Break Bad
SERVER_NAME=fof_breakbad
SERVER_NUMBER=4
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=fof_fistful

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# Elimination
SERVER_NAME=fof_elimination
SERVER_NUMBER=5
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=fof_fistful

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# 협동
SERVER_NAME=fof_coop
SERVER_NUMBER=6
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=cm_forest

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# 협동 (봇 없음)
SERVER_NAME=fof_coop_nobot
SERVER_NUMBER=7
SERVER_PORT=$((27015 + $SERVER_NUMBER)):$((27015 + $SERVER_NUMBER))
SERVER_SPORT=$((26900 + $SERVER_NUMBER)):$((26900 + $SERVER_NUMBER))
MAXPLAYERS=24
MAP=cm_forest

eval $SET_COMMON_ARGS
$podman run $COMMON_ARGS -e MAP=$MAP fof_server

# MOTD 웹 서버
$podman run --rm -it -d -p8090:80 --name frontend -v /home/core/frontend:/public:Z joseluisq/static-web-server:2-alpine
