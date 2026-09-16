#!/bin/bash

#Funcion que añade todos los usuarios del fichero usuarios.txt al array bidimensional
function flusus() {
	i=0

	while IFS=":" read -r usu Uid grup carp shell;do
		usus[$i,usuario]=$usu
		usus[$i,grupo]=$grup
		usus[$i,carpeta]=$carp
		usus[$i,shell_ini]=$shell
		usus[$i,id]=$Uid
		#No se borra por defecto
		usus[$i,del]=0
		i=$(($i+1))
	done < usuarios.txt
}
##

#Funcion para ver los datos de los usuarios
function fvusus() {
	clear

	#Mostramos los usuarios disponibles en el array bidimensional
	j=0


	echo -e "\e[33mUsuarios: \e[0m"
	while [ $j -lt $i ];do
		echo -n "${usus[$j,usuario]} "
		j=$(($j+1))
	done
	echo ""
	##

	#Pedir el usuario deseado(ud)
	read -p "Introduce el usuario del cual quieras ver sus datos: " ud

	j=0

	#Comprobar que no se haya dejado vacia la variable ud y comprobar que el usuario deseado existe en la lista
	while true;do
		ex=0
		while [ $j -lt $i ];do
			#Si no se ha introducido nigun usuario...
			if [ -z "$ud" ];then
				fcolores 31 ERROR. NO HAS INTRODUCIDO NINGUN USUARIO
				break
			##
			#Si existe muestra todos sus datos
			elif [ "${usus[$j,usuario]}" = "$ud" ];then
				echo -e "\e[33mNombre de usuario: \e[0m${usus[$j,usuario]}"
				echo -e "\e[33mGrupo: \e[0m${usus[$j,grupo]}"
				echo -e "\e[33mCarpeta personal: \e[0m${usus[$j,carpeta]}"
				echo -e "\e[33mShell: \e[0m${usus[$j,shell_ini]}"
				echo -e "\e[33mUID: \e[0m${usus[$j,id]}"
				ex=1
				break
			else
				ex=2
			fi
			j=$(($j+1))
		done
		#Si existe se sale del bucle
		if [ $ex -eq 1 ];then
			break
		##
		#Si no existe dentro del array te lo avisa
		elif [ $ex -eq 2 ];then
			fcolores 31 ERROR. EL USUARIO INTRODUCIDO NO EXISTE
		fi
		##
		#Tanto si no existe en el array como si no introduje ninguno te vuelve a preguntar por un usuario
		read -p "Introduce el usuario del cual quieras ver sus datos: " ud
		j=0
	done
}
##

#Funcion para añadir usuarios al array bidimensional con sus respectivos controles
function fcusus() {
	clear
	while true;do
		read -p "Introduce el nombre: " usus[$i,usuario]
		if [ -z "${usus[$i,usuario]}" ];then
			echo -e "\e[31mERROR, NO HAS INTRODUCIDO NOMBRE\e[0m"
		else
			break
		fi
	done
	while true;do
		read -p "Introduce el grupo: " usus[$i,grupo]
		if [ -z "${usus[$i,grupo]}" ];then
			echo -e "\e[31mERROR, NO HAS INTRODUCIDO GRUPO\e[0m"
		else
			break
		fi
	done
	while true;do
		read -p "Introduce el carpeta: " usus[$i,carpeta]
		if [ -z "${usus[$i,carpeta]}" ];then
			usus[$i,carpeta]="/home/${usus[$i,usuario]}"
			break
		elif [[ "${usus[$i,carpeta]}" != /home/* ]];then
			echo -e "\e[31mERROR, NO HAS INTRODUCIDO CARPETA EN UN FORMATO CORRECTO\e[0m"
			echo -e "\e[33mRECUERDA QUE EL FORMATO ES -> /home/nombre_carpeta\e[0m"
		else
			break
		fi
	done
	while true;do
		corr=0
		read -p "Introduce la shell inicio: " usus[$i,shell_ini]
		for r in $(cat /etc/shells);do
			if [ -z "${usus[$i,shell_ini]}" ];then
				usus[$i,shell_ini]="/bin/bash"
				break
			elif [ "${usus[$i,shell_ini]}" = $r ];then
				corr=1
				break
			else
				corr=2
			fi
		done
		case $corr in
			1)
				break
			;;
			2)
				echo -e "\e[31mERROR, HAS INTRODUCIDO LA SHELL CON UN FORMATO INCORRECTO\e[0m"
				echo -e "\e[33mRECUERDA QUE ESTAS SON LAS DISPONIBLES:\e[0m"
				tail -n +2 /etc/shells
			;;
			*)
				break
			;;
		esac
	done
	while true;do
		read -p "Introduce el UID del usuario en caso de ya existir en passwd: " usus[$i,id]
		case ${usus[$i,id]} in
			#En caso de que la variable este vacia...
			"")
				break
			;;
			#En caso de que la variable contenga solo numeros...
			*[0-9]*)
				break
			;;
			#En caso de que sea cualquier otra cosa...
			*)
				fcolores 31 UID NO VALIDO
			;;
		esac
	done
	usus[$i,del]=0
	i=$(($i+1))
}
##

#Funcion para modificar usuarios dentro del array
function fmod() {
	clear
	j=0
	#Mostrar usuarios disponibles
	echo -e "\e[33mUsuarios: \e[0m"
	while [ $j -lt $i ];do
		echo -n "${usus[$j,usuario]} "
		j=$(($j+1))
	done
	##
	echo ""
	#Pedir el usuario deseado(ud)
	read -p "Introduce el usuario que quieras modificar: " ud
	j=0

	#Comprobar que no se haya dejado vacia la variable ud y comprobar que el usuario deseado existe en la lista
	while true;do
		ex=0
		while [ $j -lt $i ];do
			#Si no has introducido ningun usuario...
			if [ -z "$ud" ];then
				fcolores 31 ERROR. NO HAS INTRODUCIDO NINGUN USUARIO
				break
			##
			#Si existe mostramos un mini menu preguntando que campo se desea modificar
			elif [ "${usus[$j,usuario]}" = "$ud" ];then
				echo "1)Nombre de Usuario"
				echo "2)Grupo"
				echo "3)Carpeta Personal"
				echo "4)Shell Inicio"
				echo "5)UID"
				read -p "¿Que quieres modificar? " opmod
				case $opmod in
					#Modificar el nombre de usuario con sus respectivos controles
					1)
						echo -e "\e[33mNombre actual: ${usus[$j,usuario]}\e[0m"
						while true;do
							read -p "Introduce el nombre: " usus[$j,usuario]
							if [ -z "${usus[$j,usuario]}" ];then
								echo -e "\e[31mERROR, NO HAS INTRODUCIDO NOMBRE\e[0m"
							else
								break
							fi
						done
					;;
					#Modificar el grupo con sus respectivos controles
					2)
						echo -e "\e[33mGrupo actual: ${usus[$j,grupo]}\e[0m"
						while true;do
							read -p "Introduce el grupo: " usus[$j,grupo]
							if [ -z ${usus[$j,grupo]} ];then
								echo -e "\e[31mERROR, NO HAS INTRODUCIDO GRUPO\e[0m"
							else
								break
							fi
						done
					;;
					#Modificar la carpeta con sus respectivos controles
					3)
						echo -e "\e[33mCarpeta actual: ${usus[$j,carpeta]}\e[0m"
						while true;do
							read -p "Introduce el carpeta: " usus[$j,carpeta]
							if [ -z ${usus[$j,carpeta]} ];then
								echo -e "\e[31mERROR, NO HAS INTRODUCIDO CARPETA\e[0m"
							elif [[ ${usus[$j,carpeta]} != /home/* ]];then
								echo -e "\e[31mERROR, NO HAS INTRODUCIDO CARPETA EN UN FORMATO CORRECTO\e[0m"
								echo -e "\e[33mRECUERDA QUE EL FORMATO ES -> /home/nombre_carpeta\e[0m"
							else
								break
							fi
						done
					;;
					#Modificar la shell de inicio con sus respectivos controles
					4)
						echo -e "\e[33mShell actual: ${usus[$j,shell_ini]}\e[0m"
						while true;do
							corr=0
							read -p "Introduce la shell inicio: " usus[$j,shell_ini]
							for r in $(cat /etc/shells);do
								if [ -z ${usus[$j,shell_ini]} ];then
									echo -e "\e[31mERROR, NO HAS INTRODUCIDO SHELL\e[0m"
									break
								elif [ ${usus[$j,shell_ini]} = $r ];then
									corr=1
									break
								else
									corr=2
								fi
							done
							case $corr in
								1)
									break
								;;
								2)
									echo -e "\e[31mERROR, HAS INTRODUCIDO LA SHELL CON UN FORMATO INCORRECTO\e[0m"
									echo -e "\e[33mRECUERDA QUE ESTAS SON LAS DISPONIBLES:\e[0m"
									tail -n +2 /etc/shells
								;;
							esac
						done
					;;
					#Modificar el UID con sus respectivos controles
					5)
						echo -e "\e[33mUID actual: ${usus[$j,id]}\e[0m"
						while true;do
							read -p "Introduce el UID del usuario en caso de ya existir en passwd: " usus[$j,id]
							case ${usus[$i,id]} in
								#En caso de que la variable este vacia...
								"")
									break
								;;
								#En caso de que la variable contenga solo numeros...
								*[0-9]*)
									break
								;;
								#En caso de que sea cualquier otra cosa
								*)
									fcolores 31 UID NO VALIDO
								;;
							esac
						done
					;;
					#Si no introduces una opcion valida...
					*)
						fcolores 31 OPCION NO VALIDA
					;;
				esac
				ex=1
				break
			##
			else
				ex=2
			fi
			j=$(($j+1))
		done
		#Si existe se sale del bucle
		if [ $ex -eq 1 ];then
			break
		##
		#Si no existe se avisa y pide un nuevo usuario
		elif [ $ex -eq 2 ];then
			fcolores 31 ERROR. EL USUARIO INTRODUCIDO NO EXISTE
		fi
		read -p "Introduce el usuario que quieras modificar: " ud
		##
		j=0
	done
	##
}
##

#Funcion para borrar usuarios
function fdel() {
	clear
	#Mostrar todos los usuarios
	j=0
	echo -e "\e[33mUsuarios: \e[0m"
	while [ $j -lt $i ];do
		echo -n "${usus[$j,usuario]} "
		j=$(($j+1))
	done
	##
	echo ""
	#Pedir el usuario deseado(ud)
	read -p "Introduce el usuario que quieras borrar: " ud

	j=0

	#Comprobar que no se haya dejado vacia la variable ud y comprobar que el usuario deseado existe en la lista
	while true;do
		ex=0
		while [ $j -lt $i ];do
			if [ -z "$ud" ];then
				fcolores 31 ERROR. NO HAS INTRODUCIDO NINGUN USUARIO
				break
			#Si existe marcamaos para borrar el usuario deseado
			elif [ "${usus[$j,usuario]}" = "$ud" ];then
				usus[$j,del]=1
				ex=1
				break
			##
			else
				ex=2
			fi
			j=$(($j+1))
		done
		if [ $ex -eq 1 ];then
			break
		elif [ $ex -eq 2 ];then
			fcolores 31 ERROR. EL USUARIO INTRODUCIDO NO EXISTE
		fi
		read -p "Introduce el usuario que quieras borrar: " ud
		j=0
	done
	##
}

#Funcion que vuelca mediante comandos todo lo anterior al fichero passwd
function fvolcar() {
	j=0
	#Numero total de usuarios existentes EN EL SISTEMA
	n_usus_ex=$(wc -l /etc/passwd | cut -d " " -f 1)
	#Por cada usuario en el array...
	while [ $j -lt $i ];do
		cont=1
		#Comprueba todos los usuarios existentes EN EL SISTEMA...
		while IFS=":" read -r nombre _ Uid _ _ carpeta shell;do
			#Si el usuario DEL ARRAY NO tiene UID, su nombre y alguno de passwd son iguales y esta marcado para borrar pues se borra...
			if [ -z ${usus[$j,id]} ] && [ "${usus[$j,usuario]}" = "$nombre" ] && [ ${usus[$j,del]} -eq 1 ];then
				deluser "{usus[$j,usuario]}"
				break
			##
			#Si el usuario DEL ARRAY NO tiene UID, su nombre y alguno de passwd son iguales y NO esta marcado para borrar se modifica
			elif [ -z ${usus[$j,id]} ] && [ "${usus[$j,usuario]}" = "$nombre" ] && [ ${usus[$j,del]} -eq 0 ];then
				#Comprobar si el grupo existe y si no existe se crea
				ex=0
				for g in $(cat /etc/group | cut -d ":" -f 1);do
					if [ "${usus[$j,grupo]}" = "$g" ];then
						ex=1
						break
					fi
				done
				if [ $ex -eq 0 ];then
					addgroup "${usus[$j,grupo]}"
				fi
				##
				usermod -g "${usus[$j,grupo]}" -d "${usus[$j,carpeta]}" -s "${usus[$j,shell_ini]}" -m "$nombre"
				break
			##
			#Si el usuario DEL ARRAY NO tiene UID, su nombre NO COINCIDE con ninguno de passwd y NO esta marcado para borrar pues se crea...
			elif [ -z ${usus[$j,id]} ] && [ "${usus[$j,usuario]}" != "$nombre" ] && [ $cont -eq $n_usus_ex ] && [ ${usus[$j,del]} -eq 0 ];then
				#Comprobar si el grupo existe y si no existe se crea
				ex=0
				for g in $(cat /etc/group | cut -d ":" -f 1);do
					if [ "${usus[$j,grupo]}" = "$g" ];then
						ex=1
						break
					fi
				done
				if [ $ex -eq 0 ];then
					addgroup "${usus[$j,grupo]}"
				fi
				##
				#Se añade el usuario con contraseña "usuario'
				useradd -g "${usus[$j,grupo]}" -d "${usus[$j,carpeta]}" -s "${usus[$j,shell_ini]}" -m "${usus[$j,usuario]}" -p "usuario"
			##
			#Si el usuario del array tiene UID y esta marcado para borrar pues se borra...
			elif [ "${usus[$j,id]}" = "$Uid" ] && [ ${usus[$j,del]} -eq 1 ];then
				deluser "{usus[$j,usuario]}"
				break
			##
			#Si el usuario del array tiene UID y NO esta marcado para borrar pues se modifica...
			elif [ "${usus[$j,id]}" = "$Uid" ] && [ ${usus[$j,del]} -eq 0 ];then
				#Conseguir el nombre original del usuario al que le corresponda el UID
				usu_og=$(cat /etc/passwd | grep "$Uid" | cut -d ":" -f 1)
				#Comprobar si el grupo existe y si no existe se crea
				ex=0
				for g in $(cat /etc/group | cut -d ":" -f 1);do
					if [ "${usus[$j,grupo]}" = "$g" ];then
						ex=1
						break
					fi
				done
				if [ $ex -eq 0 ];then
					addgroup "${usus[$j,grupo]}"
				fi
				##
				#Conseguir el grupo perteneciente a ese usuario
				gid=$(id "$usu_og" | cut -d " " -f 2 | cut -d "(" -f 2 | cut -d ")" -f 1)
				#Si el nombre del usuario DEL ARRAY y EL ORIGINAL no coinciden se modifican todos los datos INCLUIDO EL NOMBRE
				if [ "${usus[$j,usuario]}" != "$nombre" ];then
					usermod -g "${usus[$j,grupo]}" -d "${usus[$j,carpeta]}" -s "${usus[$j,shell_ini]}" -l "${usus[$j,usuario]}" -m "$usu_og"
				##
				#Si el nombre del usuario DEL ARRAY y EL ORIGINAL coinciden se modifican todos los datos SIN INCLUIR EL NOMBRE
				elif [ "${usus[$j,carpeta]}" != "$carpeta" ] || [ "{usus[$j,shell_ini]}" != "$shell" ] || [ "${usus[$j,grupo]}" != "$gid" ];then
					usermod -g "${usus[$j,grupo]}" -d "${usus[$j,carpeta]}" -s "${usus[$j,shell_ini]}" -m "$usu_og"
				fi
				##
				break
			#Si el UID del usuario DEL ARRAY no coincide con ningun UID del PASSWD se avisa
			elif [ "${usus[$j,id]}" = "$Uid" ] && [ $cont -eq $n_usus_ex ];then
				fcolores 31 El usuario ${usus[$j,usuario]} NO TIENE UN UID EXISTENTE
				break
			fi
			##
			cont=$(($cont+1))
		done < /etc/passwd
		##
		j=$(($j+1))
	done
	##
}
##

