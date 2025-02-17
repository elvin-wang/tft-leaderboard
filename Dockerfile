FROM node:16-alpine3.12 as web
WORKDIR /var/www/app
COPY site .
RUN yarn && yarn run build

FROM golang:1.17 as go
WORKDIR /go/src/app
COPY . .
RUN go get -d -v
RUN CGO_ENABLED=0 go build -o /go/bin/tft-leaderboard

FROM gcr.io/distroless/base-debian11
COPY --from=go /go/bin/tft-leaderboard /
COPY --from=web /var/www/app/out /www
ADD example.txt /
CMD ["/tft-leaderboard", "serve", "--app-path", "/www"]
