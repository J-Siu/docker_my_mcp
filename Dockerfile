ARG GO_VERSION=1.27.2
ARG VERSION=v1.0.3

FROM golang:${GO_VERSION}-alpine AS build_base
ARG VERSION

RUN apk add --no-cache git

WORKDIR /src
RUN git clone --depth 1 --branch "${VERSION}" \
	https://github.com/J-Siu/go-my-mcp.git .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" \
	-o /out/go-my-mcp .

FROM alpine:3.23
ARG VERSION
LABEL version=${VERSION}
LABEL maintainers="[John Sing Dao Siu](https://github.com/J-Siu)"
LABEL name="my_mpc"
LABEL usage="https://github.com/J-Siu/docker_my_mpc/blob/master/README.md"
LABEL description="Docker - My MPC (SearXNG and Web Fetch)"
RUN apk add --no-cache ca-certificates \
	&& addgroup -S app \
	&& adduser -S -G app -h /home/app app \
	&& mkdir -p /home/app \
	&& chown app:app /home/app

WORKDIR /home/app
ENV HOME=/home/app

COPY --from=build_base --chown=app:app /out/go-my-mcp /usr/local/bin/go-my-mcp

USER app:app
EXPOSE 9000
ENTRYPOINT ["go-my-mcp"]
