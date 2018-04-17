
	set term pdf
	set output "wykres2.pdf"

	plot "dane1" using 1:2 w l , "dane1" using 1:4 w l 

	set output "Energia.pdf"
	plot "dane1" using 1:5 w l 
