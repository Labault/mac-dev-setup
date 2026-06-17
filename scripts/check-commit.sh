#!/usr/bin/env bash

MSG=$(git log -1 --pretty=%B)

echo "Checking commit format..."

if [[ ! "$MSG" =~ ^(✨|🐛|👷|📝|🔧) ]]; then
  echo "❌ Commit must start with gitmoji (✨🐛👷📝🔧)"
  exit 1
fi

echo "✔ Commit format OK"
