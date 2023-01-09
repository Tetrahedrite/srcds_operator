FROM node:19-alpine

RUN apk add --no-cache bash curl jq podman 

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app 

STOPSIGNAL SIGKILL

ENTRYPOINT [ "./operator.sh" ]
