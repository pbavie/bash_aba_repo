# !/bin/bash
#        _ _
#   __ _| | | __ _ _ __ _ __ ___   ___
#  / _` | | |/ _` | '__| '_ ` _ \ / _ \
# | (_| | | | (_| | |  | | | | | |  __/
#  \__,_|_|_|\__,_|_|  |_| |_| |_|\___|
#
##############################################################################
# Semplice allarme (conto alla rovescia) che si posiziona nella console
# vedi anche "orologio"
#
##############################################################################
#   OVVIAMENTE:
#
#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                     Version 2, December 2004
#
#  Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
#  Everyone is permitted to copy and distribute verbatim or modified
#  copies of this license document, and changing it is allowed as long
#  as the name is changed.
#
#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#   0. You just DO WHAT THE FUCK YOU WANT TO.
##############################################################################
#   OPPURE:
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##############################################################################
#  Script-source by Paolo Baviero  <aba@baviero.it>  https://www.baviero.it

if [ -n "$1" ] && [ -n "$2" ]; then # Devono esserci due paramtri
	NOWTIME=$(date +%s)	# Segno l'ora corrente
	if [ "$2" == "s" ]; then
		echo "Allarme impostato tra $1 Secondi"
		allarm_S=$(expr $NOWTIME + $1)
	elif [ "$2" == "m" ]; then
		echo "Allarme impostato tra $1 Minuti"
		allarm_S=$(($1*60+$NOWTIME))
	elif [[ $2 =~ ^[0-9]{1,2}$ ]]; then	# Passato un orario
		if [ "$2" -le "9" ]; then #Aggiungo lo zero ai minuti
			MIN="0$2"
		else
			MIN=$2
		fi
		export allarm_D="$(date +%F) $1:$MIN:00" # Imposto l'ora ad oggi
		allarm_S=$(date +%s -d "$allarm_D")
		if [ "$allarm_S" -le "$NOWTIME" ]; then # Se gia' passata allora e' per domani
			export allarm_D="$(date --date="tomorrow" +%F) $1:$MIN:00"
			allarm_S=$(date +%s -d "$allarm_D")
			echo "Allarme impostato DOMANI $allarm_D corretto [s/n]"
			read $risp
			if [ "$risp" != "s" ]; then
				echo "Annullato"
				exit
			fi
		else
			echo "Allarme impostato OGGI $allarm_D"
		fi

	else
		echo "Arco temporale errato"
		exit
	fi
	# Se tutto ok avvio il loop in background
	while sleep 1;do
		NOWTIME=$(date +%s)
    if [[ $allarm_S -le $NOWTIME ]]; then
			echo "ALLARME SCADUTO alle $(date +%T)" | wall
			wait
			tput sc
  		tput cup 1 $(($(tput cols)-10))
  		echo "          "
  		tput rc

			kill -9 $(cat /tmp/allarme.pid) &> /dev/null #Rimuovo l'allarme
		fi
		tput sc
    tput cup 1 $(($(tput cols)-10))
    tput setaf 15 ;  tput setab 1
    echo " $(date -d@$(($allarm_S - $NOWTIME)) -u +%T) "
    tput sgr0
    tput rc
  done & &> /dev/null echo $! > /tmp/allarme.pid
else
echo "Inserire un arco temporale o un orario"
echo "ES: 10 s	-> 	10 Secondi"
echo "    10 m	-> 	10 Minuti"
echo "    22 30	->	Alle ore 22:30"
exit
fi
