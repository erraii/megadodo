# Megadodo — yerel geliştirme

Hedef düzen: VS Code + Codex, Git ve Docker Compose. Kaynak adayımız
[realsuayip/django-sozluk](https://github.com/realsuayip/django-sozluk).
Docker ilk değerlendirmede Python, PostgreSQL ve diğer servisleri
bilgisayara ayrı ayrı kurma ihtiyacını azaltır.

## Kaynak doğrulaması

Bu checkout Python `==3.14.*` ister (`pyproject.toml` ve `uv.lock`).
Mevcut `docker/dev/compose.yml`, `common.yml` ve `dev.Dockerfile` kullanılır.
Dockerfile Python 3.14 imajlarıyla `uv sync --frozen` çalıştırır; lockfile
korunur. PostgreSQL 18, Redis ve RabbitMQ kaynakta sabitlenmiş imajlardır.
Kod `/app` bind mount üzerinden Django runserver tarafından yeniden yüklenir.
PostgreSQL `sozluk_pg-data` volume'ünde kalır; yalnızca web portu
`127.0.0.1:8000` üzerinden yayımlanır. Host Python 3 yalnızca secret üretir.

## 1. Bilgisayarını hazırla

Paket Bash ile çalışır: Linux, macOS veya Windows içinde WSL2 kullan.
Bilgisayarın zaten bunlardan biriyle hazırsa tekrar kurulum yapma.

### Windows

PowerShell'i yönetici olarak aç:

```powershell
wsl --install -d Ubuntu
```

Gerekirse yeniden başlat. Ubuntu'yu aç, Linux kullanıcı adı/parola oluştur.
VS Code ve WSL uzantısını Windows tarafında kur. Docker Desktop kur ve başlat.
Docker Desktop'ta **Settings → Resources → WSL Integration** bölümünde
Ubuntu entegrasyonunu aç. Linux containers/WSL2 backend kullan.

Geri kalan terminal komutlarını **Ubuntu terminalinde** çalıştır:

```bash
sudo apt update
sudo apt install git unzip ripgrep gh python3
mkdir -p ~/code
```

Projeyi `~/code` altında tut. `/mnt/c` altında çalışmak yerine Linux
dosya sistemini kullanmak bu düzen için daha uygundur. Windows'tan
`\\wsl$\Ubuntu\home\LINUX_KULLANICIN\code` üzerinden erişebilirsin.

### Kişisel Linux bilgisayarı

Git, unzip ve ripgrep kur. Ubuntu/Debian için:

```bash
sudo apt update
sudo apt install git unzip ripgrep gh python3
mkdir -p ~/code
```

Docker Engine ve Compose v2'yi dağıtımına uygun resmi Docker talimatıyla
kur. `docker info` normal kullanıcı terminalinden çalışmalı. Docker zaten
kuruluysa önce onu kontrol et; başka Docker kurulumu ekleme.

42 okul bilgisayarında sudo veya Docker erişimi yoksa bu kurulumun tamamı
çalışmayabilir. Git/VS Code kullanılabilir; uygulama runtime'ı için kişisel
bilgisayar veya okulun sağladığı container ortamı gerekir.

### macOS

Git, VS Code ve Docker Desktop kur. Docker Desktop'ı başlat. Homebrew
zaten kullanıyorsan yardımcı araçlar için:

```bash
brew install git ripgrep gh
mkdir -p ~/code
```

`code` komutu yoksa VS Code Command Palette içinden **Shell Command:
Install 'code' command in PATH** seç. Uygulama bağımlılıkları container içinde kurulur. `init` komutu için host
üzerinde Python 3 gerekir (`python3 --version` ile kontrol et).

## 2. Başlangıç paketini çıkart ve kaynak kodu indir

ZIP'i ayrı bir klasöre çıkart. Aşağıdaki örnekte paket `~/code/42-sozluk-devkit`
altında, yeni proje ise `~/code/42-sozluk` altında olacak.

```bash
cd ~/code/42-sozluk-devkit
bash setup.sh --project "$HOME/code/42-sozluk" --name "Ad Soyad" --email "GIT_EPOSTAN"
cd ~/code/42-sozluk
bash scripts/doctor.sh
code .
```

`GIT_EPOSTAN` yerine GitHub hesabında doğrulanmış e-postanı veya GitHub
Settings → Emails altında gösterilen tam noreply adresini kullan. Bu
paket global Git ayarlarını değiştirmez; kimlik ve tercihleri bu repo için ayarlar.
Hedef proje klasörü önceden varsa üzerine yazmaz; yeni bir yol seç.

Kurulum betiği:

- Tam Git geçmişiyle kaynak depoyu indirir; kaynak remote'u `upstream` olur.
- Başlangıç commit'inden `main` oluşturur, kaynak depoya yanlışlıkla push'u kapatır.
- Commit kimliği, LF satır sonları ve `pull.ff=only` gibi yerel Git ayarlarını koyar.
- AGENTS.md, VS Code önerileri, kontroller ve bu rehberi ekler.
- Kaynak commit'ini docs/UPSTREAM.md içinde kaydeder.
- Commit, push veya işletim sistemi paket kurulumu yapmaz.

İleride aynı başlangıç sürümünü tekrar indirmek için `--revision` ile
docs/UPSTREAM.md içindeki tam commit SHA'yı verebilirsin.

## 3. Codex'i VS Code'a bağla

VS Code Extensions ekranında **OpenAI tarafından yayımlanan Codex**
uzantısını kur. Paket bu uzantıyı da önerir. Codex panelinde **Sign in with
ChatGPT** seç ve mevcut ChatGPT hesabınla giriş yap. Bu geliştirme düzeni
OpenAI API anahtarı kullanmaz.

Windows/WSL'de proje `code .` ile Ubuntu'dan açılmalı; VS Code sol altında
**WSL: Ubuntu** görünmeli. WSL içinde çalışacak agent için VS Code ayarlarında
`chatgpt.runCodexInWindowsSubsystemForLinux` seçeneğini açabilirsin.

Bu sohbet ortamı bilgisayarındaki kurulumu kendiliğinden değiştirmez.
VS Code'daki yerel Codex proje dosyalarını okuyup düzenleyebilir.

## 4. Kendi GitHub deponu bağla

Projenin adı **Megadodo**, deposu [erraii/megadodo](https://github.com/erraii/megadodo).
Bu checkout'ta origin zaten bu adrese bağlıdır. Yeni bir kurulum için GitHub'da
**megadodo** adında boş bir repository kullan. İlk
geliştirmede private tercih edebilirsin. README, lisans veya .gitignore ile
başlatma: bunlar klonladığımız kaynakta var. Bu yöntem bağımsız bir repo
oluşturur; kaynak geçmişi ve LICENSE dosyası korunur.

GitHub CLI (`gh`) kuruluysa HTTPS kimlik doğrulamasını bir kez ayarla:

```bash
gh auth login
gh auth setup-git
```

GitHub.com → HTTPS → web browser seçeneklerini kullan. Terminalde hesap
parolanı Git parolası olarak kullanma. SSH bağlantın zaten hazırsa doğrudan
SSH repo adresini de kullanabilirsin.

```bash
cd ~/code/42-sozluk
git remote add origin https://github.com/erraii/megadodo.git
git status --short
git diff --check
git add AGENTS.md .editorconfig .gitattributes .gitignore .vscode scripts docs
git diff --cached --stat
git commit -m "chore: prepare local development workflow"
git push -u origin main
```

`setup.sh --origin ...`
seçeneğini kullandıysan veya origin zaten tanımlıysa `git remote add origin`
adımını atla. Adresi düzeltmek gerekirse `git remote set-url origin
https://github.com/erraii/megadodo.git` kullan. Buradaki push
ilk kontrol noktasını saklar; proje henüz çalışır uygulama hâline gelmez.

| İsim | Amaç |
| --- | --- |
| `origin` | Megadodo depon; kendi commit'lerin buraya gider |
| `upstream` | Orijinal django-sozluk kaynağı; başlangıcı ve ilerideki güncellemeleri takip ederiz |
| `main` | Gözden geçirilmiş, çalışan sürümler |
| `chore/local-runtime` | İlk uygulama kurulum işi |
| `feat/42-login` | İleride gerçek 42 girişi için ayrı iş |

## 5. Uygulamayı yerelde çalıştıracak ilk görev

```bash
git switch chore/local-runtime  # Dal henüz yoksa: git switch -c chore/local-runtime
```

Depo kökünden:

```bash
bash scripts/local.sh init
bash scripts/local.sh setup
bash scripts/local.sh exec -T web python manage.py check
bash scripts/local.sh exec -T web python manage.py migrate --check
curl --fail --silent --output /dev/null --write-out '%{http_code}\n' http://127.0.0.1:8000/
```

`init` `.local/django.env` ve `.local/postgres.env` dosyalarını rastgele,
eşleşen parolayla ve yalnızca kullanıcı erişimiyle oluşturur. Var olan
dosyaları korur; eksik bir çift varsa hata verir. Secret dosyalarını
paylaşma veya commit etme. Takip edilen `.example` dosyaları placeholder içerir.
Kaynağın `conf/dev/*.env` dosyaları bu düzende kullanılmaz.

`setup` imajı oluşturur, servisleri başlatır, PostgreSQL hazır olunca
`quicksetup` çalıştırır: migration, collectstatic ve iki sistem hesabı.
Tekrar çalıştırmak veri silmez. Normal geliştirmede:

```bash
bash scripts/local.sh up -d db redis rabbitmq web
bash scripts/local.sh stop
bash scripts/local.sh up -d db redis rabbitmq web
bash scripts/local.sh manage migrate
bash scripts/local.sh manage createsuperuser
bash scripts/local.sh manage shell
bash scripts/local.sh manage check
bash scripts/local.sh logs --tail 100 web
```

Admin hesabını interaktif oluştur; parola komut satırına yazılmaz.
Bu hesap yalnızca aday uygulamanın yerel değerlendirmesi içindir.
Admin: http://127.0.0.1:8000/admin/ . Gerçek 42 OAuth henüz yok.
`justfile` da varsayılan olarak aynı temel Compose dosyasını kullanır.
Önce `init` ve `setup` çalıştırılmalıdır. Celery isteğe bağlıdır: `bash scripts/local.sh --profile workers up -d`.

Container yeniden oluşturma ile kalıcılık kontrolü:

```bash
bash scripts/local.sh exec -T -e PERSISTENCE_CREATE=1 web python manage.py shell < scripts/local-persistence.py
bash scripts/local.sh down
bash scripts/local.sh up -d db redis rabbitmq web
bash scripts/local.sh exec -T web python manage.py shell < scripts/local-persistence.py
```

Bu kontrol parolasız bir geliştirme kullanıcısı, başlık ve yayımlanmış entry
oluşturur; ikinci çağrı yalnızca aynı kayıtları okuyup doğrular.
`down` volume'leri korur. `down -v` veritabanını siler; normal durdurmada kullanma.
`setup` tekrar çalıştırıldıktan sonra da okuma kontrolü yapılabilir.

### Bu oturumun doğrulama sonuçları (4–5 Ekim 2026)

| Gerçekten çalıştırılan komut / kontrol | Sonuç |
| --- | --- |
| `docker compose version`, `docker info --format '{{.ServerVersion}}'` | Compose v2.39.2, Engine 28.3.3 |
| `bash scripts/local.sh init` (iki kez) | Secret dosyaları oluşturuldu; ikinci çağrıda korundu |
| `docker compose -p sozluk -f docker/dev/compose.yml config --quiet` | Geçti; env içerikleri yazdırılmadı |
| `bash scripts/local.sh setup` (iki kez) | Python 3.14.7 / Django 5.2.5; frozen lock kurulumu, migration ve collectstatic geçti |
| `bash scripts/local.sh exec -T web python manage.py check` | 0 sorun |
| `bash scripts/local.sh exec -T web python manage.py migrate --check` | Geçti; bekleyen migration yok |
| `bash scripts/local.sh exec -T web python manage.py makemigrations --check --dry-run` | `No changes detected` |
| `docker compose -p sozluk -f docker/dev/compose.yml exec -T web python manage.py test dictionary.tests --noinput` | 41 test geçti; ayrı test veritabanı temizlendi |
| Yukarıdaki `curl` komutu | Ana sayfa `200`; yeniden kurulum sonrasında da `200` |
| Yukarıdaki kalıcılık komutları | `down/up` öncesi ve sonrası `topic=1, entry=1, author=3`; ikinci `setup` sonrası da aynı |
| `touch djdict/urls.py` ve filtrelenmiş web logları | `changed, reloading`; yeniden Django check geçti (dosya içeriği değişmedi) |
| Compose `ps` port kontrolü | Web yalnızca `127.0.0.1:8000`; DB/Redis/RabbitMQ host portu yok |
| `bash -n scripts/local.sh`, `git diff --check` | Geçti |
| `git check-ignore .local/django.env .local/postgres.env` ve dosya izin kontrolü | Ignore kuralları ve `0600` izinleri doğrulandı |
| `git diff --exit-code -- pyproject.toml uv.lock LICENSE` | Bağımlılık kuralı, lockfile ve lisans değiştirilmedi |

İlk HTTP denemesi web yeniden oluşturulurken bağlantı sıfırlanmasıyla
`000` döndü; servis hazırken tekrar edilen kontroller `200` oldu.
Docker erişimi bu agent sandbox'ında onaylı dış çalıştırma gerektirdi.
Build'de upstream Dockerfile'ın `FROM/as` büyük-küçük harf uyarısı görüldü;
build başarıyla tamamlandı.

Tarayıcıyla arayüz, admin girişi, interaktif `createsuperuser`, Celery
worker/beat ve gerçek 42 OAuth doğrulanmadı. Kalıcılık testi ORM/Django
shell üzerinden yapıldı; arayüzden başlık/entry yazıldığı iddia edilmiyor.
Ürün özellikleri, branding uyarlaması ve production deployment eklenmedi.
Uygulama http://127.0.0.1:8000/ üzerinde çalışır durumda bırakıldı.

### Commit öncesi inceleme (5 Ekim 2026)

`bash scripts/local.sh setup` yeniden çalıştırıldı; öncesinde ve sonrasında
kalıcılık betiği aynı `topic=1, entry=1, author=3` değerlerini doğruladı.
`check`, `migrate --check`, `makemigrations --check --dry-run` ve mevcut
41 Django testi tekrar geçti. Compose yapılandırması secret değerleri
çıktıya verilmeden incelendi: web loopback ile sınırlı, diğer servislerin
host portu yok, PostgreSQL volume'ü ve kod bind mount'u mevcut.
Yerel secret dosyalarının takip edilmediği, izinlerinin `0600` olduğu,
örnek secret alanlarının placeholder içerdiği ve gerçek yerel secret
değerlerinin depo dosyalarında bulunmadığı doğrulandı.
Upstream'in takip edilen `conf/dev/*.env` ve `conf/prod/*.env` dosyaları
bu yerel runtime tarafından kullanılmaz; gerçek yerel secret dosyaları
`.local` altındadır.

Çalışan container'ın sürümünü doğrulamak için:

```bash
bash scripts/local.sh exec -T web python --version
```

Sonuç `Python 3.14.7`. Arayüzde görünen `3.11` gerçek runtime değildi;
`dictionary/templates/dictionary/includes/devinfo.html` içinde sabitti.
Aynı şablondaki upstream proje sürümü `1.6.1` de eskiydi. Şablon artık
Python sürümünü runtime'dan, upstream proje sürümünü `pyproject.toml`'dan
alır. HTTP yanıtı dosyaya alınarak HTML'de `Python version: 3.14.7` ve
`django-sozluk 1.7.0` bulunduğu, eski Python yazısının bulunmadığı doğrulandı:

```bash
curl --fail --silent --show-error --output /tmp/megadodo-runtime-review.html --write-out '%{http_code}\n' http://127.0.0.1:8000/
```

HTTP sonucu `200`; tarayıcıyla görsel doğrulama yapılmadı.
Dockerfile `FROM/as` uyarısı `AS` yazımıyla düzeltildi; yeniden build geçti.
Host Python 3 gereksinimi de kurulum bölümünde düzeltildi.
Origin `https://github.com/erraii/megadodo.git`; yerel klasör
`~/code/42-sozluk` olarak korunur.

## 6. Her geliştirme işi için düzen

Bir branch'te tek, tamamlanabilir iş yap. Aynı dosyaları düzenleyen agent'ları
aynı çalışma klasöründe eşzamanlı çalıştırma. İlk aşamada bir geliştiren
agent yeterli; gerekli yerlerde değişiklikleri başka bir oturumda inceletebiliriz.

```bash
git status --short
git diff
git diff --check
git add DEGISTIRDIGIN_DOSYALAR
git diff --cached
git commit -m "feat: describe the completed change"
git push -u origin BRANCH_ADI
```

Commit öncesi dosya listesini ve diff'i gör. Çalışan ve kontrol edilmiş
değişikliği PR üzerinden inceleyip main'e al. Main'e dönerken önce çalışma
klasörün temiz olsun:

```bash
git switch main
git pull --ff-only origin main
git switch -c feat/SONRAKI_IS
```

## Resmi kaynaklar

- [Aday projenin README'si](https://github.com/realsuayip/django-sozluk)
- [Aday projenin Python bağımlılıkları](https://github.com/realsuayip/django-sozluk/blob/master/pyproject.toml)
- [Git ilk ayarlar](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
- [GitHub CLI ile giriş](https://cli.github.com/manual/gh_auth_login)
- [GitHub CLI Git kimlik doğrulaması](https://cli.github.com/manual/gh_auth_setup-git)
- [Docker Compose kurulumu](https://docs.docker.com/compose/install/)
- [Windows Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
- [Ubuntu Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
- [macOS Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Codex IDE kurulumu](https://learn.chatgpt.com/docs/codex/ide)
- [Codex hesabıyla giriş](https://learn.chatgpt.com/docs/auth)
- [WSL ve Codex](https://learn.chatgpt.com/docs/windows/wsl)
