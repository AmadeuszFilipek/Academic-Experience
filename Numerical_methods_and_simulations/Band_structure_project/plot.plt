set term png size 600,400
set output "wykres.png"

set xlabel "x [ nm ]"
set ylabel " fi " 


set style line 1 lc rgb "blue" lt 1 lw 2 pt 7 ps 1.0
#set xtics axis nomirror

set ytics axis nomirror


set xrange [0:1.14] 
#set yrange [0:]
#unset border
#unset xtics
#unset ytics

plot "norma.txt" using 2:1 notitle ls 1 w l