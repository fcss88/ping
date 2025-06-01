# Full-Stack Monitoring Stack with Docker

This project provides a full-stack monitoring solution using **Prometheus**, **Grafana**, **Node Exporter**, and **Alertmanager**. It is designed for system and infrastructure observability using Docker Compose.

## 📦 Stack Components

- **Prometheus** – Metrics collection and storage
- **Grafana** – Metrics visualization
- **Node Exporter** – Exposes system-level metrics
- **Alertmanager** – Handles alerting rules from Prometheus

## 📁 Project Structure
```
monitoring-stack/
│
├── docker-compose.yml # Compose configuration
├── .env # Environment variables
├── Makefile # Simple automation commands
│
├── prometheus/
│ ├── prometheus.yml # Main config file
│ └── alert.rules.yml # Alerting rules
│
├── grafana/
│ ├── dashboards/
│ │ └── custom-dashboard.json # Predefined Grafana dashboard
│ └── provisioning/
│ ├── datasources/
│ │ └── datasource.yml
│ └── dashboards/
│ └── dashboards.yml
│
└── alertmanager/
└── config.yml # Alertmanager configuration
```
## 🚀 Getting Started

### Preconditions

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- `make` utility (Optional)

### Setup

Clone the repository/directory.
- Start the stack: ```docker compose --env-file .env up -d```

- Or using make: ```make up```

**Access the services:**

- Grafana	http://localhost:3000	admin / admin
- Prometheus	http://localhost:9090	—
- Alertmanager	http://localhost:9093	—
- Node Exporter	http://localhost:9100/metrics	—

*You can change the ports and credentials in the .env file.*

## 📊 Dashboards
Grafana will automatically load the pre-configured dashboard located in 
```grafana/dashboards/custom-dashboard.json.```

To create your own:

Export from Grafana UI and save as JSON in the dashboards folder.  Reference in ```dashboards.yml```

## 🔔 Alerts
Prometheus loads alerting rules from prometheus/alert.rules.yml and forwards them to Alertmanager, configured in alertmanager/config.yml.

## 🛠 Useful Commands
```
make up            # Start the stack
make down          # Stop the stack
make restart       # Restart all services
make logs          # Show logs
make clean         # Tear down all containers and volumes
make prometheus-config-check # Validate prometheus.yml
```


## 📬 Notifications
You can configure Alertmanager to send alerts to:

- Email
- Slack
- Telegram
- Webhooks
- etc.

Customize alertmanager/config.yml to suit your notification preferences.




Feel free to modify and adapt this stack to monitor your infrastructure more efficiently 🚀 