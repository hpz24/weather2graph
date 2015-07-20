#!/bin/bash
source /opt/wetter/visual/variablen.sh

#Suche und ersetzen vom Datum 
sed -i "s/.*TIME,1,7.*/SUBSTRING(TIME,1,7) = '$actualyearmonth'/g" $monthlyscript

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
sed -i 's/.*FROM.*/FROM '$tabtempin'/g' $monthlyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempin'|g" $monthlyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $monthlyscript
#Suche und Ersetzen von Tabellename innen und Umstellung Ausgabedatei auf aussen

sed -i 's/.*FROM.*/FROM '$tabtempout'/g' $monthlyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempout'|g" $monthlyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $monthlyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck

sed -i 's/.*FROM.*/FROM '$tabhumin'/g' $monthlyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumin'|g" $monthlyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $monthlyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck

sed -i 's/.*FROM.*/FROM '$tabhumout'/g' $monthlyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumout'|g" $monthlyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $monthlyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck

sed -i 's/.*FROM.*/FROM '$tabpress'/g' $monthlyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exppress'|g" $monthlyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $monthlyscript

# Verschieben der Dateien auf /opt/wetter/visual

mv $tempdir/$actualdat*.csv $datadir


## Plot von Temperatur
sed -i 's/.*title.*/set title "Temperatur der letzten 30 Tage"/g' $monthlyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in C°"/g' $monthlyplot
sed -i 's/.*yrange.*/set yrange [ -15 : 45 ]/g' $monthlyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-temp.png'|g" $monthlyplot
sed -i "s|.*using.*|plot '$datadir/$exptempout' using 1:2 t '', '$datadir/$exptempout' using 1:2 t 'Aussen', '$datadir/$exptempin' using 1:2 t '', '$datadir/$exptempin' using 1:2 t 'Innen'|g" $monthlyplot

"/usr/bin/gnuplot" /$monthlyplot

## Plot von Luftfeuchte
sed -i 's/.*title.*/set title "Luftfeuchte der letzten 30 Tage"/g' $monthlyyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in %"/g' $monthlyplot
sed -i 's/.*yrange.*/set yrange [ 0 : 100 ]/g' $monthlyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-hum.png'|g" $monthlyplot
sed -i "s|.*using.*|plot '$datadir/$exphumout' using 1:2 t '', '$datadir/$exphumout' using 1:2 t 'Aussen', '$datadir/$exphumin' using 1:2 t '', '$datadir/$exphumin' using 1:2 t 'Innen'|g" $monthlyplot

"/usr/bin/gnuplot" $monthlyplot

## Plot von Luftdruck
sed -i 's/.*title.*/set title "Luftdruck der letzten 30 Tage"/g' $monthlyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in hPa"/g' $monthlyplot
sed -i 's/.*yrange.*/set yrange [ 950 : 1050 ]/g' $monthlyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-press.png'|g" $monthlyplot
sed -i "s|.*using.*|plot '$datadir/$exppress' using 1:2 t '', '$datadir/$exppress' using 1:2 t 'Druck'|g" $monthlyplot

"/usr/bin/gnuplot" $monthlyplot

# Umbennenn der aktuellen Dateien auf statischen namen für Web-Upload
cp -v $graphdir/$actualdat-temp.png $graphdir/temperatur-month.png
cp -v $graphdir/$actualdat-hum.png $graphdir/luftfeuchte-month.png
cp -v $graphdir/$actualdat-press.png $graphdir/luftdruck-month.png



"/usr/bin/ftp" -n $ftpserver <<End-Of-Session
user $ftpuser $ftppass
binary
cd $ftpdir
lcd $graphdir
put temperatur-month.png
put luftfeuchte-month.png
put luftdruck-month.png
bye
End-Of-Session
echo Ftp-Upload durchgeführt


