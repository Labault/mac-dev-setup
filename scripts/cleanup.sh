#!/usr/bin/env bash
#
# Nettoyage hebdo de l'établi : cruft macOS + caches régénérables.
# Lancé par launchd (dev.labault.cleanup), ou à la main : ./scripts/cleanup.sh
#
# GARANTIE : ne touche JAMAIS aux données. Pas de volume ni d'image Docker,
# pas de secret, pas de fichier projet. Uniquement du régénérable.
#
set -uo pipefail

LOG="${HOME}/Library/Logs/labault-cleanup.log"
log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "${LOG}"; }

log "=== cleanup start ==="

# 1. .DS_Store dans les dossiers réellement fréquentés par le Finder.
#    On élague node_modules/vendor/.git (gros, inutiles) pour rester rapide.
count=$(find "${HOME}/Documents" "${HOME}/Desktop" "${HOME}/Downloads" \
  -type d \( -name node_modules -o -name vendor -o -name .git \) -prune -o \
  -type f -name .DS_Store -print -delete 2>/dev/null | wc -l | tr -d ' ')
find "${HOME}" -maxdepth 1 -name .DS_Store -delete 2>/dev/null
log ".DS_Store supprimés : ${count}"

# 2. Homebrew (caches + vieilles versions)
if command -v brew >/dev/null 2>&1; then
  brew cleanup -s >/dev/null 2>&1 && log "brew cleanup : ok"
fi

# 3. npm
if command -v npm >/dev/null 2>&1; then
  npm cache clean --force >/dev/null 2>&1 && log "npm cache clean : ok"
fi

# 4. Docker : SEULEMENT le cache de build (jamais images/volumes = données)
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  freed=$(docker builder prune -f 2>/dev/null | awk '/Total:/ {print $2}')
  log "docker builder prune : ${freed:-0} libéré"
fi

# 5. pre-commit (dépôts d'environnements de hooks obsolètes)
if command -v pre-commit >/dev/null 2>&1; then
  pre-commit gc >/dev/null 2>&1 && log "pre-commit gc : ok"
fi

log "=== cleanup done ==="
