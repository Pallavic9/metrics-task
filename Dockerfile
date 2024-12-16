# Use a minimal base image with curl
FROM alpine:3.18

# Add Bash and Curl
RUN apk add --no-cache bash curl

# Set working directory
WORKDIR /app

# Copy the Bash script
COPY collect_metrics.sh /app/collect_metrics.sh

# Make the script executable
RUN chmod +x /app/collect_metrics.sh

# Create output directory for metrics
RUN mkdir /metrics-output

# Environment variable for the output directory
ENV OUTPUT_DIR=/metrics-output

# Run the Bash script
CMD ["bash", "/app/collect_metrics.sh"]
