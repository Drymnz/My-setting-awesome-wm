#!/usr/bin/env bash

# =============================================================================
# install-yay.sh
# Instalación de Yay — AUR Helper para Arch Linux
#
# Yay permite instalar paquetes del AUR (Arch User Repository),
# repositorio comunitario con miles de paquetes no oficiales.
# Se usa yay-bin (binario precompilado) para evitar compilar Go.
# =============================================================================

# --- Funciones de salida visual ---
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }
show_error()   { echo -e "\033[0;31m==>\033[0m $1"; }

# Directorio temporal para la compilación
dir_temp="${HOME}/temp-aur"

install_yay() {
    clear
    show_message "INSTALACIÓN DE YAY (AUR Helper)"
    echo ""

    # Verificar si yay ya está instalado
    if command -v yay &> /dev/null; then
        show_message "Yay ya está instalado:"
        yay --version
        return 0
    fi

    # Instalar dependencias: git para clonar, base-devel para compilar
    show_message "Instalando dependencias (git, base-devel)..."
    sudo pacman -S --needed git base-devel --noconfirm

    # Limpiar directorio temporal si ya existía de una instalación anterior
    [[ -d "${dir_temp}/yay-bin" ]] && rm -rf "${dir_temp}/yay-bin"
    mkdir -p "${dir_temp}"

    # Clonar yay-bin (binario precompilado, más rápido que compilar yay desde Go)
    show_message "Descargando yay-bin desde AUR..."
    git clone https://aur.archlinux.org/yay-bin.git "${dir_temp}/yay-bin"

    if [[ $? -ne 0 ]]; then
        show_error "Error al clonar el repositorio. Verifica tu conexión a internet."
        return 1
    fi

    # Compilar e instalar el paquete
    show_message "Instalando Yay..."
    cd "${dir_temp}/yay-bin" || return 1
    makepkg -si --noconfirm

    if [[ $? -ne 0 ]]; then
        show_error "Error durante la instalación de Yay."
        return 1
    fi

    # Limpiar directorio temporal
    cd "${HOME}" || return 1
    rm -rf "${dir_temp}"
    show_message "Directorio temporal limpiado"

    # Sincronizar base de datos del AUR
    show_message "Sincronizando base de datos..."
    yay -Sy

    echo ""
    show_message "Yay instalado correctamente. Usa 'yay -S <paquete>' para instalar desde AUR."
}

# --- Punto de entrada ---
install_yay