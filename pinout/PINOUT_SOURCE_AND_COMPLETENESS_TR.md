# Pinout Kaynağı ve Kapsamı

Kaynak cihaz dökümü kullanıcı tarafından bu konuşmada sağlandı: `Device/Package: xc7a100tfgg484`, toplam pin sayısı 484. Bu pakette kartın gerçekten kullandığı pinler, dedicated configuration/JTAG pinleri ve bütün ana rail pinleri dökümden çıkarılarak CSV'ye işlendi.

**Önemli kapsam notu:** `FGG484_484_BALL_GRID_WITH_ASSIGNED_NETS.csv` 22×22 koordinat ızgarasını 484 satır olarak içerir. Bu, tüm 484 ball'ın signal/NC bilgisinin yeniden yazıldığı anlamına gelmez. Bu sürümde tasarım için gereken pinler dolduruldu; geri kalan koordinatlar `NOT_EXTRACTED / UNASSIGNED` olarak bırakıldı. Boş kayıtlar NC anlamına gelmez. Kullanıcı metninin her satırının otomatik pars edilmiş tam vendor CSV'si değildir.

## Kontrol edilen pin grupları

- GTP Quad 216 kanalları 0–3 TX/RX pinleri ve REFCLK0/1.
- PCIe Lane 0 için kanal 3 TX/RX pinleri, REFCLK0 ve MGTRREF.
- MGTAVCC/MGTAVTT supply balls.
- VCCINT, VCCBRAM, VCCAUX, VCCO_0, VCCO_13, VCCO_14, VCCADC, GNDADC, VCCBATT.
- Dedicated configuration, mode strap, PUDC_B ve JTAG pins; XADC VREFP/VREFN/VP/VN/DXP/DXN are listed as unassigned analog pins.
- Bank 14 QSPI multifunction pins, including PUDC_B U22.
- XADC pins VCCADC/GNDADC, VREFP/VREFN, VP/VN and DXP/DXN are extracted; unused analog inputs/references remain unassigned pending UG480 design decision.
- Bank 13 RAQM / PERST# I/O assignments.

## PCIe assignment basis

AMD PG054's Artix-7 table lists the XC7A100T FGG484 package and recommends GT site X0Y7 for a one-lane link; integrated PCIe block is X0Y0. The user-provided ball map identifies the selected physical GTP channel-3 balls as D7/C7 TX, D9/C9 RX, F6/E6 REFCLK0. Vivado's generated PCIe IP XDC and `report_drc` are required final authorities before PCB release.
