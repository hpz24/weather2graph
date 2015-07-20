#!/bin/bash
source /tmp/variablen.sh

#Suche und ersetzen vom Datum 
sed -i "s/.*TIME,1,10) .*/SUBSTRING(TIME,1,10) = '$actualdat'/g" $dailyscript

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
sed -i 's/.*FROM.*/FROM '$tabtempin'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempin'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

#Suche und Ersetzen von Tabellename innen und Umstellung Ausgabedatei auf aussen
sed -i 's/.*FROM.*/FROM '$tabtempout'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempout'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabhumin'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumin'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript


#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabhumout'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumout'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

#Suche und ERsetzen von Tabellenname luftdruck und Umstellung Ausgabedatei auf luftdruck
sed -i 's/.*FROM.*/FROM '$tabpress'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exppress'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

# Verschieben der Dateien auf /opt/wetter/visual

mv $tempdir/$actualdat*.csv $datadir


## Plot von Temperatur
sed -i 's/.*title.*/set title "Temperatur vom '$actualdat'"/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in C°"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ -15 : 45 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-temp.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exptempout' using 1:2 t '', '/$datadir/$exptempout' using 1:2 t 'Aussen', '/$datadir/$exptempin' using 1:2 t '', '/$datadir/$exptempin' using 1:2 t 'Innen'|g" $dailyplot

"/usr/bin/gnuplot" /$dailyplot

## Plot von Luftfeuchte
sed -i 's/.*title.*/set title "Luftfeuchte vom '$actualdat'/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in %"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ 0 : 100 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-hum.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exphumout' using 1:2 t '', '/$datadir/$exphumout' using 1:2 t 'Aussen', '/$datadir/$exphumin' using 1:2 t '', '/$datadir/$exphumin' using 1:2 t 'Innen'|g" $dailyplot

"/usr/bin/gnuplot" $dailyplot

## Plot von Luftdruck
sed -i 's/.*title.*/set title "Luftdruck vom '$actualdat'/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in hPa"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ 950 : 1050 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-press.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exppress' using 1:2 t '', '/$datadir/$exppress' using 1:2 t 'Druck'|g" $dailyplot

"/usr/bin/gnuplot" $dailyplot

# Umbennenn der aktuellen Dateien auf statischen namen für Web-Upload
cp -v $graphdir/$actualdat-temp.png $graphdir/temperatur-today.png
cp -v $graphdir/$actualdat-hum.png $graphdir/luftfeuchte-today.png
cp -v $graphdir/$actualdat-press.png $graphdir/luftdruck-today.png

# Umbennenn der Dateien von gestern auf statischen namen für Web-Upload
cp -v $graphdir/$yesterdat-temp.png $graphdir/temperatur-yesterday.png
cp -v $graphdir/$yesterdat-hum.png $graphdir/luftfeuchte-yesterday.png
cp -v $graphdir/$yesterdat-press.png $graphdir/luftdruck-yesterday.png



"/usr/bin/ftp" -n $ftpserver <<End-Of-Session
user $ftpuser $ftppass
binary
cd $ftpdir
lcd $graphdir
put temperatur-yesterday.png
put luftfeuchte-yesterday.png
put luftdruck-yesterday.png
put temperatur-today.png
put luftfeuchte-today.png
put luftdruck-today.png
bye
End-Of-Session
echo Ftp-Upload durchgeführt


