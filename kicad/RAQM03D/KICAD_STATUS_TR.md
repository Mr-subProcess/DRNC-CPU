# KiCad Durumu — RAQM-03D

- Önceki 03C sistem-seviyesi KiCad projesi 03D olarak taşındı.
- `05_XC7A100T_PINMAP.kicad_sch` pinout eşlemesini gösteren bir anotasyon sayfasıdır.
- Sayfalar tasarım mimarisini ve pin atamalarını gösterir; gerçek FPGA sembolünün 484 pininin tamamı, footprint pad mapping, tüm elektriksel wire/net bağlantıları ve güç pinleri bağlantı kontrolü tamamlanmış değildir.
- KiCad CLI/Eeschema bu ortamda kurulu olmadığından açılış, ERC ve DRC doğrulaması çalıştırılmadı.
- Bu KiCad proje kopyası **üretim için onaylı şematik değildir**. Kullanımdan önce KiCad'de açın, resmi FPGA symbol/pin table ve footprint'i ekleyin, pin numaralarını iki kişiyle çapraz kontrol edin ve ERC çalıştırın.
