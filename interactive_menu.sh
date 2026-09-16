#!/bin/bash
# Bash script module for a universal interactive menu | AntonioOA1206 & OpenMosto | v2.0
##
# This script will display an interactive menu were you can choose between options with W S keys or with the arrows in the terminal.
# You can import this on your script or program and use the funtion "interactive-menu" followed by a the options you want your menu to have as arguments.
##
# Example: interactive_menu "1. Option" "2. Option" "3. Option" "4. Quit"
## 
# The selected option will define the variable "menu_option" with its position for the programer to then refer to it (for example, option 1 will define the variable with the number 1)
# The last option is build to always be the "Quit" option, and will end the program instantly unless you use the -b (or --break) option. 
##
# Funtions
cursor-fix() { # Function to avoid not showing your cursor when you stop the program with CTRL + C
	tput cnorm
	exit 0
}
##

function print_menu ( # Prints every iteration of the menu with te selected option highlighted
	local color_increment=1
	for i in "${!options[@]}"; do
		option="${options[$i]}"
		((color_increment++))
		if  [ $i = $(($menu_position-1)) ]; then
			fcolores $1 = = = = = = = =
			fcolores ${!color_increment} $option
			fcolores $1 = = = = = = = =
		else
			fcolores ${!color_increment} $option
		fi
	done
)
##
interactive_menu() {
    local i menu_position=1
    local options=()
    local arguments arg key arrow quit_option
	
	##
	declare -a options=()
	for arg in "$@"; do # Build the array of options and search for the break switch
		if [[ "$arg" != "-b" ]] && [[ "$arg" != "--break" ]]; then
			options+=("$arg")
		elif [[ "$arg" == "-b" ]] || [[ "$arg" == "--break" ]]; then
			quit_option="break"
		fi
	done
	##
	while true; do # Menu loop
		tput civis # Hides the terminal cursor
		##
		while true; do # Menu print loop
			# Array that saves the menu arguments, resets every time you move trough the menu. This arguments represent each a color.
			declare -a arguments=(30) # Argument 30 = equals chain (======)
			for ((i=1; i<${#options[@]}; i++)); do
				arguments+=(33) # Argument 33 = Menu option
			done
			arguments+=(31) # Argument 31 = "Quit" option (red)
			arguments[$menu_position]=44 # Argument 44 = Highlighted option
			##
			print_menu "${arguments[@]}"
			trap cursor-fix SIGINT
			read -s -n 1 key # Read the keyboard imput (WS or up and down arrows)
			##
			if [ -z $key ]; then # Enter
				break
			elif [ $key = "w" ]; then # W
				if [ $menu_position -eq 1 ]; then
					menu_position=1
				else
					menu_position=$(($menu_position-1))
				fi
			elif [ $key = "s" ]; then # S
				if [ $menu_position -eq ${#options[@]} ]; then
					menu_position=${#options[@]}
				else
					menu_position=$((menu_position+1))
				fi
			elif [[ $key == $'\x1b' ]]; then # Arrow imput (Escape ANSI secuence)
				read -rsn2 arrow
				case $arrow in
					"[A")
						 # Up arrow
						if [ $menu_position -eq 1 ]; then
							menu_position=1
						else
							menu_position=$(($menu_position-1))
						fi
						;;
					"[B")
						 # Down arrow
						if [ $menu_position -eq ${#options[@]} ]; then
							menu_position=${#options[@]}
						else
							menu_position=$((menu_position+1))
						fi
						;;
				esac
			else
				menu_position=$menu_position
			fi
			clear
		done
		tput cnorm
		if [ $menu_position -eq ${#options[@]} ]; then # Quit option
			if [[ "$quit_option" == "break" ]]; then # This will only end the menu loop
				menu_option=$menu_position
				break
			else
				exit 0 # This will shutdown the script without doing anything else
			fi
        else # Any other option	
            menu_option=$menu_position # This will set the option you chosen. Its value is the position of the option in order.
            break
        fi
		##
	done
}