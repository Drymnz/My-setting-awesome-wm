#!/usr/bin/env bash
set -e

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Función para mostrar mensajes
show_message() {
    echo -e "${GREEN}==>${NC} $1"
}

show_warning() {
    echo -e "${YELLOW}==>${NC} $1"
}

show_error() {
    echo -e "${RED}==>${NC} $1"
}

# Función para ejecutar scripts
run_script() {
    local script_path="$1"
    if [[ -f "$script_path" ]]; then
        chmod +x "$script_path"
        source "$script_path"
    else
        show_error "No se encontró el archivo: $script_path"
        return 1
    fi
}

# Función para preguntar sí/no
ask_yes_no() {
    local prompt="$1"
    local response
    echo ""
    echo "$prompt [S/n]"
    read -r response
    [[ "${response,,}" == "s" ]] || [[ "${response,,}" == "" ]] || [[ -z "$response" ]]
}

clear
show_message "==================================="
show_message "  INSTALADOR DE ARCH LINUX"
show_message "==================================="
echo ""

# 1. DRIVERS DE VIDEO
clear
show_message "PASO 1: Drivers de Video"
echo ""
show_warning "Es recomendable instalar los drivers antes que el gestor de ventanas"
if ask_yes_no "¿Desea instalar drivers de video?"; then
    run_script "./logic/video/install-gpu.sh"
fi

# 2. GESTOR DE VENTANAS AWESOME (Base)
clear
show_message "PASO 2: Gestor de Ventanas Awesome"
echo ""
show_warning "Esto instalará: Xorg, Awesome WM, terminal, gestor de sesión"
if ask_yes_no "¿Desea instalar Awesome WM (instalación base)?"; then
    run_script "./logic/awesome/install-awesome-base.sh"
fi

# 3. UTILIDADES DEL SISTEMA
clear
show_message "PASO 3: Utilidades del Sistema"
echo ""
show_warning "Drivers USB, NTFS, Android, iPhone, herramientas del sistema"
if ask_yes_no "¿Desea instalar utilidades del sistema?"; then
    run_script "./logic/system/install-system-utils.sh"
fi

# 4. APLICACIONES Y EXTENSIONES PARA AWESOME
clear
show_message "PASO 4: Aplicaciones y Temas"
echo ""
show_warning "Aplicaciones multimedia, gestores, temas y fuentes"
if ask_yes_no "¿Desea instalar aplicaciones y temas adicionales?"; then
    run_script "./logic/awesome/install-awesome-apps.sh"
fi

# 5. YAY (AUR HELPER)
clear
show_message "PASO 5: Yay (Gestor de AUR)"
echo ""
if ask_yes_no "¿Desea instalar Yay para acceder a AUR?"; then
    run_script "./logic/aur/install-yay.sh"
    
    # Paquetes de AUR
    if ask_yes_no "¿Desea instalar paquetes adicionales desde AUR?"; then
        run_script "./logic/aur/install-aur-packages.sh"
    fi
fi

# 6. GAMING
clear
show_message "PASO 6: Gaming"
echo ""
show_warning "Vulkan, OpenGL, Wine, Steam, etc."
if ask_yes_no "¿Desea instalar paquetes para gaming?"; then
    run_script "./logic/gaming/install-gaming.sh"
fi

# 7. CONFIGURACIONES PERSONALIZADAS
clear
show_message "PASO 7: Configuraciones Personalizadas"
echo ""
if ask_yes_no "¿Desea aplicar las configuraciones personalizadas?"; then
    run_script "./logic/config/apply-configs.sh"
fi

# FINALIZACIÓN
clear
show_message "==================================="
show_message "  INSTALACIÓN COMPLETADA"
show_message "==================================="
echo ""
show_warning "Se recomienda reiniciar el sistema"
if ask_yes_no "¿Desea reiniciar ahora?"; then
    sudo reboot
fi