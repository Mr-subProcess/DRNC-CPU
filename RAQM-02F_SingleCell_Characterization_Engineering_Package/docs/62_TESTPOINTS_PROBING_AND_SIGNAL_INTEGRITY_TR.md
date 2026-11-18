# 62 — Test Noktaları, Prob Yüklemesi ve Sinyal Bütünlüğü

## 62.1 Giriş ölçümü

DATA_P/N ve WE_P/N için ölçüm noktaları transistor base pinlerine mümkün olduğunca yakın olmalıdır. Amaç, kablo ucundaki generator değerini değil devrenin gerçekten gördüğü diferansiyel sinyali ölçmektir. Giriş test pedlerinin ek kapasitansı ve stub etkisi route review'da dikkate alınır.

## 62.2 Çıkış ölçümü

OUT_P/N düğümleri latch'in kendisidir. Bu düğümler 50 Ω osiloskop terminasyonu ile yüklenmez. İlk testte aktif diferansiyel prob veya 1 MΩ / yüksek empedans modunda düşük kapasitanslı ölçüm kullanılır. SMA kablo bağlanıyorsa scope girişinin 50 Ω termination kapalı olmalı; kablo/prob kapasitansı ölçüm kaydına eklenmelidir.

## 62.3 Prob yüklemesi testi

Aynı state ve bias koşulunda şu konfigürasyonlar karşılaştırılır:

1. Prob yok (yalnız fixture comparator/receiver varsa onun input capacitance'ı kayıtlı).
2. Yüksek empedanslı diferansiyel prob.
3. İkinci yüksek empedanslı probe/cable yükü (gerekliyse).

Q diferansiyel marjı veya hold süresi probe bağlantısıyla belirgin değişiyorsa ölçüm read-disturb riski taşır; bu durumda çıktı arayüzü doğrudan yüklenerek kabul edilmez.

## 62.4 PCB dönüş yolu

- Diferansiyel çiftlerin altında kesintisiz referans GND düzlemi bulunur.
- Çiftin altındaki plane slot/split, uzun stub ve gereksiz via transition yasaktır.
- GND düzlemini DATA/WE dönüşü için bölme; yüksek akımlı tail dönüşünü yerleşim ve iz yönlendirmesiyle hassas input reference alanından uzak tut.
- SMA shell tabları çoklu ve düşük endüktanslı şekilde aynı GND plane'e bağlanır.
- Her decoupling kondansatörü ilgili akım döngüsünü en kısa yoldan kapatmalıdır.

## 62.5 Hız iddiaları

BCM847BS datasheet fT değeri bir transistor geçiş frekansı karakteristiğidir; latch propagation delay, setup/hold, minimum pulse width veya işlem throughput'u değildir. Hücre performansı yalnız bench ile ölçülüp koşullarıyla raporlanabilir.
