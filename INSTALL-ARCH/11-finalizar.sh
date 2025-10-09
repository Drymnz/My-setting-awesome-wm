#!/bin/bash
# ===================================
# PASO 11: Finalización y reinicio
# ===================================
# ESTE SCRIPT SE EJECUTA FUERA DEL CHROOT

echo "=== PASO 11: Finalización de la instalación ==="

# Verificar que NO estamos en chroot
if [ -f /root/swap_uuid.txt ]; then
    echo "✗ ERROR: Parece que estás dentro del chroot"
    echo ""
    echo "Para salir del chroot, ejecuta:"
    echo "  exit"
    echo ""
    echo "Luego ejecuta este script nuevamente"
    exit 1
fi

echo "Verificando sistema instalado..."

if ! mountpoint -q /mnt; then
    echo "✗ ERROR: /mnt no está montado"
    echo "Parece que la instalación no se completó o ya se desmontó"
    exit 1
fi

echo ""
echo "Resumen de la instalación:"
echo "  ✓ Sistema base instalado"
echo "  ✓ Kernel ZEN configurado"
echo "  ✓ GRUB instalado (UEFI)"
echo "  ✓ Entorno gráfico: Awesome WM + SDDM"
echo "  ✓ NetworkManager habilitado"
echo ""

echo "¿Deseas salir del chroot y reiniciar ahora? (s/n)"
read -r respuesta

if [ "$respuesta" != "s" ]; then
    echo "Reinicio cancelado"
    echo ""
    echo "Para reiniciar manualmente más tarde:"
    echo "  1. Sal del chroot si estás dentro: exit"
    echo "  2. Desmonta las particiones: umount -R /mnt"
    echo "  3. Reinicia: reboot"
    exit 0
fi

echo ""
echo "Saliendo del chroot (si estás dentro)..."
# No se puede ejecutar exit desde un script, el usuario debe hacerlo

echo ""
echo "Desmontando particiones..."
umount -R /mnt

if [ $? -eq 0 ]; then
    echo "✓ Particiones desmontadas correctamente"
else
    echo "⚠️  Advertencia: Algunas particiones no se pudieron desmontar"
    echo "Verifica que no haya ningún proceso usando /mnt"
fi

echo ""
echo "✓ Instalación completada"
echo ""
echo "═══════════════════════════════════════════════"
echo "  INSTALACIÓN DE ARCH LINUX COMPLETADA"
echo "═══════════════════════════════════════════════"
echo ""
echo "El sistema se reiniciará en 5 segundos..."
echo "Presiona Ctrl+C para cancelar"
echo ""

sleep 5

echo "Reiniciando..."
reboot