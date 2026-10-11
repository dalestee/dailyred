#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GAME="$ROOT/pokefirered"

JOBS="$(nproc)"

echo "Building pokefirered with system toolchain..."
if [ "$#" -gt 0 ]; then
  make -C "$GAME" -j"$JOBS" MODERN=1 "$@"
  exit 0
fi

make -C "$GAME" -j"$JOBS" MODERN=1

ROM="$GAME/pokefirered_modern.gba"
mkdir -p "$ROOT/web/game"
rm -f "$ROOT/web/game/dailyred.gba"
gzip -9 -n -c "$ROM" > "$ROOT/web/game/dailyred.gba.gz"

if [ -f "$GAME/graphics/trainers/front_pics/red_front_pic.png" ]; then
  cp "$GAME/graphics/trainers/front_pics/red_front_pic.png" "$ROOT/web/game/red.png"
fi

echo
echo "Built $ROM"
echo "Website copy: web/game/dailyred.gba.gz ($(wc -c < "$ROOT/web/game/dailyred.gba.gz" | tr -d ' ') bytes)"
