# HTTP Header Monitor with Log Archiving and Web Viewer
## Overview
This project contains a Bash script to monitor HTTP headers of websites, including status codes, redirects, and SSL certificate validity. It automatically saves logs in multiple formats (plain log, CSV, JSON), archives old logs, and includes a simple Python HTTP server to view the logs via a web browser.

## Features
- Monitor multiple websites listed in a text file
- Check HTTP status codes and redirects
- Verify SSL certificate validity and expiration (for HTTPS sites)
- Save results in:
    - Plain log file (.log)
    - CSV format (.csv)
    - JSON format (.json)
- Automatically archive logs older than 7 days into an archive/ folder
- Serve logs over HTTP via a simple Python HTTP server for easy viewing and download

## Requirements
- Bash shell
- curl
- openssl
- Python 3.x

## Setup
1. Edit the sites list: Create or update *sites.txt* with one website URL per line, for example:

```
https://example.com
http://another-site.org
# Lines starting with # are ignored
```
2. Run the monitoring script
```
./http_header_monitor.sh
```
This will create timestamped log files inside the logs/ directory.

3. Start the HTTP server to view logs

```
python3 serve_logs.py
```

Then open your browser and navigate to http://localhost:8000 to browse and download logs.

## How It Works
- The script reads URLs from sites.txt, fetches HTTP headers, and extracts status codes and redirects.

- For HTTPS URLs, it checks SSL certificate expiration date.

- Results are appended to three output files per run: log (.log), CSV (.csv), and JSON (.json).

- Logs older than 7 days are moved to the archive/ directory automatically.

- The Python HTTP server serves files from the logs/ directory on port 8000.

## Customization
- Modify **sites.txt** to add/remove sites to monitor.

- Adjust log retention by changing the ```-mtime +7``` parameter in the script (currently archives logs older than 7 days).

- Change server port in ```serve_logs.py``` by modifying the PORT variable.

## Notes
- Ensure curl and openssl are installed on your system.

- The HTTP server is basic and intended for local or trusted network use only.

- Logs are saved with timestamps to avoid overwriting.

## simple web server interface 
![screen](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Bashscripts/HTTP-Monitoring/webserver_screen.png)
