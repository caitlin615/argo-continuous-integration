# builder image
FROM golang:1.12-alpine3.9 as builder

RUN apk -U add git curl
ENV CGO_ENABLED 0
COPY webhook /webhook
RUN GOPATH=/webhook
RUN cd /webhook && go build -o /bin/webhook
RUN curl -sSL -o /bin/argo https://github.com/argoproj/argo/releases/download/v2.2.1/argo-linux-amd64
RUN chmod +x /bin/argo

# final image
FROM alpine
WORKDIR /hook
COPY --from=builder /bin/webhook /hook/webhook
COPY --from=builder /bin/argo /hook/argo
COPY --from=builder /webhook/argo.yml /hook/argo.yml
ENTRYPOINT [ "" ]
CMD ["/hook/webhook"]
