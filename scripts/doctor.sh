#!/usr/bin/env bash
set -uo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
failed=0
ok() { printf '[OK] %s\n' "$*"; }
missing() { printf '[EKSİK] %s\n' "$*"; failed=1; }
info() { printf '[BİLGİ] %s\n' "$*"; }

if ! command -v git >/dev/null 2>&1; then
    missing 'Git kurulu değil.'
else
    ok "$(git --version)"
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        ok "Git branch: $(git branch --show-current)"
        if [[ -n "$(git config --get user.name || true)" && -n "$(git config --get user.email || true)" ]]; then
            ok 'Git commit kimliği ayarlı.'
        else
            missing 'Git user.name ve user.email ayarlanmalı.'
        fi
        if git remote get-url upstream >/dev/null 2>&1; then
            ok 'upstream tanımlı.'
            [[ "$(git remote get-url --push upstream)" == DISABLED ]] && ok 'upstream için push kapalı.' || info 'upstream push adresini kontrol et.'
        else
            missing 'Kaynak upstream remote eksik.'
        fi
        git remote get-url origin >/dev/null 2>&1 && ok 'Kendi origin repon tanımlı.' || info 'origin henüz yok; yerelde çalışabilirsin.'
        git check-ignore -q .local/dev.env && ok '.local/dev.env Git tarafından yok sayılıyor.' || missing 'Yerel env dosyalarının ignore kuralı eksik.'
        if [[ -n "$(git ls-files -- .local .env '.env.*' '*.local.env' ':(exclude).env.example')" ]]; then
            missing 'Yerel env adlarıyla takip edilen dosyalar var; git ls-files ile yalnızca dosya adlarını kontrol et.'
        fi
    else
        missing 'Bu klasör henüz kaynak Git deposu değil; önce setup.sh çalıştır.'
    fi
fi

if command -v docker >/dev/null 2>&1; then
    ok "$(docker --version)"
    docker compose version >/dev/null 2>&1 && ok 'Docker Compose v2 kullanılabiliyor.' || missing 'Docker Compose v2 bulunamadı.'
    docker info >/dev/null 2>&1 && ok 'Docker daemon erişilebilir.' || missing 'Docker kapalı veya bu kullanıcı erişemiyor. Docker Desktop/Engine durumunu kontrol et.'
else
    missing 'Docker bulunamadı.'
fi
command -v code >/dev/null 2>&1 && ok 'VS Code terminal komutu kullanılabiliyor.' || info 'code komutu yok; VS Code üzerinden klasörü elle açabilirsin.'
command -v uv >/dev/null 2>&1 && info "$(uv --version) — Docker dışı araçlar için isteğe bağlı." || info 'Host uv yok; Docker yolu için şart değil.'
command -v just >/dev/null 2>&1 && info 'just kurulu.' || info 'just yok; kaynak justfile tariflerini okumak yine mümkün.'

if [[ -f pyproject.toml ]]; then
    # Only dependency metadata is read; never inspect secret/env contents.
    requirement="$(sed -n '/^[[:space:]]*requires-python[[:space:]]*=/p' pyproject.toml)"
    info "Kaynak Python kuralı: ${requirement:-pyproject.toml içinde kontrol et.}"
else
    missing 'pyproject.toml yok; upstream indirme tamamlanmamış olabilir.'
fi
[[ -f uv.lock ]] && ok 'Upstream uv.lock mevcut.' || info 'uv.lock yok; kaynağın bağımlılık yönetimini incele.'
[[ -f manage.py ]] && ok 'Django manage.py mevcut.' || missing 'manage.py bulunamadı.'

if command -v rg >/dev/null 2>&1; then
    info 'Kaynakta bulunan çalışma tarifleri (yalnızca dosya adları):'
    rg --files --hidden -g '!\.git/**' -g '!node_modules/**' -g '!\.venv/**' -g '!\.local/**' | rg '(^|/)(justfile|Makefile|[^/]*[Cc]ompose[^/]*\.(yml|yaml)|[^/]*Dockerfile[^/]*)$' || true
else
    info 'rg isteğe bağlı: çalışma tariflerini VS Code dosya ağacından incele.'
fi
if [[ "$failed" -eq 0 ]]; then
    printf '\nTemel araçlar hazır. Uygulamanın çalıştığı bu kontrolle doğrulanmış olmaz.\n'
else
    printf '\nEksikleri tamamladıktan sonra bu kontrolü yeniden çalıştır.\n'
fi
exit "$failed"
