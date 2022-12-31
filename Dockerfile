FROM alpine:3

WORKDIR /app

COPY . /app 

CMD [ "./server_operator.sh" ]
