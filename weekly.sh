#!/bin/bash
source /tmp/variablen.sh

#Suche und ersetzen vom Datum 
sed -i "s/.*YEAR.*/YEAR(TIME) = '$actualyear' AND/g" $weeklyscript
sed -i "s/.*WEEK(TIME.*/WEEK(TIME,5) = WEEK('$actualweek',5)/g" $weeklyscript

#Aufraeumen von vorhandenen Dateien
if test -e "$exptempin";then
rm $exptempin
fi
if test -e "$exptempout";then
rm $exptempout
fi
if test -e "$exphumin";then
rm $exphumin
fi
if test -e "$exphumout";then
rm $exphumout
fi
if test -e "$exppress";then
rm $exppress
fi


#Suche und ersetzen von Tabellename 1temp30 und Ausgabedatei auf 1temp30.csv
sed -i 's/.*FROM.*/FROM '$tabtempin'/g' $weeklyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempin'|g" $weeklyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $weeklyscript

#Suche und Ersetzen von Tabellename innen und Umstellung Ausgabedatei auf aussen
sed -i 's/.*FROM.*/FROM '$tabtempout'/g' $weeklyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempout'|g" $weeklyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $weeklyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabhumin'/g' $weeklyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumin'|g" $weeklyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $weeklyscript


#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabhumout'/g' $weeklyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumout'|g" $weeklyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $weeklyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabpress'/g' $weeklyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exppress'|g" $weeklyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $weeklyscript

# Verschieben der Dateien auf /opt/wetter/visual

mv $tempdir/$actualdat*.csv $datadir


## Plot von Temperatur
sed -i 's/.*title.*/set title "Temperatur der letzten 5 Tage"/g' $weeklyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in C°"/g' $weeklyplot
sed -i 's/.*yrange.*/set yrange [ -15 : 45 ]/g' $weeklyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-temp.png'|g" $weeklyplot
sed -i "s|.*using.*|plot '$datadir/$exptempout' using 1:2 t '', '$datadir/$exptempout' using 1:2 t 'Aussen', '$datadir/$exptempin' using 1:2 t '', '$datadir/$exptempin' using 1:2 t 'Innen'|g" $weeklyplot

"/usr/bin/gnuplot" /$weeklyplot

## Plot von Luftfeuchte
sed -i 's/.*title.*/set title "Luftfeuchte der letzten 5 Tage"/g' $weeklyyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in %"/g' $weeklyplot
sed -i 's/.*yrange.*/set yrange [ 0 : 100 ]/g' $weeklyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-hum.png'|g" $weeklyplot
sed -i "s|.*using.*|plot '$datadir/$exphumout' using 1:2 t '', '$datadir/$exphumout' using 1:2 t 'Aussen', '$datadir/$exphumin' using 1:2 t '', '$datadir/$exphumin' using 1:2 t 'Innen'|g" $weeklyplot

"/usr/bin/gnuplot" $weeklyplot

## Plot von Luftdruck
sed -i 's/.*title.*/set title "Luftdruck der letzten 5 Tage"/g' $weeklyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in hPa"/g' $weeklyplot
sed -i 's/.*yrange.*/set yrange [ 950 : 1050 ]/g' $weeklyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-press.png'|g" $weeklyplot
sed -i "s|.*using.*|plot '$datadir/$exppress' using 1:2 t '', '$datadir/$exppress' using 1:2 t 'Druck'|g" $weeklyplot

"/usr/bin/gnuplot" $weeklyplot

# Umbennenn der aktuellen Dateien auf statischen namen für Web-Upload
cp -v $graphdir/$actualdat-temp.png $graphdir/temperatur-week.png
cp -v $graphdir/$actualdat-hum.png $graphdir/luftfeuchte-week.png
cp -v $graphdir/$actualdat-press.png $graphdir/luftdruck-week.png



"/usr/bin/ftp" -n $ftpserver <<End-Of-Session
user $ftpuser $ftppass
binary
cd $ftpdir
lcd $graphdir
put temperatur-week.png
put luftfeuchte-week.png
put luftdruck-week.png
bye
End-Of-Session
echo Ftp-Upload durchgeführt


