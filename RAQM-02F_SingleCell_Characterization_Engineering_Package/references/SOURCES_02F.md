# RAQM-02F Kaynak ve Provenans Kaydı

## Miras alınan resmi üretici kaynakları

- Nexperia BCM847BS ürün sayfası: https://www.nexperia.com/product/BCM847BS
- Nexperia BCM847BS resmi datasheet: https://assets.nexperia.com/documents/data-sheet/BCM847BS.pdf
- Nexperia BC847 ürün sayfası: https://www.nexperia.com/product/BC847

02E kaynak notları `baseline/RAQM-02E_Simulation_Qualification_Package.zip` içinde korunmuştur.

## Kullanım sınırı

Kaynaklar parça kimliği, paket ve datasheet sınırlarını incelemek içindir. 02F paketine resmi Nexperia BCM847BS SPICE modeli eklenmedi. Başka üreticinin generic BC847BS modeli Nexperia eşlenmiş çift modeli yerine kullanılmaz. Simülasyon sonucu, test datası veya ölçüm grafiği uydurulmamıştır.

## Yeni parça seçimleri

02F'de yeni aktif parça, reverse-protection MOSFET, TVS veya eFuse için exact MPN seçilmemiştir. Bu seçimler rail headroom, kaynak maksimumu, transient standardı, tedarik ve footprint review sonrasında yapılacaktır.
