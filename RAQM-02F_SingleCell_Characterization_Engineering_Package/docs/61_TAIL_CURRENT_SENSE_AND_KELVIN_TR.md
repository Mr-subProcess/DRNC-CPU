# 61 — Kuyruk Akımı Ölçümü ve Kelvin Sense

## 61.1 Önerilen ek

02F'de `R_SENSE_TAIL = 10.0 Ω` düşük taraf sense direnci adayıdır. R_TAIL ile GND arasına seri yerleştirilir; iki ayrı Kelvin sense izi direnç padlerine doğrudan bağlanır. Ölçülen gerilimden akım hesaplanır:

\[
I_{TAIL}=\frac{V_{SENSE+}-V_{SENSE-}}{10.0\ \Omega}.
\]

0.75 mA için beklenen sense düşümü yaklaşık 7.5 mV'dur. Bu sayısal örnek nominal hedef üzerinden hesaplanır; gerçek akım veya tasarım sonucu değildir.

## 61.2 Devreye etkisi

10 Ω direnç, mevcut 470 Ω tail direnciyle seri toplamı yaklaşık 480 Ω yapar. Basit direnç payı açısından seri direnç artışı yaklaşık yüzde 2.1'dir; transistor VBE, base current ve kaynak empedansı sebebiyle gerçek I_TAIL değişimi birebir aynı olmayabilir. Bu nedenle:

1. 10 Ω eklenmiş halde yeniden DC çalışma noktası ölçülür.
2. VBIAS sweep ile akım ayarlanır.
3. R_TAIL/SENSE değerleri yalnız ölçüm sonrası revize edilir.
4. 02D'nin 0.75 mA adayı ölçülmüş değer kabul edilmez.

## 61.3 Ölçüm yöntemi

- Sense padlerine yüksek giriş empedanslı DMM veya differential probe bağlanır.
- Probe ground lead üzerinden sense akımını dolaştırma; iki sense ucunu diferansiyel ölç.
- Sense izi güç dönüş akımı veya SMA shell dönüş akımını taşımaz.
- DMM range, resolution, input impedance, offset ve kalibrasyon tarihi kaydedilir.

## 61.4 Alternatifler

Daha küçük sense direnci daha düşük burden sunar fakat milivolt-altı ölçüm gerektirir. Akım monitör amplifikatörü eklemek bant genişliği/offset/gürültü ve common-mode etkisi getirir. İlk kuponda basit pasif sense tercih edilir; aktif ölçüm katı daha sonra ayrı doğrulanır.

## 61.5 Kabul kaydı

Her testte `V_SENSE+`, `V_SENSE-`, hesaplanan `I_TAIL`, VBIAS, sıcaklık ve VDD birlikte kaydedilir. Yalnız sense gerilimini yazıp akımı yazmamak kabul edilmez.
