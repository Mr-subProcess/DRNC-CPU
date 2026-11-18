# 58 — Tek Hücre Sinyal Yolu ve Durum Semantiği

## 58.1 Elektriksel sinyal akışı

1. Harici DC-coupled diferansiyel sürücü DATA_P/DATA_N çiftini sürer.
2. DATA çiftinin diferansiyel işareti, U_DATA transistör çiftinin akım paylaşımını belirler.
3. Harici WRITE/HOLD sürücüsü WE_P/WE_N çiftini sürer.
4. U_SEL tail akımını DATA emitter kolu veya feedback emitter koluna yönlendirmeyi hedefler.
5. HOLD tarafında U_FB geri besleme çifti OUT_P/OUT_N dengesini korumayı hedefler.
6. OUT_P/OUT_N yalnız yüksek empedanslı ölçüm girişine gider. ACK/VALID üretimi test fikstürünün görevidir.

Bu akış hedeflenen fonksiyonel açıklamadır; transistor seviyesinde doğru çalıştığı henüz kanıtlanmış değildir.

## 58.2 State geçerliliği

Bir Q polaritesi ancak şu koşullar birlikte sağlandığında test fikstürü tarafından geçerli sayılabilir:

- `|OUT_P - OUT_N|` ölçülen karar marjından büyük.
- Çıkış common-mode değeri tanımlanan güvenli aralıkta.
- Bu iki koşul kesintisiz `T_QUAL` süresince korunmuş.
- Besleme ve bütün bias rayları geçerli pencerede.
- DATA/WE girişleri guard-band dışında ve transaction boyunca sabit.
- Timeout, rail fault veya reset inhibit yok.

`V_Q_MIN`, `T_QUAL`, common-mode penceresi ve WE guard-band henüz sayısal olarak dondurulmamıştır.

## 58.3 00/01/10/11 gösterimi

02F fiziksel olarak yalnız bir bit hücresini karakterize eder. Bu hücre `0` veya `1` durum adayı üretir. İki bitli `00`, `01`, `10`, `11` sembollerini göstermek için iki ayrı hücre ve aynı transaction'a ait iki geçerli yakalama gerekir. 02F tek başına 2-bit symbol-pair veya PAIR_VALID gerçekleştirmez.

## 58.4 Epoch ve feedback sınırı

Epoch bir mantıksal işlem/transaction etiketi olarak kalır; küresel saat değildir. Recurrent ağın ilerideki sürümlerinde aynı epoch içindeki kombinasyonel grafik çevrimsiz olmalı; geçmişe dönüş bağlantısı en az bir committed-state sınırı/epoch gecikmesi içermelidir. 02F bu ağın tamamını değil, yalnız state hücresinin tutulma davranışını test eder.

## 58.5 Kuantum iddiası sınırı

Buradaki transistor latch klasik analog/dijital elektronik sistemidir. “Qudit” sözcüğü yalnız gelecekteki çok seviyeli sembol/işlem soyutlaması bağlamında kullanılabilir; fiziksel kuantum durumu, süperpozisyon veya kuantum avantajı iddia edilmez.
