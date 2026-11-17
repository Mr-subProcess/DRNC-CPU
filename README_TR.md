# RAQM-03D — XC7A100T-FGG484 PCIe Hızlandırıcı Kartı

**Sürüm:** 03D  
**Tarih:** 18 Kasım 2026  
**Durum:** Pinout entegre edilmiş mühendislik adayı — **FABRICATION HOLD**  
**Önceki sürüm:** RAQM-03C, tam ZIP baseline olarak korunmuştur.

## Bu revizyonun özeti

Bu sürüm, kullanıcı tarafından sağlanan `Device/Package: XC7A100T FGG484` pinout dökümünden kartta gereken GTP, güç, konfigürasyon/JTAG ve Bank 13 I/O pinlerini çıkarır. 03C'deki `XC7A35T / X0Y3` hedefi kaldırılmıştır. Yeni hedef `XC7A100T-FGG484` paketidir; tam sipariş kodunun hız sınıfı ve sıcaklık eki henüz verilmediğinden MPN son eki dondurulmamıştır.

AMD PG054, XC7A100T için FGG484 paketini PCIe integrated-block kombinasyonu olarak listeler ve x1 PCIe Lane 0 için önerilen GT konumunu `X0Y7` olarak verir. Kullanıcı pinout dökümündeki Bank 216 transceiver kanal 3 pinleri bu sürümde Lane 0 için eşleştirilmiştir: TX `D7/C7`, RX `D9/C9`, REFCLK0 `F6/E6`. Bu eşlemenin son tasarım onayı, Vivado'nun seçilen tam parça için oluşturduğu IP/XDC ile yapılmalıdır.

## Öne çıkan dosyalar

- `pinout/XC7A100T_FGG484_RELEVANT_PINOUT_EXTRACT.csv` — kartta kullanılan ve güç/konfigürasyon için gerekli pinlerin dökümü.
- `pinout/FGG484_484_BALL_GRID_WITH_ASSIGNED_NETS.csv` — 22×22/484 koordinat ızgarası; yalnızca çıkarılan pinler dolduruldu, geri kalanlar özellikle boş bırakıldı.
- `pinout/RAQM03D_USED_NET_PIN_ASSIGNMENT.csv` — gerçek net/ball eşleme tablosu.
- `interfaces/RAQM03D_PCIE_GTP_LANE_MAP.csv` — PCIe Lane 0 GTP pin eşlemesi.
- `constraints/RAQM03D_BANK13_IO.xdc` — Bank 13 LVCMOS33 I/O pin atamaları.
- `power/RAQM03D_POWER_PIN_MAP.csv` ve `power/RAQM03D_POWER_RAIL_MATRIX.csv` — gerçek pin/rail planı.
- `configuration/RAQM03D_MASTER_SPI_X4_MAP.csv` — Master SPI strap, PUDC_B ve x4 bitstream ayarı eşlemesi.
- `kicad/RAQM03D/` — 03C sistem-seviyesi KiCad dosyalarının 03D adlandırılmış devamı ve pin eşleme anotasyon sayfası. Bunlar henüz tam elektriksel netlist değildir.
- `baseline/RAQM-03C_PCIe_Schematic_and_PCB_PreRelease_Package.zip` — önceki sürümün tam kopyası.

## Kartın mantıksal bağlantısı

PCIe endpoint ve GT transceiver yalnızca bilgisayar bağlantı alanında saatli çalışır. RAQM çekirdek alanı global saat almadan dört fazlı REQ/ACK ile çalışır. FPGA ile CML arasında ayrı write-driver ve comparator/level-adaptation katmanları zorunludur. FPGA 3.3V I/O pinleri CML transistor tabanlarına veya 5V comparator çıkışlarına doğrudan bağlanamaz.

## Tasarım sınırları

Bu paket bir **pinout-integrated pre-release** paketidir; üretim paketi değildir. KiCad CLI/Eeschema, Vivado ve fiziksel prototip test araçları bu yürütme ortamında bulunmadığından ERC/DRC, FPGA synthesis/implementation, timing, bitstream, PCB routing, Gerber veya gerçek PCIe link test sonucu iddia edilmez. Hız sınıfı/sıcaklık suffix, final flash ordering, regülatör değerleri, AC-capacitor final values, analog interface thresholds and board stackup finalization remain open.

**Bu ZIP'ten Gerber üretmeyin ve kartı PCIe yuvasına takmayın. Release status: HOLD.**
