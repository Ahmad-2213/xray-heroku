FROM teddysun/xray

# Set working directory
WORKDIR /app

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Optional: copy other files in repo into /app (adjust paths as needed)
# COPY . /app

# Set timezone
ENV TZ=Asia/Colombo

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]
