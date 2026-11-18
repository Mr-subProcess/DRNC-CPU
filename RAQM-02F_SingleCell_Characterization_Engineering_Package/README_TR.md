# RAQM-02F — Tek Hücre Karakterizasyon ve Donanım Mühendisliği Paketi

**Sürüm:** 02F  
**Tarih:** 17 Kasım 2026  
**Durum:** ENGINEERING CANDIDATE — FABRICATION HOLD  
**Önceki temel:** RAQM-02E Simulation & Qualification Package

## 1. Bu sürüm neyi değiştiriyor?

02F, 02E'deki doğrulama planını gerçek donanım karakterizasyonuna daha yakın bir iş akışına taşır. Kritik mimari kararı şudur: ilk fiziksel test makalesi **tek bitlik, bağımsız bir CML latch karakterizasyon kuponu** olacaktır. İki bitli B0/B1 çift kartı şimdilik ana test makalesi değildir. Böylece hücrenin analog çalışma noktası, yazma/tutma davranışı, kuyruk akımı, bias penceresi ve metastabilite bölgesi birbirinden ayrılarak ölçülebilir.

02F, 02D transistor çekirdeğini doğrulanmış kabul etmez. Çekirdek topolojisi 02D adayı olarak korunur; 02F esas olarak ölçülebilirlik, laboratuvar bağlantısı, güç/bias kontrolü, arıza güvenliği ve test sırasını tanımlar.

## 2. 02F'deki yeni mühendislik parçaları

- Tek hücreli karakterizasyon kartı için yeni bağlantı ve test noktası sözleşmesi.
- Harici, bağımsız ve akım sınırlı bias kaynaklarıyla karakterizasyon yaklaşımı.
- Kuyruk akımını düşük yük etkisiyle ölçmek için 10 Ω sense direnci adayı ve Kelvin test pedleri.
- Güç girişinde koruma elemanları için değerleri dondurulmamış opsiyonel footprint stratejisi.
- Ölçüm probu yüklemesi, diferansiyel giriş ve dönüş akımı kuralları.
- Güvenli açılış/kapanış sırası ve hata durumunda inhibit davranışı.
- Tek hücre için ilk makale test matrisi, kayıt şablonları ve release gate'leri.
- Önceki sürümün ZIP arşivi `baseline/` altında değişmeden saklanır.

## 3. Bilinçli olarak yapılmayanlar

- Özel işlemci, özel transistor, compiler, firmware veya programlama dili kodu yoktur.
- Transistor seviyesinde SPICE modeli veya simülasyon sonucu eklenmemiştir.
- Native KiCad şematik/PCB, ERC/DRC, Gerber, drill veya pick-and-place üretilmemiştir.
- On-board Muller C-element, arbiter, ACK generator veya PAIR_VALID devresi tasarlanmamıştır.
- İki bit arasında fiziksel cross-coupling/recurrent link eklenmemiştir.
- Üretim hızı, propagation delay, metastability MTBF veya qudit performansı iddiası yoktur.

## 4. Kritik elektriksel çerçeve

02D başlangıç adayları olan `VDD_CML=5.0 V`, `VBIAS_TAIL≈1.0 V`, `R_TAIL=470 Ω`, `R_LOAD=470 Ω`, `R_FB=22 kΩ`, `VCM_DATA≈4.16 V`, `VCM_WE≈3.45 V` ve `VREF_FB≈3.50 V` doğrulanmış çalışma değerleri değildir. 4.5–5.25 V besleme aralığı, 0.4–1.0 mA kuyruk akımı ve ±80–150 mV diferansiyel giriş seviyeleri yalnızca kontrollü karakterizasyon başlangıç aralıklarıdır.

02F'deki 10 Ω kuyruk sense elemanı da **aday**dır. 470 Ω tail set direncine seri eklendiğinde eşdeğer seri direnç yaklaşık 480 Ω olur ve önceki devreye göre akımı az da olsa değiştirir. Bias yeniden ayarlanmalı ve gerçek akım ölçülmelidir.

## 5. Release hükmü

**DURUM: HOLD — ÜRETİME GÖNDERİLMEZ**

02F bir mühendislik/karakterizasyon paketidir; imalat paketi değildir. Kesin komponent OPN/footprint, üretici SPICE modeli veya doğrulanmış alternatif, DC/transient/PVT sonuçları, native CAD ERC/DRC, fab stackup/impedans, Gerber incelemesi ve ilk makale bench testleri tamamlanmadan kart üreticisine gönderilmemelidir.

## 6. Klasörler

- `baseline/` — RAQM-02E arşivi.
- `docs/` — 02F mimari ve elektriksel tasarım notları.
- `hardware/` — bağlantı, test noktası, BOM/net farkı ve SVG diyagramları.
- `lab/` — bench bring-up, güç sırası, ölçüm planı ve kayıt şablonları.
- `validation/` — risk, test, kabul ve release gate tabloları.
- `references/` — kaynak ve model provenans notları.
