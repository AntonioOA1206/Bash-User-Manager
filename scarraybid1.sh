#!/bin/bash

clear

#Llama a los dos ficheros que contienen todas las funciones que se necesitan
source ./fusus.sh
source ./funciones.sh
##

#Se declara el array con las opciones para el menu principal
declare -a opcs=("Ver_Usuarios" "Crear_Usuario" "Modificar_Usuario" "Borrar_Usuarios" "Volcar_y_Salir")

#Funcion que muestra el menu principal
function fmenu (
	pos=0
	for e in ${opcs[@]};do
		if [ $pos -eq 0 ];then
			if [ $sit -eq 1 ];then
				fcolores $6 = = = = = = = =
				fcolores $1 $e
				fcolores $6 = = = = = = = =
			else
				fcolores $1 $e
			fi
		elif [ $pos -eq 1 ];then
			if [ $sit -eq 2 ];then
				fcolores $6 = = = = = = = =
				fcolores $2 $e
				fcolores $6 = = = = = = = =
			else
				fcolores $2 $e
			fi
		elif [ $pos -eq 2 ];then
			if [ $sit -eq 3 ];then
				fcolores $6 = = = = = = = =
				fcolores $3 $e
				fcolores $6 = = = = = = = =
			else
				fcolores $3 $e
			fi
		elif [ $pos -eq 3 ];then
			if [ $sit -eq 4 ];then
				fcolores $6 = = = = = = = =
				fcolores $4 $e
				fcolores $6 = = = = = = = =
			else
				fcolores $4 $e
			fi
		else
			if [ $sit -eq 5 ];then
				fcolores $6 = = = = = = = =
				fcolores $5 $e
				fcolores $6 = = = = = = = =
			else
				fcolores $5 $e
			fi
		fi
		pos=$(($pos+1))
	done
)
##

sit=1

#Declaramos el array asociativo para el bidimensional
declare -A usus

#Lee los usuarios del fichero usuarios.txt
flusus

#Controlar/Moverte por el menu principal
while true;do
	#Oculta el cursor en la terminal
	tput civis
	##

	#Moverse por el menu
	while true;do
		case $sit in
			1)
			fmenu 44 33 33 33 31 30
			;;
			2)
			fmenu 33 44 33 33 31 30
			;;
			3)
			fmenu 33 33 44 33 31 30
			;;
			4)
			fmenu 33 33 33 44 31 30
			;;
			5)
			fmenu 33 33 33 33 44 30
			;;
		esac
		#Lee sin mostrar lo que se escribe y solo una tecla
		read -s -n 1 tecla
		#Si le das a enter elige esa opcion
		if [ -z $tecla ];then
			op=$sit
			break
		##
		#Si pulsas w subes en el menu poniendo como limite la primera opcion
		elif [ $tecla = "w" ];then
			if [ $sit -eq 1 ];then
				sit=1
			else
				sit=$(($sit-1))
			fi
		##
		#Si pulsas s bajas en el menu poniendo como limite la ultima opcion
		elif [ $tecla = "s" ];then
			if [ $sit -eq 5 ];then
				sit=5
			else
				sit=$((sit+1))
			fi
		##
		#Si pulsas cualquier otra tecla pues no hace nada
		else
			sit=$sit
		fi
		##
		clear
	done
	##

	#Muestra de nuevo el cursor en la terminal
	tput cnorm
	##

	#Dependiendo de que opcion se haya elegido...
	case $sit in
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
		*)
			#Todo lo demas...
			fcolores 31 OPCION NO VALIDA
		;;
	esac
	##

	#La opcion 5 es salir
	if [ $sit -eq 5 ];then
		break
	##
	#Si no pues te pregunta si quieres hacer algo mas o no
	else
		read -p "¿Deseas algo mas (S/n)? " emp
		if [ -z $emp ] || [ $emp = "s" ] || [ $emp = "S" ];then
			clear
		else
			break
		fi
	fi
	##
done
##

#Limpia el fichero usuarios.txt pues ya no hacen falta esos usuarios
: > usuarios.txt
##

#Despedida con un cowsay de figura aleatoria y multicolor
fvaca Adios
##
