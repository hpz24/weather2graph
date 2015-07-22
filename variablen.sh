#!/bin/bash
# Basic Paths
progdir='/opt/wetter/visual'
datadir=''$progdir/data''
graphdir=''$progdir/graph''
tempdir='/tmp'

# Scripts for SQL-Dumps
dailyscript=''$progdir/dailyscript.sql''
weeklyscript=''$progdir/weeklyscript.sql''
monthlyscript=''$progdir/monthlyscript.sql''
yearlyscript=''$progdir/yearlyscript.sql''

# Gnuplot Paths
dailyplot=''$progdir/daily.plot''
weeklyplot=''$progdir/weekly.plot''
monthlyplot=''$progdir/monthly.plot''
yearlyplot=''$progdir/yearly.plot''

# Ftp Settings for upload graphs
ftpserver=ftp.server.com
ftpdir=graph
ftpuser=myuser
ftppass=mypassword

# Define tables, which helds the weatherdata
tabtempin='`1temp30`'
tabtempout='`2temp1`'
tabhumin='`1hum30`'
tabhumout='`2hum1`'
tabpress='`1press30`'

# Define date settings
actualdat=$(date +%Y-%m-%d)
yesterdat=$(date -d "yesterday" '+%Y-%m-%d')
actualyear=$(date +%Y)
actualweek=$(date +"%Y-%m-%d %T")
actualyearmonth=$(date +"%Y-%m")

#echo $actualmonth
#echo $actualyearmonth

# Define export filenames for sql-data
exptempin="$actualdat-temp-in.csv"
exptempout="$actualdat-temp-out.csv"

exphumin="$actualdat-hum-in.csv"
exphumout="$actualdat-hum-out.csv"

exppress="$actualdat-press.csv"

# Credentials for MySQL-Login
dbserver=127.0.0.1
dbuser=wetter
dbpassword=wetter#2013
dbused=wetterstation

