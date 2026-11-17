# SPICE koşum durumu — RAQM-02G

## Sonuç
**SIMULATION NOT RUN IN THIS ENVIRONMENT.** Ortam denetiminde `ngspice` executable veya `libngspice` bulunmadı. Debian paket deposuna erişim denemesi DNS çözümleme hatasıyla sonuçlandığından bu oturum içinde simülatör kurulamadı. Bu nedenle DC operating point, transient, Monte Carlo veya PVT sayısal çıktısı üretilmedi.

## Teslim edilen
- SPICE uyumlu tek-hücre devre tanımı (DC + transient ayrı dosyalar)
- Model dosyası ve üretici/proxy ayrımı
- Çalıştırma scripti
- Simülasyonda gözlenecek düğüm ve akımlar

## Proxy modelin sınırı
Model kaynağı Diodes Inc. resmi BC847BS ürün sayfasıdır. RAQM prototip BOM'unda hedeflenen parça Nexperia BCM847BS, matched dual transistor. İki parçanın aynı tip numarasını taşıması aynı üretici modeli/karakteristiği anlamına gelmez. Model matching, thermal tracking, PCB parasitics ve Nexperia üretim dağılımlarını temsil etmez.

## Gerçek ngspice koşusundan önce düzeltilecek/teyit edilecekler
1. Nexperia BCM847BS için üretici SPICE modeli veya Nexperia tarafından doğrulanmış model bulunması.
2. QTAIL için hedeflenen BC847B'nin modele uygunluğu.
3. Transistor model wrapper pin sırası ve device polarity.
4. Data/WE source impedance ve 100 ohm termination etkileşimi.
5. `.op` ve `.tran` yakınsaması; gerekirse startup ramp ve gmin stepping.
6. WRITE/HOLD/WRITE/HOLD'da iki saklanan diferansiyel durumun ve VCE headroom'un kanıtı.
7. Model doğrulaması sonrası VBIAS, VCM_DATA, VCM_WE, VREF, R_LOAD, R_FB, R_TAIL, RSENSE taraması.

`wrdata` dosyaları yalnız ngspice gerçek koşusu başarıyla tamamlanırsa sonuç kabul edilir. Dosyanın varlığı tek başına başarı kanıtı değildir.
