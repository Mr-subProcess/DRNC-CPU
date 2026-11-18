# 64 — Harici Test Fikstürü, Handshake ve Capture

## 64.1 Fikstür fonksiyonları

Test fikstürü 02F kartından ayrı bir sistemdir. En az şu işlevleri sağlamalıdır:

- DATA_P/N ve WE_P/N için DC-coupled, ayarlanabilir ve düşük gürültülü diferansiyel sürüş.
- VDD ve bias kaynaklarının ayrı ölçümü / inhibit kontrolü.
- OUT_P/N için high-Z differential capture.
- V_Q_MIN, VCM_Q_MIN/MAX, T_QUAL ve WE/DATA guard-band parametreleri.
- timeout, rail-fault, reset ve invalid-input durumunda capture inhibit.
- test başına transaction ID / epoch label ve sonuç log'u.

Bu belge fikstürün fonksiyonel şartıdır; mikrodenetleyici yazılımı, logic kodu veya hazır fixture PCB'si içermez.

## 64.2 4-faz handshake

1. **Idle:** DATA ve WE sürücüleri güvenli idle; önceki REQ/ACK düşük.
2. **Request:** Sender DATA'yı sabitler; WE diferansiyel polaritesi WRITE tarafına geçirilir. DATA ACK gelene kadar değişmez.
3. **Capture:** Fikstür Q diferansiyel marjını ve common-mode penceresini T_QUAL boyunca doğrular. Ancak tüm koşullar sağlanırsa ACK_CAPTURE yükselir.
4. **Return-to-zero:** Sender WE'yi HOLD polaritesine döndürür ve REQ'yu indirir. Receiver ACK_CAPTURE'ı indirir; sonraki transaction ancak idle doğrulandıktan sonra açılır.

## 64.3 Indeterminate region

WE_P−WE_N sıfıra yaklaştığında U_SEL akımı iki kola paylaşabilir. Bu bölgede Q geçersizdir. DATA_P−DATA_N sıfıra yaklaştığında U_DATA çiftinin karar marjı kaybolabilir. Fikstür bu iki aralığı karakterize etmeli ve capture'ı inhibit etmelidir.

## 64.4 Pair-valid sonraki aşama

İki hücre birlikte test edilse bile `PAIR_VALID` yalnızca iki hücrenin aynı transaction ID'ye ait geçerli capture sonuçları varsa ve fault yoksa yükselir. Mantık ifadesi:

`PAIR_VALID = ACK_B0_VALID AND ACK_B1_VALID AND SAME_TRANSACTION AND NOT_FAULT`

02F tek hücre kartında bu sinyal yoktur. Gelecek revizyonda C-element/arbiter ayrı doğrulanmadan iki bitin birleşik geçerlilik iddiası yapılmaz.
