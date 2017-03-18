WORK_DIR=`pwd`
whtlocation="$(pwd)/whitelist.txt"
blklocation="$(pwd)/blacklist.txt"

iswhitelist=0
isblacklist=0
notifications=0
localinterface="en0"

connections=0
highestip="None"

# Whitelist format "host"
# Blacklist format "host"
# Capture format "Host|To|port" Arrary
# Explicit data format "Host|out|in|connections" Array
# echo ${array[0]}

# BlockList format "host|BlockPort"

white="\033[1;37m"
grey="\033[0;37m"
purple="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
Purple="\033[0;35m"
Cyan="\033[0;36m"
Cafe="\033[0;33m"
Fiuscha="\033[0;35m"
blue="\033[1;34m"
transparent="\e[0m"


function banner {


 printf "${red}"
 sleep 0.05 && echo -e "   █████╗ ███╗   ██╗████████╗██╗    ████████╗██████╗  █████╗  ██████╗███████╗██████╗  "
 sleep 0.05 && echo -e "  ██╔══██╗████╗  ██║╚══██╔══╝██║    ╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗ "
 sleep 0.05 && echo -e "  ███████║██╔██╗ ██║   ██║   ██║       ██║   ██████╔╝███████║██║     █████╗  ██████╔╝ "
 sleep 0.05 && echo -e "  ██╔══██║██║╚██╗██║   ██║   ██║       ██║   ██╔══██╗██╔══██║██║     ██╔══╝  ██╔══██╗ "
 sleep 0.05 && echo -e "  ██║  ██║██║ ╚████║   ██║   ██║       ██║   ██║  ██║██║  ██║╚██████╗███████╗██║  ██║ "
 sleep 0.05 && echo -e "  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝ "
 printf "${transparent}"
 echo ""

}
function init {
 if [ ! -d "tmp" ]; then
  mkdir tmp
 fi
 if [[ ! "$unamestr" == 'Linux' ]]; then
  echo "your opperating system may not be supported at this time"
  #exit
 fi

 if [ -e "$whtlocation" ]
 then
  iswhitelist=1
 else
  iswhitelist=0
 fi

 if [ -e "$blklocation" ]
 then
  isblacklist=1
 else
  isblacklist=0
 fi


 if [ "$iswhitelist" -eq "1" ]; then
  echo "Found Whitelist.txt! loading to memory"
 else
  echo "No Whitelist.txt found creating a new one"
  echo "127.0.0.1" >> whitelist.txt
  echo $local >> whitelist.txt
 fi

 if [ "$isblacklist" -eq "1" ]; then
  echo "Found blacklist.txt! loading to memory"
 else
  echo "No blacklist.txt found creating a new one"
  echo "" > blacklist.txt
 fi

 if [ $whtlocation ] && [ $blklocation ]; then
  load_data

 fi
 blacklist_drop
}
function blacklist_drop {

 if [[  $(command -v iptables) == '/sbin/iptables' ]]; then
  blines1=${#blacklist[@]}
  for (( i = 0 ; i <= $blines1 ; i++))
  do
   iptables -A INPUT -s ${blacklist[i]} -j DROP
  done
  fi



}
function get_local_ip {
 local=$(ifconfig $localinterface | grep "inet" | cut -c 7-15 | tr " " "|")
 if [[ ! "$inamestr" == 'Linux' ]]; then
  localipv6=$(ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80 | tr " " "|")
 fi

}
function load_data {
 wlines=$(cat $whtlocation | wc -l | cut -c 8-11)
 blines=$(cat $blklocation | wc -l | cut -c 8-11)

 for (( i = 0 ; i <= wlines ; i++))
 do
  whitelist[i]=$(sed -n "$i"p $whtlocation)
 done
#echo ${whitelist[*]}
 for (( v = 0 ; v <= blines ; v++))
 do
  blacklist[v]=$(sed -n "$v"p $blklocation)
 done

##### Separate blacklist #####
 for (( k = 0; k <= 25; k++))
 do
                                                            #awk -F '[ \t]+|/' '{print $1}
  watchlist[k]=$(echo $blacklist[k]}| grep watch )

  blacklist_drop[k]=$(echo ${blacklist[k]} | grep drop | awk -F '[ \t]+|/' '{print $1}' )
 done
 echo "DROP: ${blacklist_drop[*]}"
 echo "Watch: ${watchlist[*]}"
 echo "Full Blacklist: ${blacklist[*]}"
}
function listen {
#echo ${whitelist[*]}
 python listener.py -a "${whitelist[*]}" -b "${watchlist[*]}" -n $notifications


#echo "taking capture"
#netstat -an | grep -e tcp -e udp | cut -c 22-70 >> tmp/capturetmp.txt

#echo "capture taken now proccessing"
#proccess_capture
#printf "$blue>proccessing complete $transparent\n"


}
function proccess_capture { #Deprecated
 lh=$(cat tmp/capturetmp.txt | wc -l | cut -c 6-11)

 for (( i = 0 ; i <= lh ; i++))
 do
  capturefullbuf1[i]=$(sed -n "$i"p tmp/capturetmp.txt | awk -F '[ \t]+|/' '{print $1}')
 done
 for (( i = 0 ; i <= lh ; i++))
 do
  capturefullbuf2[i]=$(sed -n "$i"p tmp/capturetmp.txt | awk -F '[ \t]+|/' '{print $2}')
 done

#cat tmp/capturetmp.txt | awk -F '[ \t]+|/' '{print $1}'

 rm tmp/capturetmp.txt
}
function status {
#banner
#printf "$red Next Capture in 5 seconds $transparent\n"
sleep 5

}
function menu {
 echo ""
 banner
 printf "${blue}"
 printf "      [1] Start Anti Tracer\n"
 printf "      [2] Manage Whitelist/Blacklist ips\n"
 printf "      [3] exit\n"
 printf "${transparent}"
 printf "Enter one of the above and press [Enter]"
 read Menunumb
 if [ "$Menunumb" -eq "1" ]; then
   listen
 fi
 if [ "$Menunumb" -eq "2" ]; then
    echo "this Feature is not enabled yet"

    exit;
 fi
 if [ "$Menunumb" -eq "3" ]; then
    exit;
 fi
}
############################## START OF MAIN ##############################
#banner
init
menu
while :
do
 listen
 status

done


############################## END OF MAIN #############################
