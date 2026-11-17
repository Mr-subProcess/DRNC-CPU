# Değişiklik Kaydı — RAQM-03D

- 03C'deki XC7A35T-FGG484 / X0Y3 hedefi iptal edildi.
- Kullanıcının sağladığı cihaz/paket pinout'una göre tasarım hedefi XC7A100T-FGG484 olarak güncellendi.
- PCIe x1 Lane 0 için PG054 önerisi X0Y7 olarak işlendi; pinout kanal 3: TX D7/C7, RX D9/C9, REFCLK0 F6/E6.
- MGTAVCC, MGTAVTT, MGTRREF pinleri ve 100Ω/1% RREF bağlantı gereksinimi işlendi.
- Bank 13 üzerinde 12 adet LVCMOS33 RAQM/PCIe-reset I/O atandı; tümü aynı VCCO_13 rayına bağlandı.
- Master SPI konfigürasyon planı: M[2:0]=001 selects Master SPI; `BITSTREAM.CONFIG.SPI_BUSWIDTH=4` selects x4; CFGBVS=VCCO, VCCO_0=VCCO_14=flash VCC=3.3V. PUDC_B U22 is explicitly strapped.
- W25Q128JVSSM flash adayı, Winbond 2025 seçim kılavuzunda SOP-8 / 128-Mbit / 2.7–3.6V / SPI-Dual-Quad / mass-production P bilgileriyle yeniden kaydedildi.
- 484 konumlu grid üretildi; yalnızca bu kart tasarımında kullanılan ve kullanıcı dökümünden çıkarılan konumlar dolduruldu. Diğer koordinatlar NC varsayılmadı.
- 03C tam arşivi `baseline/` içinde korundu.
- KiCad sayfaları 03D olarak yeniden etiketlendi; KiCad native electrical connectivity / ERC sign-off iddia edilmedi.
