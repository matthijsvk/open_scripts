#!/bin/bash
# this shell script keeps backups of the last 3 periods (vb days if you let it run in cron every day).
# how to run in chron: execute 'crontab -e'
mv backup.3 backup.tmp
mv backup.2 backup.3
mv backup.1 backup.2
mv backup.0 backup.1
mv backup.tmp backup.0
cp -al backup.1/. backup.0
rsync -a --delete source_directory/ backup.0/
