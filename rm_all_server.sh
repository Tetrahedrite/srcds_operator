if [ -z ${podman+x} ]; then
  podman="podman"
fi

$podman ps -a --format="{{.Names}}" | grep fof_ | xargs $podman stop | xargs $podman rm
