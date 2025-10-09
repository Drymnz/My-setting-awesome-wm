#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }
show_error() { echo -e "\033[0;31m==>\033[0m $1"; }

install_aur_packages() {
    clear
    show_message "INSTALACIÓN DE PAQUETES DESDE AUR"
    echo ""
    
    # Verificar que yay esté instalado
    if ! command -v yay &> /dev/null; then
        show_error "Yay no está instalado. Instálelo primero."
        return 1
    fi
    
    # Fuentes de Microsoft
    echo "¿Desea instalar fuentes de Microsoft? [S/n]"
    read -r install_ms_fonts
    if [[ "${install_ms_fonts,,}" == "s" ]] || [[ -z "$install_ms_fonts" ]]; then
        show_message "Instalando fuentes de Microsoft..."
        yay -S --needed ttf-ms-fonts --noconfirm
    fi
    
    # Google Chrome
    echo ""
    echo "¿Desea instalar Google Chrome? [s/N]"
    read -r install_chrome
    if [[ "${install_chrome,,}" == "s" ]]; then
        show_message "Instalando Google Chrome..."
        yay -S --needed google-chrome --noconfirm
    fi
    
    # Visual Studio Code
    echo ""
    echo "¿Desea instalar Visual Studio Code? [s/N]"
    read -r install_vscode
    if [[ "${install_vscode,,}" == "s" ]]; then
        show_message "Instalando Visual Studio Code..."
        yay -S --needed visual-studio-code-bin --noconfirm
    fi
    
    # Spotify
    echo ""
    echo "¿Desea instalar Spotify? [s/N]"
    read -r install_spotify
    if [[ "${install_spotify,,}" == "s" ]]; then
        show_message "Instalando Spotify..."
        yay -S --needed spotify --noconfirm
    fi
    
    # Discord
    echo ""
    echo "¿Desea instalar Discord? [s/N]"
    read -r install_discord
    if [[ "${install_discord,,}" == "s" ]]; then
        show_message "Instalando Discord..."
        yay -S --needed discord --noconfirm
    fi
    
    # Paquetes adicionales personalizados
    echo ""
    echo "¿Desea instalar otros paquetes de AUR?"
    echo "Ingrese los nombres separados por espacio (Enter para omitir):"
    read -r custom_packages
    if [[ -n "$custom_packages" ]]; then
        show_message "Instalando paquetes personalizados..."
        yay -S --needed ${custom_packages}
    fi
    
    show_message "Instalación de paquetes AUR completada"
}

install_aur_packages