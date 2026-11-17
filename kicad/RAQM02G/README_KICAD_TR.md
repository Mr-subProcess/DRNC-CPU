# RAQM-02G KiCad şematik paketi

- `RAQM02G.kicad_sch`: KiCad 6+ S-expression şematik dosyası; tek-hücre adayının aktif çekirdek elemanlarını ve net isimlerini içerir.
- `RAQM02G.kicad_pro`: proje meta dosyası.
- `RAQM.kicad_sym` ve `sym-lib-table`: projeye özel sadeleştirilmiş sembol kitaplığı.
- `../RAQM02G_NETLIST.csv`: pin-net eşlemesi.

**Doğrulama sınırı:** Bu üretim ortamında KiCad CLI/Eeschema bulunmadığından dosya KiCad tarafından açılıp ERC/DRC/netlist export ile doğrulanamadı. S-expression parantez dengesi ve dosya içi referans/pin listesi kontrol edildi. Footprint alanları bilerek boş bırakıldı; footprint ataması, pin-1 yönü ve SOT363 land-pattern doğrulaması yapılmadan PCB/Gerber çıkarılmamalı.
