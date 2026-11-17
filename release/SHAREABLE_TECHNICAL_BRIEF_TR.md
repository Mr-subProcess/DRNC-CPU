# RAQM-03D — Paylaşılabilir Teknik İnceleme Özeti

**Proje:** Recurrent Asynchronous Qudit Mesh (RAQM) — PCIe Hızlandırıcı Kartı  
**Revizyon:** 03D — XC7A100T-FGG484 pinout entegrasyonu  
**Tarih:** 18 Kasım 2026  
**Durum:** Teknik inceleme adayı — ÜRETİM ONAYI YOK (FABRICATION HOLD)

## Amaç

RAQM iki hücreli çekirdeğini masaüstü bilgisayarın PCIe x16 fiziksel yuvasına takılabilen, PCIe x1 elektriksel bağlantılı bir hızlandırıcı kart üzerinde çalıştırmak. PCIe/FPGA arayüzü saatli PCIe endpoint alanında kalır; RAQM hesaplama alanı dört fazlı REQ/ACK el sıkışmasıyla saatten bağımsız tasarlanır. Bu kartta PCIe referans saati RAQM çekirdeğine dağıtılmaz.

## Cihaz ve PCIe bağlantısı

- FPGA hedefi: AMD Artix-7 `XC7A100T`, paket `FGG484`.
- Tam sipariş kodu, hız sınıfı ve sıcaklık son eki henüz kilitlenmedi.
- AMD PG054'te XC7A100T FGG484 için PCIe integrated block konumu `X0Y0`, x1 Lane 0 önerilen GT konumu `X0Y7` olarak listelenir.
- Kullanıcı tarafından sağlanan pinout'ta seçilen GTP kanal 3: TX `D7/C7`, RX `D9/C9`, REFCLK0 `F6/E6`, MGTRREF `F8`.
- MGTRREF için 100Ω, %1 direnç MGTAVTT referansına giden tasarım adayıdır; tam UG482/AMD layout kontrolü gereklidir.
- İlk donanım bring-up hedefi Gen1 x1; Gen2 ancak link/SI/timing ölçümleriyle doğrulanırsa etkinleştirilecek.

## RAQM FPGA arayüzü

Bank 13 HR I/O, `VCCO_13=3.3V` hedefinde LVCMOS33 için seçildi. 12 pin ataması `pinout/RAQM03D_USED_NET_PIN_ASSIGNMENT.csv` ve XDC içinde listelenir. FPGA çıkışları CML hücrelerine doğrudan bağlanmaz; transistor write-driver ve comparator/level-adaptation katmanları zorunludur. Açılış sırasında FPGA pinleri high-Z olabileceğinden WE/REQ/reset gibi hatlar harici dirençlerle güvenli seviyede tutulur.

## Güç ve konfigürasyon

- FPGA core/BRAM 1.0V, auxiliary 1.8V, GTP analog 1.0V, GTP termination 1.2V, seçilen I/O bankları 3.3V hedefidir; son akım bütçesi AMD Power Design Manager ile çıkarılmalıdır.
- AMD Advisory 51017'ye göre VCCINT ve MGTAVCC, MGTAVTT'den önce veya aynı anda devreye girebilir; MGTAVTT ikisinden önce açılmamalıdır.
- Master SPI mode strap `M[2:0]=001` seçilir. Bu yalnızca Master SPI modunu seçer; x4 bus width ayrıca `BITSTREAM.CONFIG.SPI_BUSWIDTH=4` bitstream ayarıyla seçilir.
- `PUDC_B` U22 boşta bırakılamaz; default tasarım adayı 1kΩ ile VCCO_14'e bağlayıp konfigürasyon sırasında internal pull-up'ları kapatmaktır.
- `VCCBATT` E12, battery-backed AES key retention kullanılmıyorsa UG470 uyarınca GND veya VCCAUX'a bağlanabilir; bu revizyonda GND'ye 0Ω seçenek bağlantısı varsayılmıştır.
- Winbond `W25Q128JVSSM` 128-Mbit 3.3V SPI flash adayıdır; gerçek cold/warm boot ve QE/quad davranışı doğrulanmalıdır.

## Paket içeriği

- Önceki RAQM-03C paketinin tam ZIP kopyası (`baseline/`).
- Kullanıcı pinout'undan çıkarılan ilgili pin tablosu, 484 koordinatlık grid ve mantıksal net/ball atamaları.
- PCIe GTP lane haritası, Bank 13 XDC, QSPI/strap eşlemesi.
- Power rail/pin matrisi ve GTP açılış sırası.
- BOM adayları, KiCad çalışma sayfaları, sistem ve kart bölgeleme diyagramları.
- Denetim matrisi, checksum manifest ve kaynak/provenance notları.

## Açık doğrulama kapıları

1. Exact XC7A100T FGG484 speed-grade/temperature ordering code ve tedarik teyidi.
2. AMD'nin tam 484-ball pinout CSV/TXT'siyle bütün güç/GND/NC/IO ball'larının çapraz kontrolü. Bu paket yalnızca tasarım için kullanılan ilgili 106 pin satırını çıkarır; 484-ball koordinat shell'inde kalan alanlar `UNASSIGNED` olup NC anlamına gelmez.
3. Vivado'da tam device part ile PCIe IP üretimi, GTP XDC, I/O bank DRC, synthesis/implementation/timing/bitstream ve power estimation.
4. Elektriksel olarak bağlı tam KiCad şematiği, FPGA 484-ball sembol/footprint, ERC/DRC ve bağımsız tasarım incelemesi. Mevcut KiCad dosyaları sayfa/annotasyon taslağıdır; tam elektriksel netlist değildir.
5. Altı katmanlı kontrollü empedanslı PCB routing, PCIe edge-finger mekanik doğrulaması, stackup/fabricator kontrolü, Gerber/ODB++ ve CAM.
6. Üretim prototipi, rail sequencing dalga şekilleri, PCIe Gen1 x1 enumeration, ısıl/akım testleri ve RAQM handshake/iki-hücre doğrulaması.

**Release kararı:** Bu paket mimari ve pinout incelemesi için paylaşılabilir. Üretime gönderilmemeli ve PCIe slotuna takılmamalıdır. Gerber, bitstream, ERC/DRC veya fiziksel PCIe testinin tamamlandığı iddia edilmez.
