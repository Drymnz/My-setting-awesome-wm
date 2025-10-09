#!/bin/bash
# ===================================
# PASO 9: Instalación de drivers gráficos
# ===================================
# ESTE SCRIPT SE EJECUTA DENTRO DEL CHROOT

echo "=== PASO 9: Instalación de drivers gráficos ==="

echo "Detectando hardware gráfico..."
lspci | grep -E "VGA|3D"

echo ""
echo "Selecciona tu configuración de GPU:"
echo "1) Solo Intel (integrada)"
echo "2) Solo NVIDIA (dedicada)"
echo "3) Intel + NVIDIA (híbrida/Optimus)"
echo "4) AMD"
echo "5) Otro/Saltar este paso"
echo ""
read -p "Opción: " GPU_OPTION

case $GPU_OPTION in
    1)
        echo ""
        echo "Instalando drivers Intel..."
        pacman -S --noconfirm mesa xf86-video-intel vulkan-intel
        echo "✓ Drivers Intel instalados"
        ;;
    
    2)
        echo ""
        echo "Instalando drivers NVIDIA..."
        pacman -S --noconfirm nvidia nvidia-utils
        echo "✓ Drivers NVIDIA instalados"
        echo ""
        echo "⚠️  Recuerda configurar el módulo nvidia en mkinitcpio si usas solo NVIDIA"
        ;;
    
    3)
        echo ""
        echo "Instalando drivers para configuración híbrida Intel + NVIDIA..."
        echo "Instalando drivers Intel..."
        pacman -S --noconfirm mesa xf86-video-intel vulkan-intel
        
        echo "Instalando drivers NVIDIA con Optimus..."
        pacman -S --noconfirm nvidia nvidia-utils nvidia-prime
        
        echo ""
        echo "✓ Drivers híbridos instalados"
        echo ""
        echo "Información importante sobre Optimus:"
        echo "  - nvidia-prime está instalado"
        echo "  - Para usar NVIDIA: prime-run <aplicacion>"
        echo "  - Ejemplo: prime-run glxinfo | grep vendor"
        echo "  - Por defecto usará Intel (ahorro de energía)"
        ;;
    
    4)
        echo ""
        echo "Instalando drivers AMD..."
        pacman -S --noconfirm mesa xf86-video-amdgpu vulkan-radeon
        echo "✓ Drivers AMD instalados"
        ;;
    
    5)
        echo "Saltando instalación de drivers gráficos"
        ;;
    
    *)
        echo "Opción no válida, saltando instalación de drivers"
        ;;
esac

echo ""
echo "✓ PASO 9 completado"
echo ""
echo "Siguiente: ejecutar 10-usuario.sh (también dentro del chroot)"