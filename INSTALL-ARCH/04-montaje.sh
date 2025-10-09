#!/bin/bash
# ===================================
# PASO 4: Montaje de particiones (simplificado)
# ===================================

echo "# --- Montar ---"
echo "# Partición root (ext4):"
echo "mount /dev/sda3 /mnt"
echo ""
echo "# Partición EFI (fat32):"
echo "mkdir -p /mnt/boot"
echo "mount /dev/sda1 /mnt/boot"
echo ""
echo "# Partición swap:"
echo "swapon /dev/sda2"

echo ""
echo "✓ PASO 4 completado — Particiones montadas correctamente"
