#!/bin/sh

ip_target=$(cat ~/.config/polybar/cuts/scripts/target | awk '{print $1}')
name_target=$(cat ~/.config/polybar/cuts/scripts/target | awk '{print $2}')

	if [ $ip_target ] && [ $name_target ]; then
#		echo "%{F#30587A}%{F#30587A} $ip_target - $name_target "
		echo "%{A1:echo $ip_target | xclip -selection clipboard:}%{F#30587A}%{F#30587A} $ip_target - $name_target %{A}"
	elif [ $(cat ~/.config/polybar/cuts/scripts/target | wc -w) -eq 1 ]; then
#		echo "%{F#30587A}%{F#30587A} $ip_target "
		echo "%{A1:echo $ip_target | xclip -selection clipboard:}%{F#30587A}%{F#30587A} $ip_target %{A}"
	else
		echo "%{F#30587A}%{u-}%{F#30587A} No target "
	fi
