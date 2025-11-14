# Firewall Visualizer

Firewall Visualizer is a Bash-based inspection tool that parses rules from **iptables** or **nftables**, converts them into a structured format, and outputs the result in **table**, **JSON**, or **YAML** formats.  
It can also **export the results to a file**, making it useful for audits, automation pipelines, incident analysis, and DevOps toolchains.

---

## ✨ Features

### 🔥 Multi-firewall Support
- Automatically detects whether the system uses **iptables** or **nftables**
- Optional flags allow manual selection

### 📄 Output Formats
- **Table** (human-friendly)
- **JSON**
- **YAML**

### 💾 Export to File
You can save the parsed firewall rules directly into an output file:
```
./firewall-visualizer.sh --yaml --export rules.yaml
```

## 📦 Single File Script
All logic is contained inside one Bash script:
- rule parsing
- schema normalization
- output formatting
- export subsystem

Perfect for DevOps Linux-focused automation projects.

## 🚀 Usage
Basic usage (auto-detect firewall) ```./firewall-visualizer.sh```

JSON output ```./firewall-visualizer.sh --json```

YAML output ```./firewall-visualizer.sh --yaml```

Export to file ```./firewall-visualizer.sh --json --export firewall-rules.json```

Force iptables mode ```./firewall-visualizer.sh --iptables```

Force nftables mode ```./firewall-visualizer.sh --nftables```

Help ```./firewall-visualizer.sh --help```


### 📂 Project Structure
```
.
├── firewall-visualizer.sh
├── README.md
└── Makefile
```
### 🛠 Requirements
- Bash 4+

- iptables or nftables installed

- Linux-based OS

### 🧪 Testing
You can simulate firewall data on a test machine or container:

Test with iptables:
```
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
```

Test with nftables:
```
sudo nft add table inet testtbl
sudo nft add chain inet testtbl testchain { type filter hook input priority 0 \; }
sudo nft add rule inet testtbl testchain ip protocol tcp accept
sudo nft add rule inet testtbl testchain ip protocol tcp drop
```

Then run: ```./firewall-visualizer.sh --yaml```

### 📘 Future Enhancements (Planned, may be :) )
- Conflict and duplicate rule detection
- Mermaid / GraphViz visualization
- Prometheus export format
- REST API mode (via socat or ncat)
- HTML export


### 👨‍💻 Author
Created for by Oleksandr fcss88@gmail.com.
