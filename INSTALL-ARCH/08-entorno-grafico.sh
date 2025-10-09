#!/bin/bash
# ===================================
# PASO 8: Instalación de entorno gráfico
# ===================================
# ESTE SCRIPT SE EJECUTA DENTRO DEL CHROOT

echo "=== PASO 8: Instalación de entorno gráfico ==="

echo "Se instalará:"
echo "  - Xorg (servidor gráfico)"
echo "  - Awesome WM (gestor de ventanas)"
echo "  - SDDM (gestor de inicio de sesión)"
echo "  - Herramientas: lxappearance, picom, rofi, alacritty"
echo "  - Applet de red"
echo ""

read -p "Presiona ENTER para continuar..."

echo ""
echo "1. Instalando servidor Xorg y Awesome WM..."
pacman -S --noconfirm xorg awesome sddm lxappearance picom rofi alacritty network-manager-applet

if [ $? -ne 0 ]; then
    echo "✗ ERROR durante la instalación"
    exit 1
fi

echo ""
echo "2. Habilitando SDDM (display manager)..."
systemctl enable sddm

echo ""
echo "✓ Entorno gráfico instalado"
echo ""
echo "Componentes instalados:"
echo "  - Awesome WM: Gestor de ventanas tiling"
echo "  - SDDM: Pantalla de login"
echo "  - Alacritty: Terminal"
echo "  - Rofi: Lanzador de aplicaciones"
echo "  - Picom: Compositor (efectos)"
echo "  - LXAppearance: Configuración de temas GTK"
echo ""
echo "✓ PASO 8 completado"
echo "Siguiente: ejecutar 09-drivers-graficos.sh (también dentro del chroot)"