$i = 1 
while ($i -lt 1000 ) {
	.\main.exe $i
	gnuplot plot.plt
	$i = $i+1
}
