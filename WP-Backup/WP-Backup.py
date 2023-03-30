import os
import subprocess
import zipfile
import datetime
import re

# read wp-config.php file
wp_config_path = '/home/admin/web/mvk1.ml/public_html/wp-config.php'
with open(wp_config_path) as f:
    wp_config = f.read()

# Variables from wp-config.php file
db_name = re.search(r"define\s*\(\s*['\"]DB_NAME['\"]\s*,\s*['\"](\w+)['\"]\s*\)\s*;", wp_config)
if db_name:
    db_name = db_name.group(1)
else:
    print("Error: DB_NAME not found in wp-config.php")

db_user = re.search(r"define\s*\(\s*['\"]DB_USER['\"]\s*,\s*['\"](\w+)['\"]\s*\)\s*;", wp_config)
if db_user:
    db_user = db_user.group(1)
else:
    print("Error: DB_USER not found in wp-config.php")


db_password = re.search(r"define\s*\(\s*['\"]DB_PASSWORD['\"]\s*,\s*['\"](\w+)['\"]\s*\)\s*;", wp_config)
if db_password:
    db_password = db_password.group(1)
else:
    print("Error: DB_PASSWORD not found in wp-config.php")


db_host = re.search(r"define\s*\(\s*['\"]DB_HOST['\"]\s*,\s*['\"]([\w.:]+)['\"]\s*\)\s*;", wp_config)
if db_host:
    db_host = db_host.group(1)
else:
    print("Error: DB_HOST not found in wp-config.php")
    exit()


print(f"Your database credentials:")
print(f"db_name={db_name}", f"db_user={db_user}", f"db_password={db_password}", f"db_host={db_host}")


# Create db-dump file
timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
dump_filename = f'/backup/{db_name}_dump_{timestamp}.sql'

# run mysqldump
mysqldump_cmd = f'mysqldump --user={db_user} --password={db_password} --host={db_host} {db_name} > {dump_filename}'
subprocess.run(mysqldump_cmd, shell=True)

# Create zip-file 
zip_filename = f'/backup/files_{timestamp}.zip'
with zipfile.ZipFile(zip_filename, 'w', compression=zipfile.ZIP_DEFLATED) as zip_file:
    for root, dirs, files in os.walk('/home/admin/web/mvk1.ml/public_html'):
        for file in files:
            file_path = os.path.join(root, file)
            zip_file.write(file_path)


print(f"Zip-file created, thats all ")
