#!/usr/bin/env python3

import http.server
import socketserver
import os

PORT = 8000
LOG_DIR = "./logs"

os.chdir(LOG_DIR)

class Handler(http.server.SimpleHTTPRequestHandler):
    pass

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving logs at http://localhost:{PORT}")
    httpd.serve_forever()
