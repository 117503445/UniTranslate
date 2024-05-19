FROM golang:1.21.5 as builder

WORKDIR /workspace

COPY . .

RUN go mod tidy && CGO_ENABLED=0 go build -o app main.go

# FROM bitnami/git:latest
FROM node:18.19.0 as console

ARG CACHEBUST=1

WORKDIR /workspace

RUN git clone https://github.com/xgd16/UniTranslate-web-console.git console

WORKDIR /workspace/console

RUN npm install && npm run build

FROM alpine:latest

WORKDIR /workspace

COPY --from=console /workspace/console/dist ./dist
COPY --from=builder /workspace/app .
COPY --from=builder /workspace/translate.json .

ENTRYPOINT [ "./app" ]