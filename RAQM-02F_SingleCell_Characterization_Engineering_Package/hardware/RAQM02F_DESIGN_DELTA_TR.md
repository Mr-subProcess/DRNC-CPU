# RAQM-02F Donanım Tasarım Farkı

| Alan | 02D/02E baseline | 02F önerisi | Freeze durumu |
|---|---|---|---|
| Test article | İki bağımsız bit hücre | Tek hücre karakterizasyon kuponu | Mimari karar adopted; CAD açık |
| Bias | Her iki hücre için header kaynakları | Tek hücre için ayrı harici rail seti | Arayüz adayı |
| Tail sense | Doğrudan R_TAIL | R_TAIL + 10 Ω sense shunt | Elektriksel aday; analiz gerekli |
| Güç koruma | Açık karar | Footprint rezervi; değer/MPN yok | Open |
| Q probes | Yüksek-Z kuralı | High-Z differential probe + testpoint | Mandatory |
| Pair valid | Harici fixture | Aynı; tek hücrede yok | Mandatory |
| PCB | İki hücre konsept floorplan | Tek hücre konsept floorplan | Native CAD yok |
| Recurrent mesh | Yok | Yok | Sonraki aşama |

Bu fark tablosu tasarım kararlarını kaydeder; yeni schematic/netlist üretildiğini göstermez.
