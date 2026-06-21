#!/usr/bin/env bash

# =============================================================================
# install-system-utils.sh
# Instalación de utilidades esenciales del sistema para Arch Linux
#
# NOTA: No requiere [multilib]. Todos los paquetes son de [extra] y [core].
# =============================================================================

# --- Funciones de salida visual ---
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }

# --- Paquetes base USB (siempre se instalan) ---
pkg_usb="usbutils usb_modeswitch gvfs usbmuxd"

# --- Soporte para dispositivos móviles ---
pkg_android="android-tools gvfs-mtp"       # Transferencia de archivos Android
pkg_iphone="gvfs-afc gvfs-gphoto2"         # Transferencia de archivos iPhone/cámaras

# --- Sistemas de archivos (siempre se instalan) ---
pkg_fs="ntfs-3g gvfs-nfs gvfs-smb fatresize udftools smartmontools"
# ntfs-3g   → discos Windows (NTFS)
# gvfs-nfs  → red NFS
# gvfs-smb  → red Samba/Windows
# fatresize → redimensionar FAT32
# udftools  → soporte DVD/UDF
# smartmontools → salud del disco

# --- Utilidades del sistema (siempre se instalan) ---
pkg_system="brightnessctl xfce4-power-manager gnome-disk-utility gnome-keyring libsecret"
# brightnessctl       → control de brillo (laptops)
# xfce4-power-manager → gestión de energía y batería
# gnome-disk-utility  → gestor visual de discos
# gnome-keyring       → almacén seguro de contraseñas
# libsecret           → API para acceder al keyring

# --- Red ---
pkg_network="networkmanager network-manager-applet"
# networkmanager        → gestor de conexiones de red
# network-manager-applet → ícono en la barra del sistema

# --- Bluetooth ---
pkg_bluetooth="bluez bluez-utils"
# bluez       → stack Bluetooth
# bluez-utils → herramientas CLI (bluetoothctl)

# --- Compresión (siempre se instalan) ---
pkg_archive="p7zip unzip unrar ark"
# p7zip → .7z
# unzip → .zip
# unrar → .rar
# ark   → gestor gráfico de archivos comprimidos

install_system_utils() {
    clear
    show_message "INSTALACIÓN DE UTILIDADES DEL SISTEMA"
    echo ""

    # === Soporte USB base (obligatorio) ===
    show_message "Instalando soporte USB..."
    sudo pacman -S --needed ${pkg_usb} --noconfirm

    # === Sistemas de archivos (obligatorio) ===
    show_message "Instalando soporte para sistemas de archivos..."
    sudo pacman -S --needed ${pkg_fs} --noconfirm

    # === Utilidades del sistema (obligatorio) ===
    show_message "Instalando utilidades del sistema..."
    sudo pacman -S --needed ${pkg_system} --noconfirm
    mkdir -p "$HOME/.local/share/keyrings"  # Directorio requerido por gnome-keyring

    # === Herramientas de compresión (obligatorio) ===
    show_message "Instalando herramientas de compresión..."
    sudo pacman -S --needed ${pkg_archive} --noconfirm

    # === NetworkManager (obligatorio, lo más probable es que ya esté) ===
    show_message "Configurando NetworkManager..."
    sudo pacman -S --needed ${pkg_network} --noconfirm
    sudo systemctl enable NetworkManager.service

    # === Dispositivos móviles (opcional) ===
    echo ""
    echo "¿Desea instalar soporte para dispositivos móviles?"
    echo "  1) Android + iPhone"
    echo "  2) Solo Android"
    echo "  3) Solo iPhone"
    echo "  4) Ninguno"
    read -r -p "Opción (default 4): " mobile_option

    case $mobile_option in
        1)
            show_message "Instalando soporte Android e iPhone..."
            sudo pacman -S --needed ${pkg_android} ${pkg_iphone} --noconfirm
            ;;
        2)
            show_message "Instalando soporte Android..."
            sudo pacman -S --needed ${pkg_android} --noconfirm
            ;;
        3)
            show_message "Instalando soporte iPhone..."
            sudo pacman -S --needed ${pkg_iphone} --noconfirm
            ;;
        *)
            show_warning "Saltando soporte para dispositivos móviles"
            ;;
    esac

    # === Bluetooth (opcional) ===
    echo ""
    echo "¿Desea instalar soporte Bluetooth? [s/N]"
    read -r install_bt
    if [[ "${install_bt,,}" == "s" ]]; then
        show_message "Instalando Bluetooth..."
        sudo pacman -S --needed ${pkg_bluetooth} --noconfirm
        sudo systemctl enable bluetooth.service
    fi

    echo ""
    show_message "Utilidades del sistema instaladas correctamente"
}

# --- Punto de entrada ---
install_system_utils