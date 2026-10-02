# 42 sözlük — yerel geliştirme

Hedef düzen: VS Code + Codex, Git ve Docker Compose. Kaynak adayımız
[realsuayip/django-sozluk](https://github.com/realsuayip/django-sozluk).
Docker ilk değerlendirmede Python, PostgreSQL ve diğer servisleri
bilgisayara ayrı ayrı kurma ihtiyacını azaltır.

## Hazırlananlar ve doğrulama sınırı

Bu paket kaynak kodunu bilgisayarında indirir ve Git/VS Code/agent düzenini
hazırlar. Uygulamayı başlatacak Compose dosyası içermez. Docker ve tam kaynak
indirme bu paketin hazırlandığı ortamda kullanılamadığı için uygulama burada
çalıştırılmadı. Sonraki adım docs/FIRST_TASK.md ile gerçek kaynak üzerinde
yerel çalışma düzenini tamamlamaktır.

1 Ekim 2026'da GitHub'daki pyproject.toml üzerinde Python `==3.13.*`,
Django `~=5.2` ve uv.lock görüldü. İlk kurulumda indirilen sürüm değişmiş
olabilir: kendi checkout'undaki dosyalar esas alınır. README üretim için
`make` anlatıyor, depo kökünde ise `justfile` listeleniyor. Dolayısıyla
internetten kopyalanmış production komutları yerel kurulum tarifi sayılmaz.

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
sudo apt install git unzip ripgrep gh
mkdir -p ~/code
```

Projeyi `~/code` altında tut. `/mnt/c` altında çalışmak yerine Linux
dosya sistemini kullanmak bu düzen için daha uygundur. Windows'tan
`\\wsl$\Ubuntu\home\LINUX_KULLANICIN\code` üzerinden erişebilirsin.

### Kişisel Linux bilgisayarı

Git, unzip ve ripgrep kur. Ubuntu/Debian için:

```bash
sudo apt update
sudo apt install git unzip ripgrep gh
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
Install 'code' command in PATH** seç. Paket için host Python/Node kurmak
gerekmez; uygulama bağımlılıkları kaynak incelendikten sonra container'da kurulacak.

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

GitHub'da **42-sozluk** adında yeni, boş bir repository oluştur. İlk
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
git remote add origin https://github.com/GITHUB_KULLANICIN/42-sozluk.git
git status --short
git diff --check
git add AGENTS.md .editorconfig .gitattributes .gitignore .vscode scripts docs
git diff --cached --stat
git commit -m "chore: prepare local development workflow"
git push -u origin main
```

`GITHUB_KULLANICIN` yerine kendi hesabını kullan. `setup.sh --origin ...`
seçeneğini kullandıysan `git remote add origin` adımını atla. Buradaki push
ilk kontrol noktasını saklar; proje henüz çalışır uygulama hâline gelmez.

| İsim | Amaç |
| --- | --- |
| `origin` | Senin 42-sozluk depon; kendi commit'lerin buraya gider |
| `upstream` | Orijinal django-sozluk kaynağı; başlangıcı ve ilerideki güncellemeleri takip ederiz |
| `main` | Gözden geçirilmiş, çalışan sürümler |
| `chore/local-runtime` | İlk uygulama kurulum işi |
| `feat/42-login` | İleride gerçek 42 girişi için ayrı iş |

## 5. Uygulamayı yerelde çalıştıracak ilk görev

```bash
git switch -c chore/local-runtime
```

docs/FIRST_TASK.md içindeki görevi Codex'e gönder. Agent gerçek kaynak,
settings ve servisleri inceleyerek local Compose düzenini tamamlayacak.
İlk kurulumda aşağıdaki bölüm gerçek komutlarla doldurulmalı:

| İş | Durum |
| --- | --- |
| Kaynak/Git kurulumu | `setup.sh` |
| Temel araç kontrolü | `bash scripts/doctor.sh` |
| Container build ve ilk veri kurulumu | Kaynak üzerinde henüz doğrulanmadı |
| Yerel başlatma/durdurma | Kaynak üzerinde henüz doğrulanmadı |
| Migration, Django check, testler | Kaynak üzerinde henüz doğrulanmadı |
| Admin hesabı ve anasayfa kontrolü | Kaynak üzerinde henüz doğrulanmadı |

Uygulama açılmadan ürün uyarlamasına başlamayacağız. İlk amaç aday
projeyi değerlendirmek: başlık aç, entry yaz, yeniden başlat, entry'nin
kaldığını kontrol et. Gerçek 42 OAuth uygulama kaydını giriş işine gelince yapacağız.

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
