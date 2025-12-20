# Winget Workstation Installer

A professional, automation-ready toolkit for deploying and maintaining a Windows workstation using **Winget**.
The project supports both **CLI (Batch + PowerShell)** and **GUI (WPF)** modes and installs applications from a centralized list file.

Designed for DevOps engineers, system administrators, and power users who value reproducibility, speed, and clean architecture.

---

## 🎯 Purpose

This repository provides a structured solution for:

* Automated installation of Windows applications
* Centralized software management via list file
* Pre-install package verification
* Logging with timestamps
* Progress visualization (GUI)
* Enterprise-ready deployment workflows

You define the software once — the toolkit does the rest with discipline and elegance.

---

## 📁 Project Structure

```
winget-workstation-installer/
│
├── install.cmd                # Main Batch launcher (entry point)
├── install.ps1                # Core PowerShell installation engine
├── install-GUI.ps1            # Optional WPF graphical interface
│
├── packages.lst.example       # Example software list (template)
├── packages.lst               # Your real package list (gitignored)
│
├── logs/
│   └── install_DDMMYYYY_HH-MM.log
│
└── README.md
```

---

## 🧠 How It Works

1. `install.cmd` launches PowerShell with elevated privileges
2. `install.ps1` reads `packages.lst`
3. Each package is:

   * Checked if already installed
   * Installed if missing
4. Winget sources are updated
5. All existing packages are upgraded
6. Full log is saved with timestamp

Optional:

* `install-GUI.ps1` provides visual control and progress bar

---

## 📦 packages.lst format

Each line contains a Winget package ID. Comments are allowed.

Example:

```txt
# Browsers
Google.Chrome
Mozilla.Firefox

# Dev tools
Git.Git
Microsoft.VisualStudioCode
Docker.DockerDesktop
```

You may copy the example file:

```bash
copy packages.lst.example packages.lst
```

---

## ▶ Running the installer

### Console mode (recommended for automation)

```cmd
install.cmd
```

### GUI mode

```powershell
powershell -ExecutionPolicy Bypass -File install-GUI.ps1
```

---

## 📜 install.cmd explained

```bat
@echo off
pushd %~dp0
powershell -ExecutionPolicy Bypass -File install.ps1
pause
```

### What is %~dp0?

`%~dp0` = full path to the directory where the batch file is located.

This ensures the script always runs from its own folder, regardless of where it is launched from. A cornerstone of reliable automation.

---

## ⚙ Core Features

✅ Winget source update before operations
✅ Package existence verification
✅ Clean logging system
✅ Timestamped logs
✅ Automatic upgrade of installed apps
✅ Modular structure
✅ GUI with progress bar

---

## 📝 Logging system

Logs are stored in:

```
logs/install_DDMMYYYY_HH-MM.log
```

Example:

```
install_21032025_17-45.log
```

Log includes:

* Installer start time
* Installed packages
* Skipped packages
* Errors
* Completion status

---

## 🔄 Upgrade behaviour

Before installation begins, the script runs:

```powershell
winget upgrade --all --accept-source-agreements --accept-package-agreements
```

This guarantees all existing packages are updated to latest versions.

---

## 🧪 Pre-check logic

Each package is validated:

```powershell
winget list --id <PACKAGE>
```

If found → skipped
If not found → installed

This avoids redundancy and preserves system sanity.

---

## 🖥 GUI Mode (WPF)

The graphical interface provides:

* Start button
* Real-time progress bar
* Live installation log
* Status feedback

Perfect for semi-automated deployments or human-friendly workflows.

---

## 🔐 Requirements

* Windows 10/11
* Winget installed
* PowerShell 5.1 or higher
* Administrator privileges

Check Winget:

```powershell
winget --version
```

---

## 🚀 Recommended Usage

* Corporate workstation provisioning
* New laptop setup
* Fresh system bootstrap
* Golden image deployment

---

## 🧩 Customisation

You can extend this project with:

* Multiple package profiles
* Role-based lists (DevOps, QA, Design)
* Silent mode
* Scheduled execution
* Network deployment

---

## 🤝 Contribution

Feel free to fork and evolve the project. Pull requests are welcome for:

* New automation features
* UX improvements
* Script optimizations
* Documentation additions

---

## ⭐ Closing note

This project is built with a philosophy:

> Automation should be clean. Configuration should be human.
> Repetition belongs to scripts, not to engineers.

If you value predictable systems and elegant solutions — this toolkit will feel like home.
