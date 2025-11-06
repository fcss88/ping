# Reverse Proxy with Nginx Proxy Manager, n8n, and Portainer

This project sets up a reverse proxy infrastructure using Nginx Proxy Manager (NPM), with automated HTTPS via Let's Encrypt, and two services behind it:

- [n8n](https://n8n.io): A low-code automation tool.
- [Portainer](https://www.portainer.io): A Docker management UI.

## 🛠️ Stack

- Docker & Docker Compose
- Nginx Proxy Manager (NPM)
- n8n for automation workflows
- Portainer for Docker management
- Let's Encrypt for TLS

## 📦 Services

| Service   | Port | Description                |
|-----------|------|----------------------------|
| NPM       | 80/443 | Reverse proxy with SSL     |
| NPM Admin | 81   | Web UI for proxy setup     |
| n8n       | 5678 | Automation tool            |
| Portainer | 9000 | Docker container UI        |

## 🚀 Setup Instructions

1. Clone this repo and enter the directory.

2. Update `.env` with your domain for n8n.

3. Set DNS A-records for:
    - `n8n.example.com` → your public server IP
    - `portainer.example.com` → same

4. Launch all services:
    ```bash
    make up
    ```

5. Open NPM Admin UI: `http://<server-ip>:81`
    - Default login: `admin@example.com / changeme`

6. In NPM, add two Proxy Hosts:
    - `n8n.example.com` → forward to `http://n8n:5678`
    - `portainer.example.com` → forward to `http://portainer:9000`
    - Enable SSL → Request a new certificate via Let's Encrypt
    - Enable HTTP/2 and Force SSL

7. Access:
    - `https://n8n.example.com` → n8n UI with basic auth
    - `https://portainer.example.com` → Portainer UI

## 📁 Workflow Example (n8n)

We include a sample `workflow.json` that listens to a webhook and posts a Telegram message.

## 🔐 Security Tips

- Change default NPM credentials immediately.
- Use a secure password in `.env`.
- Set up IP allowlists or basic auth in NPM for extra protection.

## 📘 License

MIT. Use it freely and responsibly.
