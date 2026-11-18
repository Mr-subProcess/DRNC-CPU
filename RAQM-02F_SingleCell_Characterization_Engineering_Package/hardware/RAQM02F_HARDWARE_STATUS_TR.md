# RAQM-02F Donanım Durumu

## Amaç

İlk fiziksel test makalesi tek bit CML latch karakterizasyon kuponudur. Bu dosya kesin schematic veya PCB değildir; kartın fonksiyonel bölgelerini ve doğrulanması gereken net bağlantılarını tanımlar.

## Değişiklik yaklaşımı

- U_DATA/U_FB/U_SEL/Q_TAIL transistor çekirdeği 02D aday topolojisi olarak kalır.
- Hücre başına bağımsız bias rail erişimi korunur.
- 10 Ω tail sense direnci ve Kelvin pad'leri önerilen ek olarak tanımlanır; henüz CAD netlistine işlenmiş/frozen değildir.
- Tek hücre için J1–J6 SMA portları ve P1 bias header'ı tanımlanır.
- J7 power connector ve koruma footprint stratejisi kavramsaldır.
- PAIR_VALID, ACK arbiter ve recurrent node bağlantısı yoktur.

## CAD/imalat durumu

| Çıktı | Durum |
|---|---|
| Tek hücre block diagram | SVG konsept mevcut |
| Tek hücre floorplan concept | SVG konsept mevcut |
| Connector/testpoint schedule | CSV gereksinim düzeyinde |
| BOM delta | Aday/MPN TBD |
| SPICE model / simulation | NOT RUN |
| Native schematic | NOT GENERATED |
| Native PCB/routing | NOT GENERATED |
| ERC/DRC | NOT RUN |
| Gerber/NC Drill/IPC-356 | NOT GENERATED |
| First article | NOT BUILT |

**Release: HOLD — DO NOT FABRICATE.**
