# 65 — İlk Makale Test ve Kabul Prosedürü

## 65.1 Ön koşullar

- PCB assembly visual inspection tamamlandı.
- Aktif parça MPN, paket, pin-1 ve footprint doğrulandı.
- Güç girişinde short/open ölçümü yapıldı.
- Harici kaynakların current-limit ve compliance değerleri kaydedildi.
- DATA/WE kaynaklarının DC common-mode ve diferansiyel çıkışları yük altında ölçüldü.
- Prob modeli, giriş empedansı/kapasitansı ve scope termination kaydedildi.

## 65.2 Aşamalı test sırası

| Aşama | İşlem | Kayıt | Başarısızlıkta |
|---|---|---|---|
| T0 | Görsel, continuity, polarity kontrolü | foto, DMM, serial | Enerji verme |
| T1 | Yalnız GND ve VDD; bias/incoming signals kapalı | rail, current | Kapat, short/assembly incele |
| T2 | Bias raylarını sırayla uygula; base seviyelerini ölç | tüm rail'ler, base VCM | Capture inhibit, bias kaynağını kapat |
| T3 | WRITE olmadan static/HOLD davranışını incele | OUT diff/common-mode | State geçerli ilan etme |
| T4 | DATA polarity A/B sweep | base differential, OUT | Guard-band belirle |
| T5 | WE steering sweep | WE diff, I_TAIL, OUT | Indeterminate aralığı kaydet |
| T6 | WRITE/HOLD pulse-width sweep | pulse width, settling, overshoot | Min pulse iddiası üretme |
| T7 | Retention sweep | 1 µs…10 s ölçüm zamanları | State retention FAIL/INCONCLUSIVE |
| T8 | Power-up/down ve brownout | startup state, current, recovery | Reset/initialization akışını güncelle |
| T9 | PVT/thermal sweep | rail, bias, temperature, margin | Limitleri daralt veya tasarımı değiştir |
| T10 | Probe loading / repeatability | Q margin, probe setup, repeats | Measurement fixture redesign |

## 65.3 İlk kabul ilkeleri

1. Transistor DC çalışma noktaları ölçülmeli ve üretici çalışma sınırlarına göre review edilmelidir.
2. Aktif transistorların beklenmeyen saturation veya base-collector forward-bias durumları açıklanmalıdır.
3. Tail akımı sense direnci üzerinden ölçülmeli; tüm bias koşullarıyla loglanmalıdır.
4. HOLD süresince Q diferansiyel polaritesi, belirlenen retention aralıklarında state flip olmadan korunmalıdır.
5. WRITE/HOLD ve DATA/WE belirsiz bölgeleri ölçülmeli; fikstür bu pencerelerde ACK üretmemelidir.
6. Probe bağlantısı state'i değiştirmemelidir; aksi hâlde sonuç geçerli ölçüm sayılmaz.
7. Startup sonrası state undefined kabul edilmeli; bilinen DATA yazma işlemi tamamlanmadan valid sayılmamalıdır.

## 65.4 Hedeflerin sayısallaştırılması

`V_Q_MIN`, `T_QUAL`, `V_WE_GUARD`, `V_DATA_GUARD`, minimum WRITE pulse, maximum settling time ve retention limitleri 02F'de TBD'dir. Bu değerler ölçüm gürültüsü, fixture comparator offset/noise, sıcaklık ve supply köşeleri incelendikten sonra dondurulur. Ölçülmemiş hedeflere PASS verilmez.
