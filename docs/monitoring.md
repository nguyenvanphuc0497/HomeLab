# Monitoring System

We use a standard stack to monitor the health of our HomeLab:

*   **Prometheus:** Collects metrics.
*   **Grafana:** Visualizes metrics.
*   **Node Exporter:** Exposes host hardware metrics.

## 🚀 Deployment

The monitoring stack is included in the `raspi5` deployment.
```bash
cd ~/HomeLab/servers/raspi5
make deploy
```

## 📊 Accessing Dashboards

### Grafana (Visualization)
*   **URL:** `http://<IP-RASPI-5>:3001`
*   **Default User:** `admin`
*   **Default Password:** `admin` (Change this upon first login!)

### Prometheus (Debug)
*   **URL:** `http://<IP-RASPI-5>:9090`

## 🛠 Configuration

### Adding Dashboard
1.  Login to Grafana.
2.  Go to **Dashboards** -> **New** -> **Import**.
3.  Enter ID **1860** (Node Exporter Full) and click **Load**.
4.  Select `Prometheus` as the data source.
5.  Click **Import**.
6.  *(Optional)* For Docker Container monitoring (cAdvisor), import ID **14282**.

### Data Persistence
*   Prometheus data is stored in Docker volume `monitoring_prometheus_data`.
*   Grafana data is stored in `monitoring_grafana_data`.
