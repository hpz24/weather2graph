#!/bin/bash
## Import global file variablen.sh
source /tmp/variablen.sh

## Search and Replace with the actual date 
sed -i "s/.*TIME,1,10) .*/SUBSTRING(TIME,1,10) = '$actualdat'/g" $dailyscript

## Cleanup the Directory
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

## Search und Replace Tablename 'tabtempin' und exportfile for Temperature Inside, then export
sed -i 's/.*FROM.*/FROM '$tabtempin'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempin'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

## Search und Replace Tablename 'tabtempout' und exportfile for Temperature Outside, then export
sed -i 's/.*FROM.*/FROM '$tabtempout'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exptempout'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

## Search und Replace Tablename 'tabhumin' und exportfile for Huminity Inside, then export
sed -i 's/.*FROM.*/FROM '$tabhumin'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumin'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript


## Search und Replace Tablename 'tabhumout' und exportfile for Huminity Outside, then export
sed -i 's/.*FROM.*/FROM '$tabhumout'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exphumout'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

## Search und Replace Tablename 'tabpress' und exportfile for Presure, then export
sed -i 's/.*FROM.*/FROM '$tabpress'/g' $dailyscript
sed -i "s|.*OUTFIL.*|INTO OUTFILE '$tempdir/$exppress'|g" $dailyscript

"/usr/bin/mysql" -u $dbuser -p$dbpassword -D$dbused < $dailyscript

## Move Files to $datadir (/opt/wetter/visual)

mv $tempdir/$actualdat*.csv $datadir


## Modify plot-script for plotting Temperature
sed -i 's/.*title.*/set title "Temperatur vom '$actualdat'"/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in C°"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ -15 : 45 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-temp.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exptempout' using 1:2 t '', '/$datadir/$exptempout' using 1:2 t 'Aussen', '/$datadir/$exptempin' using 1:2 t '', '/$datadir/$exptempin' using 1:2 t 'Innen'|g" $dailyplot

"/usr/bin/gnuplot" /$dailyplot

## Modify plot-script for plotting Huminity
sed -i 's/.*title.*/set title "Luftfeuchte vom '$actualdat'/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in %"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ 0 : 100 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-hum.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exphumout' using 1:2 t '', '/$datadir/$exphumout' using 1:2 t 'Aussen', '/$datadir/$exphumin' using 1:2 t '', '/$datadir/$exphumin' using 1:2 t 'Innen'|g" $dailyplot

"/usr/bin/gnuplot" $dailyplot

## Modify plot-script for plotting Pressure
sed -i 's/.*title.*/set title "Luftdruck vom '$actualdat'/g' $dailyplot
sed -i 's/.*ylabel.*/set ylabel "Wert in hPa"/g' $dailyplot
sed -i 's/.*yrange.*/set yrange [ 950 : 1050 ]/g' $dailyplot
sed -i "s|.*output.*|set output '$graphdir/$actualdat-press.png'|g" $dailyplot
sed -i "s|.*using.*|plot '$datadir/$exppress' using 1:2 t '', '/$datadir/$exppress' using 1:2 t 'Druck'|g" $dailyplot

"/usr/bin/gnuplot" $dailyplot

## Rename file with actual data to static names for web view
cp -v $graphdir/$actualdat-temp.png $graphdir/temperatur-today.png
cp -v $graphdir/$actualdat-hum.png $graphdir/luftfeuchte-today.png
cp -v $graphdir/$actualdat-press.png $graphdir/luftdruck-today.png

## Rename file with last days data to static name for web view
cp -v $graphdir/$yesterdat-temp.png $graphdir/temperatur-yesterday.png
cp -v $graphdir/$yesterdat-hum.png $graphdir/luftfeuchte-yesterday.png
cp -v $graphdir/$yesterdat-press.png $graphdir/luftdruck-yesterday.png


## Web Upload with Script, local directory is $graphdir, remote directory is $ftpdir, data will load directly up
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


