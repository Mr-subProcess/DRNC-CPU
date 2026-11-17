# Change log

## RAQM-02G — 2026-11-17
- 02F arşivi baseline olarak eklendi.
- 02G tek hücre SPICE uyumlu DC ve WRITE/HOLD transient deck'leri eklendi.
- Diodes Inc. BC847BS modelini yalnız proxy olarak dahil eden subcircuit wrapper eklendi; Nexperia ile aynı model olmadığı belirtildi.
- Nexperia BCM847BS'nin resmi fiziksel pin dizilimine göre pin map CSV ve KiCad custom symbol üretildi.
- KiCad project, schematic ve local library dosyaları eklendi.
- RAQM-03 iki hücreli 00/01/10/11 mimarisi ve asynchronous PAIR_VALID tanımı eklendi.
- Gerçek SPICE / ERC / DRC çalıştırılmadı; release gate'leri açık bırakıldı.
