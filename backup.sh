#!/bin/bash
# settings

###
# 1.edit settings
# 2.config crontab
#	crontab -e 
#	00 04 * * 1 /root/backup.sh

date=`date --iso-8601=date`
second=`date --iso-8601=second`
src_dir="/var/www"
dst_dir="/root/backup"
tmp_dir=$dst_dir"/"$date
logfile=$dst_dir"/backup.log"

mysqldbhost="127.0.0.1"
mysqldbport="3306"
mysqldbuser="mysql_backup_username"
mysqldbpass="mysql_backup_password"
mysqldb="database_name"

mkdir -p $dst_dir $tmp_dir

# backup start
echo "Backup start: "$second >> $logfile

# database backup
echo "Dumping MySQL database..." >> $logfile
cd $tmp_dir
mysqldump --host=$mysqldbhost --port=$mysqldbport --user=$mysqldbuser --password=$mysqldbpass --databases $mysqldb > mysqldump.$mysqldbhost.$mysqldbport.$mysqldb.$date.sql

# copy wordpress files
echo "Copying source dir files..." >> $logfile
cp -r $src_dir files

# Compress backup files
echo "Compressing backup files..." >> $logfile
cd $dst_dir
tar zcf backup.$mysqldbhost.$mysqldbport.$mysqldb.$date.tar.gz $date >> $logfile

# Cleanup
echo "Cleaning up..." >> $logfile
rm -rf $tmp_dir >> $logfile
echo >> $logfile
