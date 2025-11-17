# 🧰 Winget Auto-Updater (Dated ZIP Archive & Log Cleanup)
This project provides a PowerShell-based automation tool for performing Winget package updates, generating a dated text report, archiving all reports into a timestamped ZIP file, and cleaning up temporary log files.

**It consists of two files:**

 ```winget-auto-updater-archive-dated.ps1``` — PowerShell script

 ```WingetAutoUpdaterArchiveDated.xml``` — Task Scheduler configuration for automated daily execution

## ⭐ Features
- Updates Winget sources

- Retrieves all available package updates

- Separates known-version vs unknown-version packages

- Generates a timestamped report: ```winget_report_YYYYMMDD_HHMMSS.txt```

- Stores temporary reports in: **Documents\WingetReports**. Automatically archives the whole directory into a ZIP: *Desktop\WingetReports_YYYYMMDD_HHMMSS.zip**. Deletes all .txt logs after archiving

- Safe directory creation and cleanup

- Fully automatable with Windows Task Scheduler


## ⚙️ Requirements
- Windows 10 or Windows 11

- PowerShell 5.1+ or PowerShell 7+

- Winget installed and available in PATH

Allow local script execution: ```Set-ExecutionPolicy RemoteSigned -Scope CurrentUser```

## ▶️ How to Use
1. Place the files
Put both project files into the same folder, for example:

C:\Tools\WingetAutoUpdater\

2. Run script manually (optional) ```.\winget-auto-updater-archive-dated.ps1```
After execution:

📌 A ZIP archive appears on your Desktop: *WingetReports_YYYYMMDD_HHMMSS.zip*

📌 Temporary .txt logs from Documents\WingetReports are removed.

## 🗓 Set Up Automatic Daily Execution
1. Open Task Scheduler
Press Win + R, enter: ```taskschd.msc```

2. Import the XML task
Select:
Action → Import Task → WingetAutoUpdaterArchiveDated.xml

3. Adjust settings
You may customize:

- Trigger time (default in XML: once per day)

- User (set to your account)

- Script path (must match your folder)

- Enable “Run with highest privileges”

### 🔧 Script Logic Summary
Create folder: **Documents\WingetReports**

Update Winget sources

Retrieve all upgradeable packages

Separate records:

- known version

- unknown version

- Generate a .txt report

- Archive the entire WingetReports folder into a ZIP on Desktop

- Delete all .txt logs from the report folder

### 🛠 Troubleshooting
- **ZIP is empty or corrupt**
Ensure .NET compression library is available (default on Win10/11).

- **Task does not run**
  - ✔ Check script path
  - ✔ Ensure execution policy allows scripts
  - ✔ Turn on: ```Run with highest privileges```
- **Winget command not found**
Check PATH: ```winget --version```
