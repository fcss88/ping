# 🐳 Dockerized Flask Web App with Nginx & PostgreSQL

A minimal yet complete example of a Flask web app running in Docker, using Nginx as a reverse proxy and PostgreSQL as a database. Includes `.env` configuration, healthchecks, volume mapping, and convenient `Makefile` automation.

---

## ⚙️ Tech Stack

- 🐍 Flask (Python 3.11)
- 🐘 PostgreSQL 16
- 🌐 Nginx (reverse proxy)
- 🐳 Docker & Docker Compose
- 🔐 `.env` for configuration
- 📈 Healthchecks, named volumes

---

## 📁 Project Structure
```
dockerized-flask-app/
├── app/
│ ├── main.py
│ ├── requirements.txt
├── nginx/
│ └── default.conf
├── .env
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```
---

## 🚀 Quick Start

> Make sure you have **Docker** and **Make** installed.

1. 🔧 Create a `.env` file in the root directory:

```
POSTGRES_DB=flaskdb
POSTGRES_USER=flaskuser
POSTGRES_PASSWORD=flaskpass
```

2. ▶️ Run the app: ```make up```

3. 🌍 Visit in browser: ```http://localhost```

You should see: ✅ Flask is running and connected to the database!

![screen web interface](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Docker/dockerized-flask-app/flask-app-screen.png)




## 🧪 Makefile Commands

Command	Description
**make up**	Start all services in the background
**make down**	Stop and remove containers
**make build**	Rebuild images
**make logs**	Follow logs from all containers
**make restart**	Restart all services
**make shell**	Access a shell inside the Flask app
**make prune**	Clean up unused Docker resources
**make ps**	List running services
**make health**	Check if the app is responding

## ✅ .env Validation
Before launching the app, a pre-check ensures the required environment variables exist:

+ POSTGRES_DB

+ POSTGRES_USER

+ POSTGRES_PASSWORD

If any are missing, the build or launch will halt with a warning.

## 🛡 Architecture Diagram
The architecture is simple and effective:

**User → Nginx → Flask App → PostgreSQL**

![diagram](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Docker/dockerized-flask-app/diagram.png)



Each service runs in its own Docker container and communicates over a shared Docker network.

