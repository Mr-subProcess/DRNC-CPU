# 68 — Elektriksel Tasarım İncelemesi: Açık Konular

Bu doküman, tek hücre test kartına geçerken çözülmesi gereken fiziksel/elektriksel konuları görünür kılar.

1. **Feedback divider headroom:** OUT_P/N, VREF_FB ve FB_P/N gerilimlerinin tüm state/bias/PVT koşullarında U_FB transistörlerinin C-B ve C-E marjını koruduğu kanıtlanmalı.
2. **Tail sink bias:** Q_TAIL'in aktif bölgede kalması, VBIAS kaynak direnci ve base current etkisiyle ölçülmeli. 470 Ω nominal direnç ideal current source değildir.
3. **Selector overlap/dead zone:** WE_P−WE_N geçişinde U_SEL iki kol akım paylaşımı ve her kolun akımı ölçülmeli.
4. **DATA threshold:** U_DATA gerçek diferansiyel switching penceresi base pininde ölçülmeli. Giriş common-mode değişiminin etkisi ayrıca raporlanmalı.
5. **Common output loading:** U_DATA ve U_FB collector'ları aynı OUT düğümlerini sürer; iki transistor çifti arasındaki current-sharing, output swing ve feedback polarity doğrulanmalı.
6. **Startup symmetry:** Güç açılışında latch'in hangi tarafa çöktüğü ölçülmeli; deterministic state varsayılmamalı.
7. **Probe capacitance:** OUT ve FB düğümlerine bağlanan her probun kapasitansı latch dinamiğini değiştirebilir. FB base'lerine doğrudan prob bağlamak için özellikle düşük kapasitans/aktif prob gerekir.
8. **Termination/source interaction:** 100 Ω differential termination, iki 50 Ω source veya farklı driver topology ile birlikte tekrar hesaplanmalı; source current limits gözlenmeli.
9. **Sense resistor burden:** 10 Ω shunt akım noktasını değiştirir; sense takılı/takısız tasarım karşılaştırması model veya bench ile yapılmalı.
10. **Power protection headroom:** Reverse-protection drop ve transient clamp değerleri CML headroom'una göre seçilmeli.
11. **Thermal matching:** Aynı differential pair içindeki iki BJT'nin yakın termal ortamı ve bakır simetrisi korunmalı.
12. **Part model provenance:** Başka üreticinin BC847BS modeli, Nexperia BCM847BS eşlenmiş çift modeli gibi kullanılmamalı.

Her madde `validation/RAQM02F_GATE_MATRIX.csv` içinde bir kanıt kapısına bağlıdır. Bir maddenin açıklanması değil, ölçüm/model kanıtı gerekir.
