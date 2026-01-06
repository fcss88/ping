# NetTesterGUI

*A lightweight Windows GUI tool written in PowerShell (WinForms) for testing TCP connectivity using host:port format. Designed as a small but complete DevOps-style utility with persistent history and portable execution.*


### ✨ Features

Simple GUI (WinForms)

Input format: host:port

TCP connectivity test (via Test-NetConnection)

Enter → Test support

Persistent hosts history stored in hosts.txt

Auto-create hosts.txt if missing

ComboBox with previously tested targets

Colored status feedback (Success / Failed)

Timestamped history list

Can be compiled into a single portable EXE

### 🖥️ Screenshots
![screen1](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Powershell/Test-NetConnection-GUI/screen1.png)

![screen2](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Powershell/Test-NetConnection-GUI/screen2.png)

![screen3](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Powershell/Test-NetConnection-GUI/screen3.png)

![screen4](https://raw.githubusercontent.com/fcss88/ping/refs/heads/main/Powershell/Test-NetConnection-GUI/screen4.png)

### 📁 Project Structure
```
NetTesterGUI/
│
├─ NetTesterGUI.ps1   # Main GUI application
├─ hosts.txt          # Stored targets (auto-created)
├─ README.md
└─ NetTesterGUI.exe   # (optional, generated)
```

### 🚀 Usage (PowerShell script)
**Requirements**

Windows

PowerShell 5.1+

No admin rights required

Run from PowerShell
```powershell.exe -STA -ExecutionPolicy Bypass -File .\NetTesterGUI.ps1```

**Important:**  -STA is required for WinForms applications.

### 🧪 Input Format
```
google.com:443
192.168.88.1:80
ukr.net:443
```
Invalid input is highlighted in red

Valid new entries are automatically saved to hosts.txt

### 🗂 hosts.txt Behavior

Automatically created in the same directory as the script / exe

One entry per line

Used to populate the ComboBox on startup

New valid entries are appended automatically

Example:
```
google.com:443
ukr.net:443
192.168.88.1:80
```

### 📦 Build EXE (PS → EXE)

The application can be compiled into a standalone executable using PS2EXE.

### 1️⃣ Install PS2EXE

Run once:
```
Install-Module PS2EXE -Scope CurrentUser
```

**$ Verify installation:** ```Get-Command ps2exe```

### 2️⃣ Build executable

From the project directory:
```
ps2exe .\NetTesterGUI.ps1 .\NetTesterGUI.exe `
  -noConsole `
  -title "Net Tester GUI" `
  -description "TCP connectivity checker (host:port)" `
  -version 1.0.0 `
  -company "CompanyName"
```

#### Flags explained

**Flag** Purpose
- **noConsole**	Prevents console window
- **title**	Window title
- **description**	File metadata
- **version**	Application version
- **company**	Company / author name
 
### 3️⃣ Run EXE
NetTesterGUI.exe

📌 Place hosts.txt next to the EXE (or it will be created automatically).

### ⚠️ Notes

The EXE internally uses PowerShell — this is normal

Windows SmartScreen may warn about unsigned executables

This tool is intended for internal / admin / DevOps usage

### 🧠 Design Notes

WinForms was chosen for maximum compatibility (PowerShell 5.1)

No background jobs or async runspaces to avoid GUI deadlocks

Focus on reliability over complexity

Portable by design (no registry, no dependencies)

### 👤 Author

- [@fcss88](https://www.github.com/fcss88)
