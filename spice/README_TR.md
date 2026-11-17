# RAQM-02G SPICE dosyaları — Türkçe

## Amaç
Bu klasör, 02F tek-bit CML/latch adayının SPICE uyumlu devre tanımını ve analiz senaryolarını içerir. Şu anki çalışma ortamında `ngspice` bulunmadığı ve dış paket deposuna DNS erişimi olmadığı için simülasyon motoru burada çalıştırılamadı. Bu nedenle bu pakette sayısal SPICE sonucu, dalga şekli veya yakınsama raporu yoktur.

## Modelin kritik sınırı
`models/DI_BC847BS_PROXY.lib`, Diodes Incorporated'ın resmi ürün sayfasında sunduğu BC847BS SPICE modelini taşır. Bu model **Nexperia BCM847BS için üretici modeli değildir**. Projede fiziksel olarak hedeflenen parça Nexperia BCM847BS,115 / BCM847BS,135 matched dual NPN olduğundan proxy yalnızca kaba devre davranışını taramak içindir. Eşleşme (VBE/HFE tracking), lot dağılımı ve Nexperia'ya özgü davranış bu modelle kanıtlanamaz.

## Dosyalar
- `RAQM02G_DC_OP.cir`: WRITE/HOLD durumunda DC operating point taraması.
- `RAQM02G_WRITE_HOLD_TRAN.cir`: WRITE → HOLD → ters DATA ile WRITE → HOLD geçiş transient testi.
- `models/DI_BC847BS_PROXY.lib`: proxy model ve BCM847BS 6-pin subckt wrapper.
- `run_ngspice.sh`: ngspice yüklü bilgisayarda batch çalıştırma komutları.
- `SPICE_RUN_STATUS_TR.md`: koşum durumu ve kabul ölçütleri.

## Çalıştırma
Linux/macOS: `ngspice -b RAQM02G_DC_OP.cir` ve `ngspice -b RAQM02G_WRITE_HOLD_TRAN.cir`

Dosyalardaki `.control` blokları `wrdata` ile CSV çıktısı üretmeyi amaçlar. Simülatör sürümüne göre küçük komut uyarlaması gerekebilir.

## Yorumlama disiplini
- DC ve transient çıktıları ancak gerçek ngspice koşusu, log ve model hash'iyle raporlanmalıdır.
- Proxy sonuçları Nexperia parça garantisi değildir.
- Bir latch'in iki mantık durumunu tuttuğu, yalnızca tek bir `.op` sonucuyla kanıtlanmış sayılmaz.
- Sıcaklık, transistor mismatch, VBIAS, VCM, DATA/WE amplitüdü, startup ve read-disturb taramaları gerekir.
