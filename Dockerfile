FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache ca-certificates curl unzip

# Create app dir
WORKDIR /app

# Download and extract xray-core
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip xray.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm xray.zip

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set timezone
ENV TZ=Asia/Colombo

ENTRYPOINT ["/entrypoint.sh"]
