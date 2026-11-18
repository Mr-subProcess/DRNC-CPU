# 67 — 02F Release Gate ve Üretim Öncesi Yasaklar

## 67.1 Gate durumları

| Gate | Gerekli kanıt | Şu anki durum |
|---|---|---|
| G0 Requirements | Arayüz, rail, test ve limit tanımları | Kısmi / OPEN |
| G1 Components | Exact OPN, datasheet, land pattern, sourcing | OPEN |
| G2 Circuit | Doğrulanmış model, DC/transient ve PVT | OPEN / NOT RUN |
| G3 CAD | Native schematic/PCB, ERC/DRC, SI/stackup review | OPEN / NOT RUN |
| G4 First article | Montaj incelemesi ve bench ölçümleri | OPEN / NOT BUILT |
| G5 System | İki hücre, pair-valid, asenkron handshake ve recurrent link doğrulaması | NOT STARTED |
| G6 Production | Gerber/NC Drill/IPC-356/BOM/PnP/assembly sign-off | BLOCKED |

## 67.2 Kart üreticisine gönderme yasağı

Aşağıdakilerden biri eksikse imalata gönderme yapılmaz:

- Native CAD kaynağı ve release revision.
- ERC/DRC raporu ve sıfır unapproved error.
- Exact manufacturer OPN ve footprint review.
- Gerber X2, NC Drill, IPC-356 ve bağımsız netlist karşılaştırması.
- Fabricator stackup ve impedance approval.
- Assembly drawing, BOM ve pick-and-place.
- Model/bench doğrulama raporu ve ilk makale imza kaydı.

## 67.3 İddia sınırı

Bu ZIP bir mühendislik revizyon paketidir. “Üretime hazır”, “çalıştığı kanıtlandı”, “GHz”, “pikosaniye”, “kuantum qudit” veya “tam asenkron işlemci” ifadeleri bu sürümün kanıtlarıyla desteklenmez.
