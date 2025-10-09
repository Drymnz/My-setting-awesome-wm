# Mostrar información de discos
lsblk -o

echo "cfdisk /dev/sda
# Crear:
# 1: 512M EFI System
# 2: 8–16G Linux swap
# 3: resto Linux filesystem
# Write → yes → Quit"


echo "✓ PASO 2 completado"
echo "Siguiente: ejecutar 03-formateo.sh"