#!/usr/bin/env bash
# Validación obligatoria de documentación.
# Si esta validación falla, el pipeline falla y el merge queda bloqueado.
set -e

echo "Validando documentación del proyecto..."

if [ ! -f README.md ]; then
  echo "ERROR: no existe README.md"
  exit 1
fi

if grep -q "TODO" README.md; then
  echo "ERROR: README.md contiene marcadores TODO sin resolver."
  grep -n "TODO" README.md
  exit 1
fi

echo "Documentación validada correctamente."
