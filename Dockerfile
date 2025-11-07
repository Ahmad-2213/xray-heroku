FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache ca-certificates curl tar

# Create app dir
WORKDIR /app

# Download xray-core official release (Linux 64-bit)
RUN curl -L -o xray.tar.gz https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip Xray-linux-64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm Xray-linux-64.zip

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set timezone
ENV TZ=Asia/Colombo

ENTRYPOINT ["/entrypoint.sh"]
