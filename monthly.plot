#!/usr/bin/gnuplot -persist
set terminal png nocrop font small size 800,600
set title "Luftdruck der letzten 30 Tage"
set style data lines
set datafile separator ","
set xlabel "Time"
set timefmt '%Y-%m-%d %H:%M:%S'
set yrange [ 950 : 1050 ]
#set autoscale y
set xdata time
#set xrange [ "01-01-2015 00:00":"01-01-2015 23:59" ]
set ylabel "Wert in hPa"
set format x "%d-%m"
set grid
set key left bottom
set output '/opt/wetter/visual/graph/2015-07-17-press.png'
plot '/opt/wetter/visual/data/2015-07-17-press.csv' using 1:2 t '', '/opt/wetter/visual/data/2015-07-17-press.csv' using 1:2 t 'Druck'
