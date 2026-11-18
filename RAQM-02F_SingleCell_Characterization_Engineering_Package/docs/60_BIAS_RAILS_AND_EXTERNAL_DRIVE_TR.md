# 60 — Bias Rayları ve Harici Sürüş Sözleşmesi

## 60.1 Neden harici bias?

İlk test makalesinde bias üreticisini latch çekirdeğinin içine koymak ölçüm belirsizliğini artırır. 02F'de `VBIAS_TAIL`, `VCM_DATA`, `VCM_WE` ve `VREF_FB` harici, ayrı ayarlanabilir ve ölçülebilir düşük gürültülü kaynaklardan gelir. Bu yöntem ürün çözümü değildir; karakterizasyonu izole etmek için laboratuvar mimarisidir.

## 60.2 Kaynak rayları

| Hat | 02D başlangıç adayı | 02F yaklaşımı | Ölçüm noktası |
|---|---:|---|---|
| VDD_CML | 5.00 V | Akım sınırlı harici besleme | TP_VDD |
| VBIAS_TAIL | yaklaşık 1.00 V | Bağımsız, düşük gürültülü bias | TP_VBIAS |
| VCM_DATA | yaklaşık 4.16 V | DATA pair ortak-mod ayarı | TP_VCM_DATA + base pinleri |
| VCM_WE | yaklaşık 3.45 V | WRITE/HOLD pair ortak-mod ayarı | TP_VCM_WE + base pinleri |
| VREF_FB | yaklaşık 3.50 V | Feedback divider referansı | TP_VREF_FB + FB_P/N |

Bunlar ölçülmüş değerler değildir. Gerekli voltaj aralıkları, tolerans, kaynak akımı ve gürültü limitleri simülasyon/bench ile belirlenecektir.

## 60.3 Differential DATA/WE

- DATA_P/N ve WE_P/N DC-coupled olmalıdır; seri AC-coupling kapasitörü kullanılmaz.
- Giriş çiftleri için 100 Ω P-N diferansiyel sonlandırma 02D başlangıç adayıdır. Harici sürücünün iki kol çıkış empedansı ve gerçek base amplitüdü ile birlikte doğrulanmalıdır.
- Sürücü diferansiyel amplitüdü yalnız generator ekranındaki değerle kabul edilmez; base test noktalarında ölçülür.
- İlk incelenecek diferansiyel aralık ±80…150 mV adayıdır; garanti edilmiş switching threshold değildir.
- 3.3 V MCU GPIO doğrudan bağlanmaz. Host arayüzü daha sonra doğru DC common-mode ve diferansiyel genlik sağlayan bir driver aşaması gerektirir.

## 60.4 Kaynak kararlılığı ve izolasyon

Her rail kaynağı ayrı current-limit/monitor ile beslenebilir olmalı. Bias hatlarının decoupling kondansatörleri kaynak kararlılık şartlarıyla uyumlu seçilmeli; bazı op-amp veya aktif referanslar kapasitif yükte salınıma girebilir. 02F bu nedenle belirli op-amp veya regülatör dayatmaz.

## 60.5 Bias sweep yöntemi

Tek parametreyi değiştirirken diğer kaynaklar sabit tutulur. Önce DC çalışma noktası ve transistor bölgeleri doğrulanır; sonra DATA/WE transient testleri yapılır. VBIAS, VCM ve VREF değerlerinin aynı anda rastgele değiştirilmesi sonuçların izlenebilirliğini bozar.
