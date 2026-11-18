# RAQM-02F Bench Setup Rehberi

## Gerekli ekipman

- Akım sınırlı ve ölçümü görülebilen laboratuvar güç kaynağı.
- Dört ayrı düşük gürültülü DC bias kaynağı veya uygun çok kanallı SMU.
- DC-coupled diferansiyel sinyal sürücüleri (DATA ve WE için).
- Yüksek empedanslı, düşük kapasitanslı diferansiyel aktif prob.
- DMM (tercihen mV sense okumalarında yeterli çözünürlük ve düşük offset).
- Osiloskop; Q çıkışında 50 Ω termination kapalı.
- Sıcaklık ölçümü ve gerekirse kontrollü sıcaklık kabini.
- ESD matı, bileklik ve mikroskop.

## Bağlantı ilkeleri

1. Tüm cihazların GND referansını kartın ortak GND'sine bağla; farklı cihazlar arasında ground-loop riski varsa önce ölçüm topolojisini gözden geçir.
2. DATA/WE kaynaklarını VDD kapalıyken aktif etme.
3. Giriş diferansiyel genliğini base pinlerindeki gerçek P/N gerilim farkından hesapla.
4. OUT_P/OUT_N'yi doğrudan 50 Ω terminasyonla yükleme.
5. FB_P/FB_N test pedlerine sıradan pasif prob bağlamadan önce kapasitans etkisini incele.
6. Her kablo, prob ve instrument termination ayarını test kaydına yaz.

## Test öncesi form

- Board serial / revision:
- Assembly date / operator:
- Active device MPN / lot:
- Supply model / current limit:
- Bias source models:
- Differential driver / output impedance:
- Scope / probe model and C_in:
- Ambient / board temperature:
- Calibration due dates:

Herhangi bir alan bilinmiyorsa `unknown` kaydet; tahminle doldurma.
