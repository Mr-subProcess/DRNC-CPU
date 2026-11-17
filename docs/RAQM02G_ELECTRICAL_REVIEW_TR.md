# RAQM-02G Elektriksel İnceleme ve Kararlar

## Düzeltilmiş/teyit edilmiş kritik bağlantı
Nexperia BCM847BS pin sırası: 1=E1, 2=B1, 3=C2, 4=E2, 5=B2, 6=C1. U2 geri besleme bağlantısı bu pin sırasıyla yorumlandığında cross-coupled'dir: TR1'in collector'ı OUT_P, base'i FB_N; TR2'nin collector'ı OUT_N, base'i FB_P. FB_N, OUT_N bölücüsünden; FB_P, OUT_P bölücüsünden gelir. Bu eşlemenin şematik ve SPICE pin map'inde açıkça gösterilmesi zorunlu.

## Açık elektriksel konular
1. Nexperia BCM847BS için üretici modeli doğrulanmadı; Diodes modelini Nexperia modeli gibi kabul etme.
2. Q_TAIL BC847B olarak listelenmiş; generic dual BC847BS proxy modeli sadece geçici simülasyon varsayımıdır.
3. U_DATA/U_FB/U_SEL çalışma bölgeleri, VCE headroom, tail akımı ve switching threshold simülasyon/bench ile ölçülmeli.
4. WE_P/N ve DATA_P/N kaynak çıkış empedansı ile 100 Ω terminasyon etkileşimi gerçek sürücü seçimiyle tekrar hesaplanmalı.
5. R_SENSE 10 Ω eklenmesi tail biasını değiştirir; 0.75 mA hedefi otomatik olarak korunmaz.
6. Korumalı güç girişinin gerçek komponentleri ve headroom düşümü henüz seçilmedi; bu sayfada sadece çekirdek analog devre bulunur.
7. Footprint alanları boş; SOT363-3, BC847B, resistor/cap land pattern, konektör ve kart stack-up doğrulanmalı.

## Bu pakette yapılan kontroller
- SPICE wrapper'ın 6-pin sırası Nexperia datasheet pin map ile eşleştirildi.
- SPICE netlist ve KiCad pin/net tablosu aynı topolojiye göre üretildi.
- KiCad S-expression parantez dengesi kontrol edildi.
- KiCad ERC/DRC ve ngspice koşusu yapılmadı (araçlar mevcut değil).
