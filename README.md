
---

# Kubernetes Node Metrics Collector

This project sets up a **Kubernetes CronJob** to collect metrics (e.g., CPU, memory, disk usage) from Kubernetes nodes using **Prometheus Node Exporter**. The metrics are stored in a PersistentVolume for easy access and debugging. The project is designed to run in a **Minikube** cluster.

## Features
- Collects node metrics from **Prometheus Node Exporter**.
- Uses a **Bash script** to pull metrics and save them as timestamped files.
- Files are stored in a **PersistentVolume** for retention after the pod completes.
- Configurable CronJob scheduling.
- Minikube-compatible setup.

---

## Project Structure

| File Name                   | Description                                                                                  |
|-----------------------------|----------------------------------------------------------------------------------------------|
| `collect_metrics.sh`        | Bash script to fetch metrics from Node Exporter and save them as timestamped files.          |
| `Dockerfile`                | Dockerfile to containerize the Bash script.                                                  |
| `cronjob-metrics.yaml`      | Kubernetes YAML file to define the CronJob that runs the metrics collection script.           |
| `node-expoerter.yaml`       | Kubernetes YAML file to deploy Prometheus Node Exporter as a DaemonSet.                      |
| `node-exporter-svc.yaml`    | Kubernetes YAML file to create a service exposing Node Exporter metrics.                     |
| `pvc.yaml`                  | Kubernetes YAML file to create a PersistentVolumeClaim (PVC) for storing metrics logs.       |
| `pvc-debug.yaml`            | Kubernetes YAML file to create a temporary pod to access the PVC for debugging and log access.|
| `README.md`                 | Documentation for setting up the project.                                                   |

---

## Prerequisites

1. **Minikube** installed and running.
   - Install Minikube: [Minikube Documentation](https://minikube.sigs.k8s.io/docs/start/)
   - Start Minikube:
     ```bash
     minikube start
     ```
2. **kubectl** installed to manage the Kubernetes cluster.
3. **Docker** installed for building container images.

---

## Setup Guide

### Step 1: Clone the Repository
```bash
git clone https://github.com/Pallavic9/metrics-task.git
cd https://github.com/Pallavic9/metrics-task.git
```

---

### Step 2: Build the Docker Image
Build the Docker image for the Bash script using local Docker environment:

```bash
docker build -t pallavic9/metrics:v1.0.0 .
docker push pallavic9/metrics:v1.0.0
```

---

### Step 3: Deploy Prometheus Node Exporter
1. Apply the **Node Exporter DaemonSet**:
   ```bash
   kubectl apply -f node-expoerter.yaml
   ```

2. Expose Node Exporter metrics via a **Service**:
   ```bash
   kubectl apply -f node-exporter-svc.yaml
   ```

3. Verify Node Exporter is running:
   ```bash
   kubectl get pods -n monitoring
   kubectl port-forward svc/node-exporter-service 9100:9100 -n monitoring
   curl http://localhost:9100/metrics
   ```

---

### Step 4: Create PersistentVolumeClaim (PVC)
Set up a PVC to store metrics logs:

```bash
kubectl apply -f pvc.yaml
```

---

### Step 5: Deploy the CronJob
1. Deploy the **CronJob** to collect metrics periodically:
   ```bash
   kubectl apply -f cronjob-metrics.yaml
   ```

2. Verify the CronJob is running:
   ```bash
   kubectl get cronjobs -n monitoring
   kubectl get pods -n monitoring
   ```

---

### Step 6: Access Metrics Logs

1. Deploy the **PVC Debugger Pod** to access the metrics files:
   ```bash
   kubectl apply -f pvc-debug.yaml
   ```

2. Exec into the debugger pod and view the logs:
   ```bash
   kubectl exec -it pvc-debugger -n monitoring -- sh
   ls /metrics-output
   cat /metrics-output/metrics_<timestamp>.txt
   ```

3. Clean up the debugger pod when done:
   ```bash
   kubectl delete pod pvc-debugger -n monitoring
   ```

---

## Customization

### Update CronJob Schedule
The CronJob is set to run every minute (`* * * * *`) by default. To modify the schedule, edit `cronjob-metrics.yaml`:

```yaml
spec:
  schedule: "0 * * * *"  # Example: Run every hour
```

Apply the updated CronJob:
```bash
kubectl apply -f cronjob-metrics.yaml
```

---

## Debugging

1. **Check CronJob Logs**:
   ```bash
   kubectl logs <pod-name> -n monitoring
   ```

2. **Check Node Exporter Logs**:
   ```bash
   kubectl logs <node-exporter-pod-name> -n monitoring
   ```

3. **Access Metrics Files**: Use the PVC Debugger Pod as described in [Step 6](#step-6-access-metrics-logs).

---

## Clean Up

To delete all resources created by this project:
```bash
kubectl delete -f cronjob-metrics.yaml
kubectl delete -f pvc.yaml
kubectl delete -f pvc-debug.yaml
kubectl delete -f node-expoerter.yaml
kubectl delete -f node-exporter-svc.yaml
```

---

## Future Enhancements

- Push metrics to a time-series database (e.g., Prometheus).
- Visualize metrics using Grafana.
- Support additional metric collection tools.

---

## Contributors
- [Pallavi](https://github.com/Pallavic9) - Initial setup and documentation.

---
