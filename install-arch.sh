#!/usr/bin/env bash

set +x

#Instalar driver de video

clear 

echo "¿Desea iniciar la instalacion driver de video? [S/n]"
read -r  start_install
if [[ "${start_install}" == "s" ]] || [[ "${start_install}" == "S" ]]
then
    ##Persimisos
    chmod +x ./logic/install-gpu.sh
    ##Usara la funcion install
    source ./logic/install-gpu.sh
fi


#Instalar awesome

clear 

echo "¿Desea iniciar la instalacion Awesome con sus configuraciones? [S/n]"
read -r  start_install
if [[ "${start_install}" == "s" ]] || [[ "${start_install}" == "S" ]]
then
    ##Persimisos
    chmod +x ./logic/install-awesome-wm.sh
    ##Usara la funcion install
    source ./logic/install-awesome-wm.sh

    ##Persimisos
    chmod +x ./logic/install-extens-awesome.sh
    ##Usara la funcion install
    source ./logic/install-extens-awesome.sh
fi


#Instalar paquetes para jugar en linux

clear 

echo "¿Desea iniciar la instalacion paquetes para jugar en linux? [S/n]"
read -r  start_install
if [[ "${start_install}" == "s" ]] || [[ "${start_install}" == "S" ]]
then
    ##Persimisos
    chmod +x ./logic/install-gpu-game.sh
    ##Usara la funcion install
    source ./logic/install-gpu-game.sh
fi
