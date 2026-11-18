# 63 — Tek Hücre PCB Yerleşim ve Stackup Kuralları

## 63.1 Kart organizasyonu

Tek hücre kartı dört fonksiyonel bölgeye ayrılır:

1. **Giriş bölgesi:** DATA ve WE diferansiyel SMA girişleri, 100 Ω diferansiyel terminasyonlar ve base VCM bağlantıları.
2. **Hücre bölgesi:** U_DATA, U_FB, U_SEL, Q_TAIL, R_LOAD ve feedback dirençleri.
3. **Bias/ölçüm bölgesi:** harici bias header, tail sense, Kelvin pedleri ve transistor emitter/feedback ölçüm pedleri.
4. **Güç bölgesi:** VDD girişi, bulk/decoupling ve opsiyonel koruma footprint'leri.

SMA konektörleri ve küçük SOT363 bileşenleri için kesin koordinatlar kavramsal floorplan'dan türetilmez; native CAD ve üretici mechanical drawing ile belirlenir.

## 63.2 Aday katman yığını

| Katman | Fonksiyon |
|---|---|
| L1 | CML kısa sinyal yolları, giriş diferansiyel çiftleri ve hücre bağlantıları |
| L2 | Kesintisiz GND referans düzlemi |
| L3 | VDD_CML ve bias dağıtımı; dönüş akımını kesmeyecek şekilde |
| L4 | Düşük hızlı bias/monitor ve yardımcı bağlantılar |

Bu aday 4 katmanlı yığındır; gerçek dielektrik, bakır kalınlığı ve impedance stackup üreticiden alınmadan trace width/spacing verilemez.

## 63.3 Yerleşim kuralları

- U_DATA/U_FB/U_SEL ve ilgili load/feedback elemanları kısa bağlantılarla gruplanır.
- P/N eşleri aynı katmanda, benzer geometri ve yakın uzunlukta tutulur.
- 100 Ω termination gerçek stackup ve kaynak empedansına göre doğrulanır; nominal direnç değeri tek başına controlled impedance sağlamaz.
- VDD decoupling kondansatörü collector-load besleme yoluna yakın konur.
- Tail sense resistor ayrı Kelvin sense izlerine sahip olur; bu izler yük akımını taşımaz.
- Feedback dirençleri simetrik yerleştirilir; P/N oran farkı ve sıcaklık gradyanı minimize edilir.
- SOT363 pin-1 yönü ve land pattern datasheet/mechanical drawing ile overlay kontrolünden geçer.
- SMA edge-launch footprint, kart kalınlığı, edge setback ve ground tab geometrisi seçilen üretici CAD'i ile eşleştirilir.

## 63.4 Grounding

Hızlı diferansiyel sinyal kartında GND plane'i bölmek yerine tek ve kesintisiz referans kullanılır. Hassas base/feedback düğümleri, tail dönüşü ve güç konektörü dönüşü fiziksel yerleşimle ayrıştırılır. Plane split ile “analog/digital ground” ayrımı oluşturulmaz.

## 63.5 Release öncesi gerekli CAD kontrolleri

1. Schematic-to-PCB netlist parity.
2. ERC ve DRC, sıfır unapproved error.
3. SOT363/ SOT23 land pattern ve pin-1 overlay.
4. SMA edge-launch mechanical/stackup fit.
5. Differential impedance calculator/field solver ve fab coupon planı.
6. Gerber X2, NC Drill, IPC-356 ve assembly outputs cross-check.
7. Independent reviewer sign-off.

02F içinde native KiCad dosyası veya bu kontrollerin PASS sonucu bulunmaz.
