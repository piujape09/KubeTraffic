# Observability — Prometheus + Grafana

The Helm chart ships an optional `nginx-prometheus-exporter` sidecar plus a
`ServiceMonitor`. Enable both when installing the chart on a cluster that has
the kube-prometheus-stack operator running.

## 1. Install kube-prometheus-stack (once per cluster)

```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack `
  --namespace monitoring --create-namespace
```

## 2. Enable nginx stub_status

The exporter scrapes `http://localhost/stub_status`. Add this snippet to your
nginx config (or override via a ConfigMap-mounted `default.conf`):

```nginx
location = /stub_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
}
```

## 3. Install KubeTraffic with metrics on

```powershell
helm upgrade --install kubetraffic .\helm\kubetraffic `
  --set metrics.enabled=true `
  --set metrics.serviceMonitor.enabled=true
```

## 4. Open Grafana

```powershell
kubectl -n monitoring port-forward svc/prometheus-grafana 3000:80
# user: admin   pass: prom-operator
```

Import dashboard **12708** ("NGINX exporter") for an instant view of
request rate, active connections, and HPA-relevant load.

## 5. Demo it

While the load generator is running:

```powershell
kubectl apply -f .\manifests\load-generator.yml
```

Grafana shows requests/sec climbing, and `kubectl get hpa -w` shows replicas
scaling in lockstep.
