#!/usr/bin/env bash
# Uso: bash build.sh [CARPETA_CON_DOOM.WAD]
# Intenta Crispy Doom (ultrawide); si falla, usa doomgeneric (la version estable).
rm -rf dist && mkdir -p dist/wad
if bash build_crispy.sh; then
  echo "=== MOTOR: Crispy Doom ==="
else
  echo "=== MOTOR: Crispy Doom fallo; se usa doomgeneric (4:3) ==="
  rm -rf dist && mkdir -p dist/wad
  bash build_doomgeneric.sh
fi
set -e
echo "Pon aqui tu DOOM2.WAD renombrado a doom2.wad (minusculas)." > dist/wad/LEEME.txt
if [ -n "$1" ]; then
  WAD=$(find "$1" -maxdepth 1 \( -iname doom2.wad -o -iname doom.wad -o -iname doom1.wad \) | head -1)
  [ -n "$WAD" ] || { echo "No hay DOOM2.WAD, DOOM.WAD ni DOOM1.WAD en $1"; exit 1; }
  cp "$WAD" "dist/wad/$(basename "$WAD" | tr 'A-Z' 'a-z')"
fi
cp manifest.json icon.png dist/
SZ=$(du -sb dist | cut -f1)
TOT=$((SZ + 15300000))
echo "Tamano sin WAD: $((SZ/1024)) KB. Con doom2.wad (~14,6 MB): ~$((TOT/1048576)) MB de 20 MB permitidos."
[ "$TOT" -gt 20971520 ] && echo "AVISO: con doom2.wad se pasa del limite de 20 MB del launcher."
python3 -c "import shutil;shutil.make_archive('doom-native','zip','dist')"
du -sh dist
echo "Motor usado: $(cat dist/motor.txt)"
