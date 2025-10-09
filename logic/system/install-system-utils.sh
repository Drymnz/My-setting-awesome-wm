#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }

# Controladores de dispositivos
pkg_usb="usbutils usb_modeswitch gvfs usbmuxd"
pkg_android="android-tools gvfs-mtp"
pkg_iphone="gvfs-afc gvfs-gphoto2"
pkg_ntfs="ntfs-3g gvfs-nfs gvfs-smb"
pkg_fat="fatresize"
pkg_dvd="udftools"
pkg_disk="smartmontools"

# Utilidades del sistema
pkg_brightness="brightnessctl"
pkg_power="xfce4-power-manager"
pkg_disk_manager="gnome-disk-utility"
pkg_keyring="gnome-keyring libsecret libgnome-keyring apparmor"
pkg_network="networkmanager network-manager-applet"

# Herramientas adicionales
pkg_archive="p7zip unzip unrar ark"
pkg_bluetooth="bluez bluez-utils"

install_system_utils() {
    clear
    show_message "INSTALACIÓN DE UTILIDADES DEL SISTEMA"
    echo ""
    
    # USB y dispositivos externos
    show_message "Instalando soporte USB..."
    sudo pacman -S --needed ${pkg_usb} --noconfirm
    
    # Android
    echo ""
    echo "¿Desea instalar soporte para Android? [S/n]"
    read -r install_android
    if [[ "${install_android,,}" == "s" ]] || [[ -z "$install_android" ]]; then
        show_message "Instalando soporte Android..."
        sudo pacman -S --needed ${pkg_android} --noconfirm
    fi
    
    # iPhone
    echo ""
    echo "¿Desea instalar soporte para iPhone? [S/n]"
    read -r install_iphone
    if [[ "${install_iphone,,}" == "s" ]] || [[ -z "$install_iphone" ]]; then
        show_message "Instalando soporte iPhone..."
        sudo pacman -S --needed ${pkg_iphone} --noconfirm
    fi
    
    # Sistemas de archivos
    show_message "Instalando soporte para sistemas de archivos..."
    sudo pacman -S --needed ${pkg_ntfs} ${pkg_fat} ${pkg_dvd} ${pkg_disk} --noconfirm
    
    # Gestores del sistema
    show_message "Instalando gestores del sistema..."
    sudo pacman -S --needed ${pkg_brightness} ${pkg_power} ${pkg_disk_manager} \
                           ${pkg_keyring} --noconfirm
    
    # Crear directorio para keyrings
    mkdir -p "$HOME"/.local/share/keyrings
    
    # NetworkManager
    echo ""
    echo "¿Desea instalar NetworkManager? [S/n]"
    read -r install_nm
    if [[ "${install_nm,,}" == "s" ]] || [[ -z "$install_nm" ]]; then
        show_message "Instalando NetworkManager..."
        sudo pacman -S --needed ${pkg_network} --noconfirm
        sudo systemctl enable NetworkManager.service
    fi
    
    # Bluetooth
    echo ""
    echo "¿Desea instalar soporte Bluetooth? [S/n]"
    read -r install_bt
    if [[ "${install_bt,,}" == "s" ]] || [[ -z "$install_bt" ]]; then
        show_message "Instalando Bluetooth..."
        sudo pacman -S --needed ${pkg_bluetooth} --noconfirm
        sudo systemctl enable bluetooth.service
    fi
    
    # Herramientas de archivo
    show_message "Instalando herramientas de compresión..."
    sudo pacman -S --needed ${pkg_archive} --noconfirm
    
    show_message "Utilidades del sistema instaladas correctamente"
}

install_system_utils