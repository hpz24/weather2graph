#!/usr/bin/gnuplot -persist
set terminal png nocrop font small size 800,600
set title "Temperatur"
set style data lines
set datafile separator ","
set xlabel "Date\nTime"
set timefmt '%Y-%m-%d %H:%M:%S'
set yrange [ -15 : 40 ]
#set autoscale y
set xdata time
#set xrange [ "01-01-2015 00:00":"01-01-2015 23:59" ]
set ylabel "Wert"
set format x "%d/%m\n%H:%M"
set grid
set key left
set output 'wert.png'
plot '/tmp/wert.csv' using 1:2 t '', '/tmp/wert.csv' using 1:2 t 'Aussen', '/tmp/wert2.csv' using 1:2 t '', '/tmp/wert2.csv' using 1:2 t 'Innen'
