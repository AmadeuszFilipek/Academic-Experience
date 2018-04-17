#!/bin/bash

case $1	in

krakow)
skr.sh EPKK krakow ;;

pyrzowice)
skr.sh EPKT pyrzowice ;;

lublin)
skr.sh EPLU lublin ;;

jasionka)
skr.sh EPRZ jasionka ;;

okecie)
skr.sh EPWA okecie ;;

modlin)
skr.sh EPMO modlin ;;

lawica)
srk.sh EPPO lawica ;;

-a)
skr.sh EPKK krakow ;
skr.sh EPKT pyrzowice ;
skr.sh EPLU lublin ;
skr.sh EPRZ jasionka ;
skr.sh EPWA okecie ;
skr.sh EPMO modlin ;
skr.sh EPPO lawica ;;


-help|--help|help) printf '\n	lotnisko.sh city	to generate last year fog plot for given airport.\n				Options are : krakow, pyrzowice, lublin, jasionka, okecie,\n 				modlin, lawica. \n\n	-a 			to generate plots for all airports avaible. \n\n' ;;


*) echo "-help for info" ;;

esac


