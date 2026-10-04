#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
compose=(docker compose -p sozluk -f docker/dev/compose.yml)
case "${1:-help}" in
  init)
    python3 - <<'PY'
from pathlib import Path
import secrets
import os
os.umask(0o077)
root = Path('.local')
root.mkdir(exist_ok=True)
paths = [root / 'django.env', root / 'postgres.env']
if all(p.exists() for p in paths):
    print('Local environment already exists; preserved.')
elif any(p.exists() for p in paths):
    raise SystemExit('Incomplete local environment; restore the missing file before retrying.')
else:
    password = secrets.token_hex(32)
    for target in paths:
        template = Path('conf/dev') / (target.name + '.example')
        value = template.read_text().replace('REPLACE_WITH_RANDOM_LOCAL_PASSWORD', password)
        value = value.replace('REPLACE_WITH_RANDOM_LOCAL_SECRET', secrets.token_hex(48))
        with target.open('x') as stream:
            stream.write(value)
    print('Created ignored local environment files.')
PY
    ;;
  setup)
    "${compose[@]}" up -d --build db redis rabbitmq web
    "${compose[@]}" exec -T web python manage.py quicksetup
    ;;
  manage) shift; "${compose[@]}" exec web python manage.py "$@" ;;
  *) "${compose[@]}" "$@" ;;
esac
