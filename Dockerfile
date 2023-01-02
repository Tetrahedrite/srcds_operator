FROM alpine:3

RUN apk add --no-cache bash curl jq podman nodejs npm

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app 

STOPSIGNAL SIGKILL

ENTRYPOINT [ "./operator.sh" ]
