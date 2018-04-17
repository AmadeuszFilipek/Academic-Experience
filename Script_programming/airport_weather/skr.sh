#!/bin/bash

YEAR=`date --rfc-3339 date | cut -d "-" -f 1`
((Y=$YEAR-1))
###################################################################################################
#sciaganie pliku z danymi

wget -O data "http://www.wunderground.com/history/airport/$1/$Y/1/1/CustomHistory.html?dayend=1&monthend=1&yearend=$YEAR&req_city=NA&req_state=NA&req_statename=NA&MR=1&theprefset=SHOWMETAR&theprefvalue=1&format=1" 

###################################################################################################
#wycinanie niepotrzebnych informacji z pliku

cat data | sed -e 's/<br \/>//' | cut -d "," -f 1,22 | tr -d " " | tr "," " " | sed -e 's/Rain//' | sed -e "s/Hail//" | tail -n +3 > tablica

##################################################################################################
#zliczanie mgieł,burz i gęstych opadów śniegu w miesiacach do nowego pliku

FOG=0
SNOW=0
STORM=0

for i in `seq 12`; do

FOG=`grep "$Y-$i-" tablica | grep "Fog" | cat -n | tail -n 1 | tr -d " " | cut -f 1`
SNOW=`grep "$Y-$i-" tablica | grep "Snow" | cat -n | tail -n 1 | tr -d " " | cut -f 1`
STORM=`grep "$Y-$i-" tablica | grep "Thunderstorm" | cat -n | tail -n 1 | tr -d " " | cut -f 1` 

if [ -z "$FOG" ] ; then
FOG=0
fi
if [ -z "$SNOW" ] ; then
SNOW=0
fi
if [ -z "$STORM" ] ; then
STORM=0
fi

echo "$Y-$i $FOG $SNOW $STORM" >> out

done

#########################################################################################
#rysowanie wykresu w gnuplocie

gnuplot << EOF
	set terminal png size 960,720
	set output "$2.png"
	set xdata time
	set timefmt "%Y-%m"
	set format x "%Y-%m"
	set xrange ["$Y-1":"$YEAR-1"]
	set yrange [0: ]
	set grid
	set xtics rotate by 70
	set xtics out offset 0,-3.0
	set ylabel "Wystąpienia"
	set xlabel " "
	set style line 1 lc rgb "gray" lt 1 lw 2 pt 7 ps 1.5
	set style line 2 lc rgb "red" lt 1 lw 2 pt 7 ps 1.5
	set style line 3 lc rgb "blue" lt 1 lw 2 pt 7 ps 1.5
	plot "out" using 1:2 ls 1 with linespoints title 'Mgły', \
"out" using 1:3 ls 2 with linespoints title "Gęste opady sniegu", \
"out" using 1:4 ls 3 with linespoints title "Burze"
		
EOF

########################################################################################
# czyszcenie plików tymczasowych

rm out
rm data
rm tablica

	

















