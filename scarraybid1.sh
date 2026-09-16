#!/bin/bash

clear

#Llama al fichero del menu interactivo
source ./fauxiliares.sh
source ./interactive_menu.sh
source ./fusus.sh
##
while true;do
	#Se declara el array con las opciones para el menu principal
	interactive_menu "1. Ver_Usuarios" "2. Crear_Usuario" "3. Modificar_Usuario" "4. Borrar_Usuarios" "5. Volcar_y_Salir" "6. Salir" -b

	#Declaramos el array asociativo para el bidimensional
	declare -A usus

	flusus
	
	#Dependiendo de que opcion se haya elegido...
	case $menu_option in
		1)
			#Ver usuarios
			fvusus
		;;
		2)
			#Crear usuarios (en el array)
			fcusus
		;;
		3)
			#Modificar usuarios (en el array)
			fmod
		;;
		4)
			#Marca los usuarios deseados para borrarlos posteriormente
			fdel
		;;
		5)
			#Hace el 2,3 y 4 ahora si en passwd y termina el script
			fvolcar
			break
		;;
		6)
			break
		;;
	esac
	##
done

#Limpia el fichero usuarios.txt pues ya no hacen falta esos usuarios
: > usuarios.txt
##