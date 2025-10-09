#!/bin/bash
# ===================================
# PASO 2: Particionado de discos (simplificado)
# ===================================

lsblk -o

echo "para ver cfdisk /dev/sda"
echo "# --- Formatear ---"
echo "mkfs.fat -F32 /dev/sda1"
echo "mkswap /dev/sda2"
echo "mkfs.ext4 /dev/sda3"

echo "✓ PASO 3 completado"
echo "Siguiente: ejecutar 04-montaje.sh"
