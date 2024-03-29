#!/usr/bin/env bash
#Herramientas para awesome 
pkg_xorg="xorg xorg-xinit xorg-xinput"
#Ventana de permisos 
pkg_polkit="polkit-kde-agent"
#Requisitos del escritorio
pkg_terminal="alacritty"
#El escritorio
pkg_awesome="awesome"
#Editor de texto terminal
pkg_text="nano"
#pkg_text="vim"
#Para captura de pantalla
pkg_scrot="scrot xclip"
#Para tamaño de pantal 
pkg_configuracion_pantalla="lxrandr"
#Navegador
pkg_navegador="firefox"
#Transparencia
pkg_picom="picom"
#Reproductor de musica en terminal
pkg_mpd="mpd mpc ncmpcpp"
#Gestor de escritrorios
pkg_sddm="sddm"
#Controladores
pkg_android="android-tools gvfs-mtp"
pkg_ntfs="ntfs-3g gvfs-nfs gvfs-smb smartmontools"
pkg_exfast="fatresize"
pkg_usb="usbutils usb_modeswitch gvfs usbmuxd"
pkg_iphone="gvfs gvfs-afc gvfs-google gvfs-gphoto2 gvfs-goa"
pkg_mac="apparmor"
pkg_dvd="udftools syslinux"
#Manejador de fichero
pkg_file_manger="thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin"

#comandos de pacman 
no_confirmar="--noconfirm"
sudo="sudo"
need="--needed"

#Listado de paquetes
pkg_requisitos="${pkg_xorg}  ${pkg_terminal} ${pkg_scrot} ${pkg_configuracion_pantalla} ${pkg_polkit} ${pkg_navegador} ${pkg_picom} ${pkg_mpd} ${pkg_text}"
pkg_controladores="${pkg_mac}  ${pkg_iphone} ${pkg_usb} ${pkg_exfast} ${pkg_ntfs} ${pkg_android} "

function solicitu_permisos(){
    
    echo " "
    echo " "
    echo "¡¡¡Permisos!!!"
    echo " "
    echo " "

}

## Mostrar y ejecutar
function mostrar_ejecutar(){
    echo "$1" 
    $1
}

#Copiar la configuracion
function copiar_configuraracion(){
        echo "Crear carpetas"
        mostrar_ejecutar "mkdir -p "$HOME"/.config"
        mostrar_ejecutar "mkdir -p "$HOME"/.config/alacritty"
        mostrar_ejecutar "mkdir -p "$HOME"/.config/awesome"
        mostrar_ejecutar "mkdir -p "$HOME"/.ncmpcpp"
        mostrar_ejecutar "mkdir -p "$HOME"/.ncmpcpp/lyrics"
        mostrar_ejecutar "mkdir -p "$HOME"/.mpd"
        mostrar_ejecutar "mkdir -p "$HOME"/.mpd/playlists"
        mostrar_ejecutar "mkdir -p "$HOME"/Music"
        echo "Copiando la configuracion parar awesome"
        ##Copiando las configuraciones predeterminadas 
        mostrar_ejecutar "mkdir -p "$HOME"/.config" "cp -r /etc/xdg/awesome/rc.lua "$HOME"/.config/awesome/rc.lua"
        mostrar_ejecutar "cp -r /usr/share/doc/alacritty/example/alacritty.yml "$HOME"/.config/alacritty/alacritty.yml"
        mostrar_ejecutar "cp -r /etc/nanorc "$HOME"/.config/nano/nanorc"
        ##Copiando las configuraciones personalizadas
        mostrar_ejecutar "cp -r configuracionAWM/* "$HOME"/.config/awesome"
        mostrar_ejecutar "cp -r configuracionAlacritty/* "$HOME"/.config/alacritty"
        mostrar_ejecutar "cp -r configuracionMpd/* "$HOME"/.mpd"
        mostrar_ejecutar "cp -r configuracionNcmpcpp/* "$HOME"/.ncmpcpp"
        mostrar_ejecutar "cp -r Music/* "$HOME"/Music"

        echo "Copiando la configuracion de nano"
        mostrar_ejecutar "cp -r configuracionNano/* "$HOME"/.config/nano/nanorc"

        #configuraciones de terminal
        echo "Copiando la configuracion de bash"
        mostrar_ejecutar "bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)""
        mostrar_ejecutar "cp -r configuracionBash/.bashrc "$HOME"/"

        ##Configuraciones del gestor de ventanas
        mostrar_ejecutar "sudo systemctl enable sddm.service"
        echo "Copiando la configuracion de sddm"
        mostrar_ejecutar "sudo mkdir -p /etc/sddm.conf.d"
        mostrar_ejecutar "sudo cp -r configuracionSession/* /etc/sddm.conf.d"
        mostrar_ejecutar "mpc update"

        #Instalar paquetes para jugar en linux
        echo "  "
        echo "  "
        echo "  "
        echo "¿Desea bloquer actualizaciones de kernel? [S/n]"
        echo "  "
        echo "Nota: Es bueno bloquear si usas driver privativos, y tambien"
        echo "te ahoras la posibilidad de que se dañe linux"
        echo "siempre me pasaba con las distro despues de unas actualizaciones"
        echo "  "
        read -r  start_install
        if [[ "${start_install}" == "s" ]] || [[ "${start_install}" == "S" ]]
        then
            mostrar_ejecutar "sudo cp -r configuracionPacman/* /etc/pacman.conf"
        fi
}

function install-awesome-wm-start() {
    ##Actualizar paquetes
    solicitu_permisos
    sudo pacman -Syyu --noconfirm
    ##Requisitos para instalar awesome
    ${sudo} pacman -S --needed ${pkg_requisitos} --noconfirm
    ##Escritorio
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_awesome} --noconfirm
    ##Gestor de session
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_sddm} --noconfirm
    ##Gestor de archivos
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_file_manger} --noconfirm
    ##Instalar controladores
    solicitu_permisos
    ${sudo} pacman -S --needed ${pkg_controladores} --noconfirm
}

##Instalacion de awesome
install-awesome-wm-start
##Cargar las configuraciones al sistema
copiar_configuraracion