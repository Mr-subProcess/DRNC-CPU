# 66 — Power-Up, Fault ve Recovery Davranışı

## 66.1 Power-up

Latch'in başlangıç state'i tanımlı değildir. Besleme yükselirken OUT_P/OUT_N geçici olarak eşit, metastable veya rastgele polaritede olabilir. Bu nedenle power-on reset veya deterministic init varmış gibi davranılmaz.

Güç rayları stabil olduktan, bias seviyeleri ölçüldükten ve girişler güvenli seviyeye geldikten sonra fikstür açık WRITE transaction ile bilinen state'i yükler. Q margin T_QUAL boyunca korunmadan ACK_CAPTURE verilmez.

## 66.2 Fault sınıfları

- VDD under/over-voltage.
- VBIAS/VCM/VREF rail out-of-window.
- External driver common-mode drift veya overdrive.
- DATA/WE pair differential guard-band içinde.
- Tail current out-of-range.
- Q differential margin collapse.
- Timeout veya REQ/ACK return-to-zero tamamlanmaması.
- Prob/cable loading sonucu state'in bozulması.
- Power sequence ihlali.

## 66.3 Güvenli davranış

Herhangi bir fault'ta capture inhibit edilir; geçerli transaction tamamlanmış kabul edilmez. Rail düzelince otomatik olarak önceki Q değerini geçerli saymak yasaktır. Hücre yeniden initialize edilir ve yeni transaction ID kullanılır.

## 66.4 Güç kesilince

VDD yokken DATA/WE sürücüleri disable edilir. Bias rayları VDD'den önce aktif bırakılmaz. Yeniden açılış sonrası state undefined kabul edilir.
