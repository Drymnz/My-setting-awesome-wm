#!/usr/bin/env bash


#Herramientas para awesome 
pkg_xorg="xorg xorg-xinit xorg-xinput"
#Ventana de permisos 
pkg_polkit="polkit-kde-agent"
#Requisitos del escritorio
pkg_terminal="alacritty"
#El escritorio
pkg_awesome="awesome"
#Para captura de pantalla
pkg_scrot="scrot xclip"
#Para tamaño de pantal 
pkg_configuracion_pantalla="lxrandr"
#Navegador
pkg_navegador="firefox"
#Transparencia
pkg_picom="picom"
#Controladores
pkg_android="android-tools gvfs-mtp"
pkg_ntfs="ntfs-3g gvfs-nfs gvfs-smb smartmontools"
pkg_exfast="exfat-utils fatresize"
pkg_usb="usbutils usb_modeswitch gvfs usbmuxd"
pkg_iphone="gvfs gvfs-afc gvfs-google gvfs-gphoto2 gvfs-goa"
pkg_mac="apparmor"
pkg_dvd="udftools syslinux"
#Manejador de fichero
pkg_file_manger="thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin"
#Gestor de escritrorios
pkg_sddm="sddm"
#Reproductor de musica en terminal
pkg_mpd="mpd mpc ncmpcpp"
#comandos de pacman 
no_confirmar="--noconfirm"
sudo="sudo"
need="--needed"

#Listado de paquetes
pkg_requisitos="${pkg_xorg}  ${pkg_terminal} ${pkg_scrot} ${pkg_configuracion_pantalla} ${pkg_polkit} ${pkg_navegador} ${pkg_picom}"
pkg_controladores="${pkg_mac}  ${pkg_iphone} ${pkg_usb} ${pkg_exfast} ${pkg_ntfs} ${pkg_android} "
pkg_herramientas_usuario="${pkg_mpd} ${pkg_gestor_con} ${pkg_gestor_energia} ${pkg_gestor_disco} "
#Variable de instalacion
instalar_pkg_uno="${sudo} pacman -S ${need} ${pkg_requisitos} ${pkg_controladores} ${pkg_herramientas_usuario}  ${no_confirmar} "

function solicitu_permisos(){
    clear
    echo " "
    echo " "
    echo "¡¡¡Permisos!!!"
    echo " "
    echo " "

}

#Copiar la configuracion
function copiar_configuraracion(){
        echo "Creando carpetas"
        mkdir -p "$HOME"/.config
        mkdir -p "$HOME"/.config/alacritty
        mkdir -p "$HOME"/.config/awesome
        mkdir -p "$HOME"/.ncmpcpp
        mkdir -p "$HOME"/.mpd
        echo "Copiando la configuracion parar awesome"
        cp -r /etc/xdg/awesome/rc.lua "$HOME"/.config/awesome/rc.lua
        cp -r /usr/share/doc/alacritty/example/alacritty.yml "$HOME"/.config/alacritty/alacritty.yml
        cp -r configuracionAWM/* "$HOME"/.config/awesome
        cp -r configuracionAlacritty/* "$HOME"/.config/alacritty
        cp -r configuracionMpd/* "$HOME"/.mpd
        cp -r configuracionNcmpcpp/* "$HOME"/.ncmpcpp
        echo "Copiando la configuracion de sddm"
        systemctl enable sddm.service
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp -r configuracionSession/* /etc/sddm.conf.d
        echo "Copiando la configuracion de pacman"
        sudo cp -r configuracionPacman/* /etc/pacman.conf

        #Instalar paquetes para jugar en linux
        echo "¿Desea bloquer actualizaciones de kernel? [S/n]"
        echo "  "
        echo "Nota: Es bueno bloquear si usas driver privativos, y tambien"
        echo "te ahoras la posibilidad de que se dañe linux"
        echo "siempre me pasaba con las distro despues de unas actualizaciones"
        echo "  "
        read -r  start_install
        if [[ "${start_install}" == "s" ]] || [[ "${start_install}" == "S" ]]
        then
            sudo tee -a /etc/pacman.conf >>> "IgnorePkg   = linux linux-hardened linux-lts linux-zen linux-xanmod-bin"
            sudo tee -a /etc/pacman.conf >>> "IgnorePkg   = linux-api-headers linux-firmware linux-firmware-whence"
            
        fi
}

function install-awesome-wm-start() {
    ##Actualizar paquetes
    solicitu_permisos
    sudo pacman -Syyu --noconfirm
    ##Controladores y paquetes para usar la configuracion awesome
    ${instalar_pkg_uno}
    ##Escritorio
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_awesome} --noconfirm
    ##Gestor de session
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_sddm} --noconfirm
    ##Gestor de archivos
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_file_manger} --noconfirm
}

install-awesome-wm-start