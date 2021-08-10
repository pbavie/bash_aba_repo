#/bin/bash
#semplice script che effettua in automatico delle operazioni di manutenzione del sistema.
#created by eddiewrc <eddiewrc@alice.it> 26/05/2009 

printf "\nCLEANER: Processing apt-get clean...\n\n"
apt-get clean
printf "\nCLEANER: clean done.\n"
printf "\nCLEANER: Processing apt-get autoclean...\n\n"
apt-get autoclean
printf "\nCLEANER: autoclean done.\n"
printf "\nCLEANER: Processing apt-get autoremove...\n\n"
apt-get autoremove
printf "\nCLEANER: autoremove done.\n"

lista="./eliminabili.txt"

printf "\nCLEANER: Generating the list of removed application's comfiguration files..."
( dpkg -l | grep -E "^rc" | cut -f3 -d' ' ) > $lista
printf " done. (List saved in %s)" $lista

printf "\nCLEANER: Start cleaning..."
for file in $(cat $lista)
do
	dpkg --purge $file
done

printf "\nCLEANER: done.\n"
exit 0
