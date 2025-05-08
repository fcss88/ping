#!/bin/bash

# describe variables
APP_DIR="/app/"
BACKUP_DIR="/backup/"

MYSQL_USER="mysql_user"
MYSQL_PASSWORD="mysql_password"

PG_USER="pg_user"
PG_PASSWORD="pg_password"

FTP_SERVER="ftp.example.com"
FTP_USER="ftp_user"
FTP_PASSWORD="ftp_password"
FTP_REMOTE_DIR="/remote_backup/"

# create backup dir
mkdir -p "$BACKUP_DIR"

# backup /app/
tar -czf "$BACKUP_DIR/app_backup_$(date +'%Y%m%d_%H%M%S').tar.gz" "$APP_DIR"

# backup MySQL db
MYSQL_DUMP_FILE="$BACKUP_DIR/mysql_backup_$(date +'%Y%m%d_%H%M%S').sql"
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --all-databases > "$MYSQL_DUMP_FILE"
tar -czf "$MYSQL_DUMP_FILE.tar.gz" --remove-files "$MYSQL_DUMP_FILE"

# backup PostgreSQL db
PG_DUMP_FILE="$BACKUP_DIR/postgresql_backup_$(date +'%Y%m%d_%H%M%S').sql"
pg_dumpall -U "$PG_USER" -w > "$PG_DUMP_FILE"
tar -czf "$PG_DUMP_FILE.tar.gz" --remove-files "$PG_DUMP_FILE"

# upload backup to FTP-server
lftp -u "$FTP_USER","$FTP_PASSWORD" "$FTP_SERVER" <<EOF
cd "$FTP_REMOTE_DIR"
put "$BACKUP_DIR/app_backup_*.tar.gz"
put "$BACKUP_DIR/mysql_backup_*.tar.gz"
put "$BACKUP_DIR/postgresql_backup_*.tar.gz"
bye
EOF

echo "backup completed and uploaded to FTP server."
exit 0