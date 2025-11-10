FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache ca-certificates curl unzip bash

# Set timezone
ENV TZ=Asia/Colombo

# Create app dir
WORKDIR /app

# Download and install xray-core
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip -o /tmp/xray.zip -d /tmp/xray \
    && mv /tmp/xray/xray /usr/local/bin/xray \
    && chmod +x /usr/local/bin/xray \
    && rm -rf /tmp/xray /tmp/xray.zip

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose default port (optional)
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
