# Codex'e ilk görev

Aşağıdaki metni proje klasörünü açtıktan sonra Codex'e gönder:

> AGENTS.md ve docs/local-development.md dosyalarını oku. Bu Django
> sözlük projesi için yerel geliştirme ortamını tamamla. Önce pyproject.toml,
> uv.lock, justfile, docker/, conf/ ve Django settings yapısını incele.
> README'deki production komutlarını doğrudan kullanma.
>
> Var olan geliştirme Docker/Compose düzeni varsa onu kullan ve gereken
> küçük düzeltmeleri yap. Yoksa kaynakla uyumlu bir local Compose düzeni
> ekle. Python sürümünü upstream kuralından, servisleri gerçek settings ve
> Docker dosyalarından belirle; sürüm veya dosya yolu tahmin etme.
> Veritabanı kalıcı volume kullansın; uygulama kodu değişince yenilensin;
> uygulama sadece 127.0.0.1 üzerinden erişilsin. Gerçek secret dosyaları
> ignore edilen .local altında olsun; örnek dosyalar placeholder içersin.
>
> Kurulum, başlatma, durdurma, migration, createsuperuser, shell ve check
> için belgelenmiş komutlar oluştur. Setup mevcut veriyi silmesin ve
> tekrar çalıştırılabilsin. Basit bir Django check ve migration kontrolü
> çalıştır; anasayfanın HTTP yanıtını ve varsa gerekli ilk veri kurulumunu
> kontrol et. Yeniden başlatınca veritabanı verisinin kaldığını doğrula.
>
> Bu görevde ürün özellikleri veya 42 OAuth ekleme. Mevcut local admin ile
> aday uygulamayı değerlendireceğiz. Bittiğinde docs/local-development.md
> dosyasındaki uygulama komutlarını gerçek sonuçlarla tamamla. Çalıştıramadığın
> adımları açıkça belirt. Değişiklikleri gözden geçirebilmem için özetle.

Başarı ölçütü: Yeni bir geliştirici dokümandaki komutlarla uygulamayı
yerelde açabilir; durdurup açınca başlık/entry kaybolmaz. Gerçek 42 hesabı
bağlantısı bu aşamanın başarı ölçütü değildir.
