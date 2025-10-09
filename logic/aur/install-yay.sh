#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_error() { echo -e "\033[0;31m==>\033[0m $1"; }

dir_temp="${HOME}/temp-aur"

install_yay() {
    clear
    show_message "INSTALACIÓN DE YAY (AUR Helper)"
    echo ""
    
    # Verificar si yay ya está instalado
    if command -v yay &> /dev/null; then
        show_message "Yay ya está instalado"
        yay --version
        return 0
    fi
    
    # Instalar dependencias necesarias
    show_message "Instalando dependencias..."
    sudo pacman -S --needed git base-devel --noconfirm
    
    # Crear directorio temporal
    mkdir -p "${dir_temp}"
    
    # Clonar repositorio
    show_message "Descargando Yay..."
    if [[ -d "${dir_temp}/yay-bin" ]]; then
        rm -rf "${dir_temp}/yay-bin"
    fi
    
    git clone https://aur.archlinux.org/yay-bin.git "${dir_temp}/yay-bin"
    
    if [[ $? -ne 0 ]]; then
        show_error "Error al clonar el repositorio de Yay"
        return 1
    fi
    
    # Compilar e instalar
    show_message "Compilando e instalando Yay..."
    cd "${dir_temp}/yay-bin"
    makepkg -si --noconfirm
    
    if [[ $? -eq 0 ]]; then
        show_message "Yay instalado correctamente"
        
        # Limpiar
        cd ~
        rm -rf "${dir_temp}/yay-bin"
        
        # Actualizar base de datos de AUR
        show_message "Actualizando base de datos..."
        yay -Sy
    else
        show_error "Error al instalar Yay"
        return 1
    fi
}

install_yay