# 59 — Güç Girişi, Koruma ve Güvenli Enerjilendirme

## 59.1 Güç alanı

02F test kartı için +5 V nominal CML rail adayı korunur. 4.5–5.25 V aralığı ilk karakterizasyon süpürmesidir; kartın kesin kabul aralığı veya tüm elemanların çalışma garantisi değildir. İlk açılışta akım sınırlı laboratuvar kaynağı kullanılır. 02D'de belirtilen 10 mA başlangıç akım limiti yalnız bring-up prosedürü için geçici değerdir; parça absolute-maximum veya ürün akım spesifikasyonu değildir.

## 59.2 Koruma topolojisi — henüz değer dondurulmadı

Kart girişinde aşağıdaki fonksiyonlar için yer/footprint bırakılması önerilir:

- `F1`: seri aşırı-akım koruma elemanı (sigorta/PTC/uygun eFuse çözümü).
- `Q_REV` veya `D_REV`: ters polarite koruması (MOSFET ideal-diode yaklaşımı veya Schottky yaklaşımı arasından headroom bütçesiyle seçim).
- `D_TVS`: besleme transient bastırma elemanı.
- `C_BULK`: giriş bulk bypass.
- `C_DEC`: hücre yakınında yüksek frekans bypass.

02F bunlara MPN veya kesin değer atamaz. TVS stand-off gerilimi sürekli maksimum rail'in üzerinde, clamp seviyesi ise devredeki bütün elemanların güvenli sınırlarının altında olmalıdır. Koruma elemanının sızıntısı, kapasitansı, seri direnci ve gerilim düşümü analog headroom'u etkileyebilir. Bu veriler olmadan rastgele TVS, Schottky veya MOSFET değeri seçilmez.

## 59.3 İlk laboratuvar konfigürasyonu

- Harici, akım sınırlı ve ters polarite/OVP korumalı bench supply kullan.
- Kartta koruma elemanları takılı değilse kartı çıplak güç kaynağına korumasız bağlama.
- VDD kapalıyken DATA/WE sürücülerini aktif etme; transistor base'lerine güç dışı akım enjeksiyonu olabilir.
- Güç kaynağı current-limit'e girerse rail'i yükselterek zorlamaya çalışma; enerjiyi kes, arıza ara.
- İlk açılışta DATA/WE idle, bias kaynakları sıfır/disable konumunda olmalı.

## 59.4 Sıralama

GND referansı → VDD_CML → VREF_FB → VCM_DATA → VCM_WE → VBIAS_TAIL → DATA/WE sürücüleri. Kapatma ters sıradadır: sürücüler idle/disable → VBIAS_TAIL → diğer bias'lar → VDD_CML → GND.

Bu sıra ilk bring-up için temkinli prosedürdür; kesin sequencing limitleri transistor modeli ve bench ölçümünden sonra gözden geçirilmelidir.

## 59.5 Brownout ve fault

VDD veya bias raylarından biri limit dışına çıktığında test fikstürü `CAPTURE_INHIBIT=1` yapar. Çıkışın önceki değerini geçerli kabul etmez. Güç kesilip geri geldiğinde latch state'i **undefined** kabul edilir; bilinen bir DATA değeriyle açık WRITE işlemi yapılmadan Q geçerli sayılmaz.
