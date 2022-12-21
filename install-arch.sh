#!/usr/bin/env bash

set +x

source ./logic/install-gpu.sh
source ./logic/install-gpu-game.sh
source ./logic/install-awesome-wm.sh

##Funcion para permisos de sh
function permisos(){
    #Permisos de instalacion
    chmod +x ./logic/install-gpu.sh
    chmod +x ./logic/install-gpu-game.sh
    chmod +x ./logic/install-awesome-wm.sh
    chmod +x ./logic/install-extens-awesome.sh
}
function permisos_two(){
    #Permisos de pos-instalacion
    chmod +x $HOME/.config/awesome/rofi/askpass.rasi
    chmod +x $HOME/.config/awesome/rofi/confirm.rasi
    chmod +x $HOME/.config/awesome/rofi/design-power.rasi
    chmod +x $HOME/.config/awesome/rofi/design.rasi
    chmod +x $HOME/.config/awesome/rofi/menu
    chmod +x $HOME/.config/awesome/rofi/powermenu
}
#Iniciar la instalacion
clear
echo "¿Desea iniciar la instalacion? [S/n]"
read -r  instalacion_inicial
if [[ "${instalacion_inicial}" == "s" ]] || [[ "${instalacion_inicial}" == "S" ]]
then
    ##Ceder permisos de ejecucion para los sh
    permisos
    ##Instalacion
    clear
    instalacion_gpu
    clear
    ###Instalacion de aweseme y su configuracion
    instalacion_awesome-wm
    copiar_configuraracion
    clear
    #Para que se puede usar los archivos copiado en rofi
    permisos_two
    #Solicitar para instalar paquetes Vulkan OpenGL Mesa Otros
    instalacion_gpu_game
    #Cargar fuentes de microsfot
    ##install_extends_fonts_microsoft
    install_yay
fi
