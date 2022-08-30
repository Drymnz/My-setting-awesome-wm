#!/usr/bin/env bash

source ./logic/install-gpu.sh
source ./logic/install-awesome-wm.sh

##Funcion para permisos de sh
function permisos(){
    chmod +x ./logic/install-gpu.sh
    chmod +x ./logic/install-awesome-wm.sh
}
#Iniciar la instalacion
echo "¿Desea iniciar la instalacion? [S/n]"
read -r  instalacion_inicial
if [[ "${instalacion_inicial}" == "s" ]] || [[ "${instalacion_inicial}" == "S" ]]
then
    ##Ceder permisos de ejecucion para los sh
    permisos
    ##Instalacion
    instalacion_gpu
    instalacion_awesome-wm
    #copiar_configuraracion
fi