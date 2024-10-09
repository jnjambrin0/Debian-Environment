#!/bin/bash

# Author: Enríquez González https://github.com/AlvinPix
# instagram: @alvinpx_271
# facebook: @alvin.gonzalez.13139

# COLORS THE SCRIPT
Black='\033[1;30m'
Red='\033[1;31m'
Green='\033[1;32m'
Yellow='\033[1;33m'
Blue='\033[1;34m'
Purple='\033[1;35m'
Cyan='\033[1;36m'
White='\033[1;37m'
NC='\033[0m'
blue='\033[0;34m'
white='\033[0;37m'
lred='\033[0;31m'

# VARIABLES DATABASE
USERNAME=$(whoami)
THEMEDIR="/home/${USERNAME}/.themes"
POLYDIR="/home/${USERNAME}/.config/polybar/cuts"
CONDIR="/home/${USERNAME}"

# TRAPS CTRL-C
trap ctrl_c INT

# EXIT THE SCRIPT CTRL-C
function ctrl_c () {
echo ""
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Exiting the theming script"
exit 0
}

# BANNER THE SCRIPT
banner () {
echo -e "${White} ╔────────────────────────────────────────────────────────────────────╗     		  		  "
echo -e "${White} |${Blue} ████████╗██╗  ██╗███████╗ █████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗ ${White} |    		  "
echo -e "${White} |${Blue} ╚══██╔══╝██║  ██║██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔════╝ ${White} |     		  "
echo -e "${White} |${Blue}    ██║   ███████║█████╗  ███████║██╔████╔██║██║██╔██╗ ██║██║  ███╗${White} |    		  "
echo -e "${White} |${Blue}    ██║   ██╔══██║██╔══╝  ██╔══██║██║╚██╔╝██║██║██║╚██╗██║██║   ██║${White} |    	          "
echo -e "${White} |${Blue}    ██║   ██║  ██║███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝${White} |    	          "
echo -e "${White} |${Blue}    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ${White} |    	          "
echo -e "${White} ┖────────────────────────────────────────────────────────────────────┙    		 	          "
echo -e "${Blue} ${White}[${Cyan}i${White}] Welcome ${Red}${USERNAME}${White} to theme launcher and mode! 		  "
echo -e "${Blue} ${White}[${Cyan}i${White}] If you want to exit the script use ${Red}[CTRL+C]                             "
echo -e "${Blue} ${White}[${Cyan}i${White}] What type of theme do you want to apply? 			  		  "
}

# THEAMING MODE SELECTOR
mode () {
clear
echo ""
banner
echo ""
echo -e "${Blue} [${Cyan}1${Blue}] Normal mode"
echo ""
echo -e "${White}  In this mode you can apply themes in normal mode."
echo -e "${White}  ideal for use while studying or working."
echo ""
echo -e "${Blue} [${Cyan}2${Blue}] Penetration mode"
echo ""
echo -e "${White}  In this mode you can apply themes"
echo -e "${White}  To have fun ;)"
echo ""
echo -ne "${Blue} ▶ ${Red}"
read mode
case $mode in

1)
Normalthemes ;;

2)
Funthemes ;;

*)
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Invalid option, use numbers"
sleep 2
mode
esac
}

Normalthemes () {
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Loading themes normal mode..."
echo ""
echo -e "${Blue} [${Cyan}1${Blue}] Default"
echo -e "${Blue} [${Cyan}2${Blue}] Secundary"
echo ""
echo -ne "${Blue} ▶ ${Red}"
read nmtheme
case $nmtheme in

1)
echo ""
echo -e " ${White}[${Cyan}i${White}] Loading theme ${Red}[Default]${NC}"
cd ${THEMEDIR}/Default/kitty
cp color.ini ${CONDIR}/.config/kitty
cd ${THEMEDIR}/Default
cp bspwmrc ${CONDIR}/.config/bspwm
cd ${THEMEDIR}/Default/polybar
cp user_modules.ini colors.ini config.ini ${CONDIR}/.config/polybar/cuts
cp colors.rasi ${CONDIR}/.config/polybar/cuts/scripts/rofi
echo ""
betterlockscreen -u ${THEMEDIR}/Default/wallpapers/default.jpg
echo ""
bspc wm -r
#polybar-msg cmd restart
echo -e " ${White}[${Cyan}i${White}] ${Red}[Default]${White} theme applied correctly"
sleep 2
exit 0 ;;

2)
echo ""
echo -e " ${White}[${Cyan}i${White}] Loading theme ${Red}[Secundary]${NC}"
cd ${THEMEDIR}/Secundary/kitty
cp color.ini ${CONDIR}/.config/kitty
cd ${THEMEDIR}/Secundary
cp bspwmrc ${CONDIR}/.config/bspwm
cd ${THEMEDIR}/Secundary/polybar
cp user_modules.ini colors.ini config.ini ${CONDIR}/.config/polybar/cuts
cp colors.rasi ${CONDIR}/.config/polybar/cuts/scripts/rofi
echo ""
betterlockscreen -u ${THEMEDIR}/Secundary/wallpapers/secundary.jpg
echo ""
bspc wm -r
echo -e " ${White}[${Cyan}i${White}] ${Red}[Secundary]${White} theme applied correctly"
sleep 2
exit 0 ;;

*)
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Invalid option, use numbers"
sleep 2
mode
esac
}

Funthemes () {
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Loading themes fun mode..."
echo ""
echo -e "${Blue} [${Cyan}1${Blue}] Default"
echo -e "${Blue} [${Cyan}2${Blue}] Secundary"
echo ""
echo -ne "${Blue} ▶ ${Red}"
read funthemes
case $funthemes in

1)
echo ""
echo -e " ${White}[${Cyan}i${White}] Loading theme penetration mode ${Red}[Default]${NC}"
cd ${THEMEDIR}/Default/kitty
cp color.ini ${CONDIR}/.config/kitty
cd ${THEMEDIR}/Default
cp bspwmrc ${CONDIR}/.config/bspwm
cd ${THEMEDIR}/Default/polybar
cp user_modules.ini colors.ini ${CONDIR}/.config/polybar/cuts
cp colors.rasi ${CONDIR}/.config/polybar/cuts/scripts/rofi
cd ${THEMEDIR}/Default/bar_pentest
cp config.ini ${CONDIR}/.config/polybar/cuts
cd ${THEMEDIR}/Default/scripts
cp ethernet_status.sh machine_target.sh vpn_status.sh ${CONDIR}/.config/polybar/cuts/scripts
echo ""
betterlockscreen -u ${THEMEDIR}/Default/wallpapers/default.jpg
echo ""
bspc wm -r
#polybar-msg cmd restart
echo -e " ${White}[${Cyan}i${White}] ${Red}[Default]${White} theme applied correctly"
sleep 2
exit 0 ;;

2)
echo ""
echo -e " ${White}[${Cyan}i${White}] Loading theme penetration mode ${Red}[Secundary]${NC}"
cd ${THEMEDIR}/Secundary/kitty
cp color.ini ${CONDIR}/.config/kitty
cd ${THEMEDIR}/Secundary
cp bspwmrc ${CONDIR}/.config/bspwm
cd ${THEMEDIR}/Secundary/polybar
cp user_modules.ini colors.ini ${CONDIR}/.config/polybar/cuts
cp colors.rasi ${CONDIR}/.config/polybar/cuts/scripts/rofi
cd ${THEMEDIR}/Secundary/bar_pentest
cp config.ini ${CONDIR}/.config/polybar/cuts
cd ${THEMEDIR}/Secundary/scripts
cp ethernet_status.sh machine_target.sh vpn_status.sh ${CONDIR}/.config/polybar/cuts/scripts
echo ""
betterlockscreen -u ${THEMEDIR}/Secundary/wallpapers/secundary.jpg
echo ""
bspc wm -r
#polybar-msg cmd restart
echo -e " ${White}[${Cyan}i${White}] ${Red}[Secundary]${White} theme applied correctly"
sleep 2
exit 0 ;;

*)
echo ""
echo -e "${Blue} ${White}[${Cyan}i${White}] Invalid option, use numbers"
sleep 2
mode
esac
}

# CALL MENUS THE SCRIPT THEMES AND RESET
reset
mode
