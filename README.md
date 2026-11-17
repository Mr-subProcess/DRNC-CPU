# RAQM-02G — SPICE ve KiCad tek hücre paketi + RAQM-03 mimarisi

Bu paket 02F baseline'ını korur; tek-hücre analog çekirdeği için SPICE-uyumlu netlistler ve KiCad proje/şematiği ekler. Ayrıca bir sonraki aşama RAQM-03 iki-bit sembol çifti mimarisi tanımlanmıştır.

## İçerik
- `baseline_RAQM-02F_...zip`: önceki 02F tam arşivi.
- `spice/`: DC operating point ve WRITE/HOLD transient SPICE deck'leri, model dosyası, run scripti ve koşum sınırları.
- `kicad/RAQM02G/`: `.kicad_sch`, `.kicad_pro`, özel sembol kitaplığı, sembol tablosu ve açıklama.
- `RAQM02G_NETLIST.csv`: komponent pin/net tablosu.
- `RAQM-03_TwoCell_Architecture/`: dört durum ve asynchronous PAIR_VALID mimarisi.
- `docs/`: elektriksel inceleme ve release gate matrisi.

## Dürüst doğrulama durumu
Bu ortamda `ngspice`, `eeschema` ve `kicad-cli` kurulu değildi; Debian depo erişimi de DNS hatası verdi. Dolayısıyla gerçek ngspice simülasyonu, KiCad open/save, ERC, DRC, PCB veya Gerber üretimi yapılmadı. Sadece SPICE deck'leri üretildi, KiCad S-expression dosyalarının parantez dengesi ve pin/net listeleri kontrol edildi.

Model Diodes Inc. BC847BS modelidir; Nexperia BCM847BS üretici modeli değildir. Bu nedenle sonuçlar Nexperia parça için kanıt kabul edilemez.

## Üretim durumu
**NOT FOR FABRICATION.** Footprint alanları boş bırakıldı. PCB ve Gerber yoktur. Önce model korelasyonu, ngspice, KiCad ERC/DRC ve bench testleri tamamlanmalıdır.
