# 🐧 bash-user-manager
Sistema de gestión de usuarios escrito en **Bash** que usa una
estructura híbrida (array indexado + array asociativo) para simular un
**array bidimensional**. Lee usuarios desde `usuarios.txt`, permite
manipularlos en memoria (ver, crear, modificar, marcar para borrar) y
volcar cambios finales al sistema (`/etc/passwd`) cuando el operador lo
decida.

Este proyecto está formado por tres scripts en Bash y un archivos de
texto.\
Su objetivo es la **administración de usuarios en Ubuntu
Server**, separando el proceso en dos partes:
1) Introducir los usuarios en un array bidimensional
2) Crearlos realmente en el sistema.

------------------------------------------------------------------------

## Estructura del repositorio

    ├── funciones.sh      
    ├── fusus.sh          
    ├── scarraybid1.sh    
    ├── usuarios.txt       
    └── README.md

------------------------------------------------------------------------

## 📁 Archivos incluidos

### ✅ **funciones.sh**

Script de funciones auxiliares (en este caso solo se utiliza para los colores y la despedida). 


------------------------------------------------------------------------

### ✅ **scarrayabid1.sh**

Script principal encargado de mostrar el menu principal y llamar a las funciones de `fusus.sh`. 
-  Navegación del menú.
- Llama a las funcionesde `fusus.sh`
- Limpia `usuarios.txt` cuando termina.

------------------------------------------------------------------------

### ✅ **fusus.sh**

Script donde se encuentran las funciones que posteriormente seran llamadas en `scarrayabid1.sh`. 
- Funcion que lee `usuarios.txt` y carga los usuarios en el array bidimensional.
- Funcion que muestra los datos de los usuarios del array bidimensional
- Funcion que crea nuevos usuarios en el array bidimensional.
- Funcion que modifica los usuarios del array bidimensional.
- Funcion que marca los usuarios del array bidimensional para borrarlos posteriormente
- Vuelca todo lo anterior a `/etc/passwd` mediante comandos

------------------------------------------------------------------------

### ✅ **usuarios.txt**

Archivo temporal donde se guardan los usuarios pendientes de crear.\
Sirve para revisarlos antes de que el script principal los procese.

------------------------------------------------------------------------

## 🚀 Cómo usar el proyecto

### 1.  Dar permisos:

        chmod +x scarraybid1.sh fusus.sh funciones.sh

### 2.  Ejecutar:

        ./scarraybid1.sh

### 3.  Navegación del menú:

    -   `w` = subir
    -   `s` = bajar
    -   `Enter` = seleccionar


------------------------------------------------------------------------

## 📌 Requisitos importantes

-   Sistema: Ubuntu / Debian (o similar)

-   `bash` 4.0+ (soporte a arrays asociativos)

-   Permisos para crear/eliminar usuarios en el sistema

-   Paquetes adicionales necesarios:

        sudo apt install cowsay
        sudo apt install lolcat

------------------------------------------------------------------------

## 🎯 Objetivo del proyecto

Este proyecto está pensado como práctica de ASIR para aprender: 
- Manejo de arrays bidimensionales (array indexado + array asociativo) en Bash.
- Gestión de usuarios y grupos en Linux.
- Organización de scripts reales para un entorno de administración.
