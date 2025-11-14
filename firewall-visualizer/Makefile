#!/usr/bin/make -f
# Makefile for Firewall Visualizer
SCRIPT=firewall-visualizer.sh

.PHONY: help run json yaml table export install uninstall

help:
	@echo "Firewall Visualizer Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make run            - Run script with auto-detection"
	@echo "  make json           - Output firewall rules in JSON"
	@echo "  make yaml           - Output firewall rules in YAML"
	@echo "  make table          - Output firewall rules in table format"
	@echo "  make export FILE=xx - Export data to file"
	@echo "  make install        - Install script into /usr/local/bin"
	@echo "  make uninstall      - Remove installed script"

run:
	@bash $(SCRIPT)

json:
	@bash $(SCRIPT) --json

yaml:
	@bash $(SCRIPT) --yaml

table:
	@bash $(SCRIPT) --table

export:
ifeq ($(FILE),)
	@echo "ERROR: You must specify FILE=name (e.g. make export FILE=rules.yaml)"
else
	@bash $(SCRIPT) --yaml --export $(FILE)
	@echo "Exported to $(FILE)"
endif

install:
	@sudo cp $(SCRIPT) /usr/local/bin/firewall-visualizer
	@sudo chmod +x /usr/local/bin/firewall-visualizer
	@echo "Installed as /usr/local/bin/firewall-visualizer"

uninstall:
	@sudo rm -f /usr/local/bin/firewall-visualizer
	@echo "Uninstalled firewall-visualizer"