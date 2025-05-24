# Script for compressing big log files
u can add this script for your crontab as a scheduled job

## Usage
Rotate logfile bigger than 10 ЬИ and compress **.log** to ***.gz*** for saving disk space. Create report into log file

## hint and tips
- Variable ```LOG_FILE```  your log file that can be big
- Variable ```ROTATE_LOG``` script log-file
- Variable ```MAX_SIZE_MB``` max filesize, Mb
-  ```: > "$LOG_FILE"``` safe clear log-file after backup 
