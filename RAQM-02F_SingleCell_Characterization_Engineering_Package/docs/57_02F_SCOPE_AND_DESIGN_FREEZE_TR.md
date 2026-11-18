# 57 — 02F Kapsamı ve Tasarım Dondurma Kararları

## 57.1 Tasarım amacı

RAQM'nin tekrarlayan/asenkron qudit-mesh hedefinden önce, tek bir klasik diferansiyel latch hücresinin fiziksel davranışı güvenilir biçimde ölçülmelidir. 02F'nin ana makalesi bu nedenle tek hücredir. Bu, mimari hedefin terk edilmesi değil; daha büyük topolojinin dayandığı en küçük fiziksel birimin doğrulanmasıdır.

## 57.2 02F hücre sınırı

Hücre çekirdeği 02D adayındaki dört bloktan oluşur:

- `U_DATA`: harici diferansiyel DATA giriş çifti.
- `U_FB`: OUT düğümlerinden direnç bölücüyle beslenen rejeneratif geri besleme çifti.
- `U_SEL`: WE_P/WE_N farkıyla DATA ve feedback emitter kolları arasında kuyruk akımını yönlendirir.
- `Q_TAIL`: ortak tail akımını belirler; akım doğrudan ideal değildir ve bias, VBE, sıcaklık, beta ve seri dirençlere bağlıdır.

02F bu çekirdeği ölçülebilir kılmak için test pedleri/rail erişimi ekler. U_DATA/U_FB/U_SEL transistor bağlantılarını yeni bir elektriksel mimari olarak yeniden tasarladığını iddia etmez.

## 57.3 Dondurulan kararlar

| ID | Karar | Neden | Statü |
|---|---|---|---|
| F-01 | İlk fiziksel makale tek bit hücresidir | Önce hücre kararlılığı ve analog marjları ölçülmeli | Adopted for 02F |
| F-02 | Bias rayları ilk testte harici kaynaktan gelir | İç regülatör gürültüsü/kararlılığıyla hücre karakterizasyonunu karıştırmamak | Adopted for test |
| F-03 | Q çıkışları yüksek empedanslı ölçülür | Read-disturb ve 50 Ω yük etkisini önlemek | Mandatory |
| F-04 | PAIR_VALID ve ACK arbiter haricidir | C-element/arbiter doğrulanmadı | Mandatory |
| F-05 | Tek hücre kartı 02D'nin 2 hücreli pinout'u ile uyumlu değildir | Tek-hücre bağlantı haritası farklıdır | Mandatory notice |
| F-06 | 10 Ω tail sense elemanı adaydır | I_TAIL ölçümüne doğrudan erişim | Candidate; bench/model gate |
| F-07 | Global clock eklenmez | Asenkron mimari hedefi korunur | Adopted |
| F-08 | Firmware/compiler yoktur | Donanım semantiği dondurulmadan yazılım aşamasına geçilmez | Adopted |

## 57.4 Açık kalan kararlar

1. BCM847BS exact ordering code ve üretici lotu.
2. SOT363 land pattern, pin-1 yönü ve montaj toleransı.
3. Üretici SPICE modeli veya doğrulanmış model alternatifi.
4. R_FB bölücülerinin transistor çalışma bölgeleri ve startup simetrisi.
5. WE guard-band, minimum write pulse, T_QUAL ve V_Q_MIN.
6. Güç koruma elemanlarının türü/MPN/değerleri.
7. SMA edge-launch gerçek CAD/stackup uyumu.
8. PCB layout, ERC/DRC, Gerber ve bench doğrulaması.

## 57.5 Tasarım dondurma kuralı

02F'de yalnız test arayüzü ve doğrulama prosedürü dondurulur. Transistor çekirdeğinin sayısal değerleri, giriş eşikleri, gecikme ve çalışma frekansı dondurulmaz. Bu parametreler ölçüm/model korelasyonu sonrasında ayrı ECO ile değiştirilebilir.
