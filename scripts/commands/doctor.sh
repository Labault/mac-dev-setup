#!/bin/bash

set -e

echo "🩺 Mac Doctor - System diagnostics"
echo "----------------------------------"

echo ""
echo "🖥 System"
echo "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "Arch: $(uname -m)"

echo ""
echo "🧰 Tools"

command -v brew >/dev/null && echo "✔ brew installed" || echo "❌ brew missing"
command -v git >/dev/null && echo "✔ git installed" || echo "❌ git missing"
command -v zsh >/dev/null && echo "✔ zsh installed" || echo "❌ zsh missing"

echo ""
echo "🍺 Homebrew"

if command -v brew >/dev/null; then
  brew doctor >/dev/null 2>&1 && echo "✔ brew OK" || echo "⚠ brew warnings"
fi

echo ""
echo "⚡ mac CLI"

command -v mac >/dev/null && echo "✔ mac CLI OK" || echo "❌ mac CLI missing"

echo ""
echo "✅ Doctor done"
