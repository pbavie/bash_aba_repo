# !/bin/bash
#   ___  _ __ ___ | | ___   __ _(_) ___
#  / _ \| '__/ _ \| |/ _ \ / _` | |/ _ \
# | (_) | | | (_) | | (_) | (_| | | (_) |
#  \___/|_|  \___/|_|\___/ \__, |_|\___/
#                          |___/
##############################################################################
# Semplice orologio che si posiziona nella console
# vedi anche "allarme"
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

if [ "$1" != "off" ]; then
  echo "Posiziono orologio in alto a DX"
  echo "per rimuoverlo: orologio off"
  while sleep 1;do
    tput sc
    tput cup 0 $(($(tput cols)-10))
    tput setaf 15 ;  tput setab 6
    printf " `date +%T` "
    tput sgr0
    tput rc
  done & &> /dev/null echo $! > /tmp/orologio.pid
else
  kill -9 $(cat /tmp/orologio.pid) &> /dev/null
  wait
  echo "Orologio rimosso."
  tput sc
  tput cup 0 $(($(tput cols)-10))
  echo "          "
  tput rc
  rm /tmp/orologio.pid &> /dev/null
fi
