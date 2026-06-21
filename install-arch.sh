#!/usr/bin/env bash
set -e

# ============================================================================
# COLORES UTILIZADOS PARA LOS MENSAJES EN TERMINAL
# ============================================================================

RED='\033[0;31m'      # Mensajes de error
GREEN='\033[0;32m'    # Mensajes informativos
YELLOW='\033[1;33m'   # Advertencias
NC='\033[0m'          # Restablecer color por defecto

# ============================================================================
# FUNCIONES DE MENSAJERÍA
# ============================================================================

# Muestra un mensaje informativo.
show_message() {
    echo -e "${GREEN}==>${NC} $1"
}

# Muestra una advertencia.
show_warning() {
    echo -e "${YELLOW}==>${NC} $1"
}

# Muestra un mensaje de error.
show_error() {
    echo -e "${RED}==>${NC} $1"
}

# ============================================================================
# EJECUCIÓN DE MÓDULOS
# ============================================================================

# Ejecuta un script externo.
#
# Parámetros:
#   $1 -> Ruta del script.
#
# Comportamiento:
#   - Verifica que el archivo exista.
#   - Asigna permisos de ejecución.
#   - Lo carga en la sesión actual mediante 'source'.
#
# Nota:
#   Se utiliza 'source' para que el script comparta variables y funciones
#   con el instalador principal.
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

# ============================================================================
# CONFIRMACIÓN DEL USUARIO
# ============================================================================

# Realiza una pregunta de tipo Sí/No.
#
# Retorna:
#   0 -> Sí
#   1 -> No
#
# Se consideran respuestas válidas:
#   S, s o Enter (respuesta por defecto).
ask_yes_no() {
    local prompt="$1"
    local response

    echo ""
    echo "$prompt [S/n]"
    read -r response

    [[ "${response,,}" == "s" ]] || [[ "${response,,}" == "" ]] || [[ -z "$response" ]]
}

# ============================================================================
# INICIO DEL INSTALADOR
# ============================================================================

clear

show_message "==================================="
show_message "  INSTALADOR DE ARCH LINUX"
show_message "==================================="
echo ""

# ============================================================================
# PASO 1: DRIVERS DE VIDEO
# Instala los controladores gráficos antes del entorno gráfico.
# ============================================================================

clear
show_message "PASO 1: Drivers de Video"
echo ""

show_warning "Es recomendable instalar los drivers antes que el gestor de ventanas"

if ask_yes_no "¿Desea instalar drivers de video?"; then
    run_script "./logic/video/install-gpu.sh"
fi

# ============================================================================
# PASO 2: AWESOME WM (INSTALACIÓN BASE)
# Instala los componentes mínimos necesarios para iniciar Awesome WM.
# ============================================================================

clear
show_message "PASO 2: Gestor de Ventanas Awesome"
echo ""

show_warning "Esto instalará: Xorg, Awesome WM, terminal, gestor de sesión"

if ask_yes_no "¿Desea instalar Awesome WM (instalación base)?"; then
    run_script "./logic/awesome/install-awesome-base.sh"
fi

# ============================================================================
# PASO 3: UTILIDADES DEL SISTEMA
# Instala soporte adicional para dispositivos y sistemas de archivos.
# ============================================================================

clear
show_message "PASO 3: Utilidades del Sistema"
echo ""

show_warning "Drivers USB, NTFS, Android, iPhone, herramientas del sistema"

if ask_yes_no "¿Desea instalar utilidades del sistema?"; then
    run_script "./logic/system/install-system-utils.sh"
fi

# ============================================================================
# PASO 4: APLICACIONES Y TEMAS
# Instala software complementario, fuentes y personalización visual.
# ============================================================================

clear
show_message "PASO 4: Aplicaciones y Temas"
echo ""

show_warning "Aplicaciones multimedia, gestores, temas y fuentes"

if ask_yes_no "¿Desea instalar aplicaciones y temas adicionales?"; then
    run_script "./logic/awesome/install-awesome-apps.sh"
fi

# ============================================================================
# PASO 5: YAY Y PAQUETES AUR
# Permite instalar paquetes desde Arch User Repository (AUR).
# ============================================================================

clear
show_message "PASO 5: Yay (Gestor de AUR)"
echo ""

if ask_yes_no "¿Desea instalar Yay para acceder a AUR?"; then
    run_script "./logic/aur/install-yay.sh"

    # Instalación opcional de paquetes adicionales desde AUR.
    if ask_yes_no "¿Desea instalar paquetes adicionales desde AUR?"; then
        run_script "./logic/aur/install-aur-packages.sh"
    fi
fi

# ============================================================================
# PASO 6: GAMING
# Instala bibliotecas y herramientas relacionadas con videojuegos.
# ============================================================================

clear
show_message "PASO 6: Gaming"
echo ""

show_warning "Vulkan, OpenGL, Wine, Steam, etc."

if ask_yes_no "¿Desea instalar paquetes para gaming?"; then
    run_script "./logic/gaming/install-gaming.sh"
fi

# ============================================================================
# PASO 7: CONFIGURACIONES PERSONALIZADAS
# Aplica configuraciones, temas y archivos personalizados.
# ============================================================================

clear
show_message "PASO 7: Configuraciones Personalizadas"
echo ""

if ask_yes_no "¿Desea aplicar las configuraciones personalizadas?"; then
    run_script "./logic/config/apply-configs.sh"
fi

# ============================================================================
# FINALIZACIÓN
# Muestra el resumen final y ofrece reiniciar el sistema.
# ============================================================================

clear

show_message "==================================="
show_message "  INSTALACIÓN COMPLETADA"
show_message "==================================="
echo ""

show_warning "Se recomienda reiniciar el sistema"

if ask_yes_no "¿Desea reiniciar ahora?"; then
    sudo reboot
fi