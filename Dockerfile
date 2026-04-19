# 最小靜態站：Caddy 自動 serve，比 nginx 更省事
FROM caddy:2-alpine

# 把整包檔案丟到 Caddy 預設 serve 目錄
COPY . /srv/

# Caddyfile：port 80 + CORS + 指向 /srv
RUN echo ':80 {' > /etc/caddy/Caddyfile && \
    echo '    root * /srv' >> /etc/caddy/Caddyfile && \
    echo '    file_server' >> /etc/caddy/Caddyfile && \
    echo '    header Access-Control-Allow-Origin "*"' >> /etc/caddy/Caddyfile && \
    echo '    header Cache-Control "public, max-age=300"' >> /etc/caddy/Caddyfile && \
    echo '}' >> /etc/caddy/Caddyfile

EXPOSE 80
