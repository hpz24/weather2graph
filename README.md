# weather2graph
Dump MySQL Data from my weatherstation into handsome graphs and upload directly to ftp for static web page view (i like html!)

# Overview
weather2graph contains 3 shell-scripts (daily.sh, weekly.sh, monthly.sh) and a global variable file  + 3 sql scripts for dumping data and 3 gnuplot-settings files for plotting

# Prerequisites
needed packeages:
* mysql-client 
* gnuplot

# Install
Clone Directory, check variablen.sh for the right directories and credentials
Make crontab entries and prepare for plotting!


# Usage
* Data will pulled out of a mysql-database into csv files, timed with cron
* Files will be prepared for plotting with gnuplot
* plotting (huh!)
* Upload to FTP-Server

# License
Copyright (C) 2015 Hanspeter Zach

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

