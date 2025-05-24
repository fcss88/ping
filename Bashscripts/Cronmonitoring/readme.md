# Scenario for monitoring 
**logs** directory for csv\json\log-files

## Usage
for logfile
```bash
 .\system_monitoring.sh
 ```

for csv\json file
```bash
.\system_monitorinh_json_csv.sh
```


## cronjob
run ```crontab -e```


```
# every five minutes
*/5 * * * * /path/to/system_monitor.sh
```

for correct schedule use  [crontab guru ](https://crontab.guru/)
