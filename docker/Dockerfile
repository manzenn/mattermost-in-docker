FROM node:20-bookworm-slim AS webapp-builder

WORKDIR /build
COPY webapp/ ./webapp/

WORKDIR /build/webapp
RUN npm ci --legacy-peer-deps && npm run build


FROM golang:1.24-bookworm AS server-builder

WORKDIR /build
COPY server/ ./server/

WORKDIR /build/server
RUN apt-get update && apt-get install -y build-essential
RUN make build-linux


FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 2000 mattermost \
    && useradd --system -u 2000 -g 2000 --no-create-home -s /usr/sbin/nologin mattermost

WORKDIR /opt/mattermost

RUN mkdir -p data logs config plugins client/plugins

COPY --from=server-builder /build/server/bin/mattermost ./bin/
COPY --from=server-builder /build/server/templates ./templates/
COPY --from=server-builder /build/server/i18n ./i18n/
COPY --from=server-builder /build/server/fonts ./fonts/
COPY --from=webapp-builder /build/webapp/channels/dist/ ./client/

RUN chown -R mattermost:mattermost /opt/mattermost \
    && chmod -R o-rwx /opt/mattermost \
    && chmod -R g+w /opt/mattermost

USER mattermost

EXPOSE 8065

CMD ["./bin/mattermost"]
