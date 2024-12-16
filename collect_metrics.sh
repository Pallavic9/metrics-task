#!/bin/bash

# Node Exporter URL (assumes running in Minikube and accessible via NodePort or ClusterIP)
NODE_EXPORTER_URL="http://node-exporter-service.monitoring:9100/metrics"

# Output directory for storing metrics files
OUTPUT_DIR="/metrics-output"

# Create timestamped filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="${OUTPUT_DIR}/metrics_${TIMESTAMP}.txt"

# Fetch metrics and save to file
curl -s ${NODE_EXPORTER_URL} -o ${FILENAME}

if [ $? -eq 0 ]; then
    echo "Metrics collected and saved to ${FILENAME}"
else
    echo "Failed to collect metrics from ${NODE_EXPORTER_URL}"
    exit 1
fi
