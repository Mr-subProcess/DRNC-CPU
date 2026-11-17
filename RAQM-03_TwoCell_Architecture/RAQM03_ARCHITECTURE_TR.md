# RAQM-03 — İki Hücreli Sembol Çifti Mimarisi

## 1. Aşamanın amacı
RAQM-03, RAQM-02G tek hücre adayından sonraki mimari basamaktır: iki bağımsız diferansiyel bit hücresi `B0` ve `B1` birlikte tek bir iki-bit sembol oluşturur. Bu aşama önce mimari/arayüz tanımıdır; 02G SPICE ve fiziksel bench kabul testleri tamamlanmadan üretim PCB'si serbest bırakılmaz.

## 2. Dört sembol

| B1 | B0 | Sembol | Açıklama |
|---:|---:|---|---|
| 0 | 0 | `00` | iki hücre de 0 olarak nitelendi |
| 0 | 1 | `01` | B0=1, B1=0 |
| 1 | 0 | `10` | B1=1, B0=0 |
| 1 | 1 | `11` | iki hücre de 1 olarak nitelendi |

Bunlar klasik elektronik üzerinde iki bitin dört durumudur. “Qudit” kelimesi burada 4-seviyeli sembol kodlaması için kullanılır; tek başına kuantum süperpozisyonu/kuantum donanımı anlamına gelmez.

## 3. Hücre başına arayüz
Her hücre kendi `DATA_P/N`, `WE_P/N`, `OUT_P/N`, `VBIAS_TAIL`, `VCM_DATA`, `VCM_WE`, `VREF_FB` hatlarına sahiptir. `OUT_P < OUT_N` diferansiyel sonucu, test fikstüründe `Q_i=1` olarak map edilir; bu mapping gerçek transistör yönü ve karar eşiği ölçülerek teyit edilmelidir.

## 4. PAIR_VALID
`PAIR_VALID` yalnızca iki hücrenin ayrı ayrı qualified-valid sinyalleri geldiğinde yükselir:

`PAIR_VALID = C_ELEMENT(VALID_B0, VALID_B1)`

- Her `VALID_Bi`, diferansiyel çıkışın `V_Q_MIN` eşiğini aşması ve `T_QUAL` boyunca kararlı kalmasından sonra üretilir.
- `V_Q_MIN` ve `T_QUAL` henüz ölçülmediğinden RAQM-03'te bunlar register değil, açık karakterizasyon parametreleridir.
- Bir hücre geçersizleştiğinde `PAIR_VALID` düşer; önceki iki-bit sembol geçerli kabul edilmez.
- İlk prototipte C-element ve arbiter harici fikstürde kalır. On-board C-element ancak ayrı metastabilite ve recovery testi sonrası eklenir.

## 5. Asenkron transaction
Dört-faz handshake: `REQ↑ → ACK↑ → REQ↓ → ACK↓`. Global clock/clock tree yoktur. Bir `REQ` ile gelen payload iki hücreye birlikte sunulur. `ACK` yalnız iki hücrenin `VALID_Bi` çıktıları nitelendikten sonra yükselir. Bundled-data gecikme şartı, en yavaş bit yolu ve qualification süresi üzerinden testle belirlenir.

## 6. Recurrent/topolojik güvenlik kuralları
- Aynı transaction/epoch içindeki combinational bağımlılık grafiği döngüsüzdür.
- Önceki duruma dönen bağlantı en az bir committed state boundary üzerinden geçer; zero-delay combinational feedback yoktur.
- Geçerli modelin yerel fan-in ve fan-out üst sınırı 2'dir; daha yüksek dallanma açık arbiter/splitter ile tasarlanır.
- Merge noktası tüm gerekli branch-token'lar gelmeden tüketim yapamaz.
- Token kimliği ve generation/epoch etiketi, eski ACK veya geç gelen branch'in yeni transaction'a karışmasını engeller.

## 7. Fiziksel sıralama
1. İki 02G hücresini aynı PCB üzerinde bağımsız tut; ortak bias rayları sadece ölçülmüş gürültü/impedans limitleriyle paylaşılır.
2. B0/B1 ayrı DATA ve WE portları, ayrı OUT portları ve ayrı tail sense ile test edilir.
3. Harici fixture iki hücreyi eşzamanlı yazıp dört sembol dizisini (`00`,`01`,`10`,`11`) her biri için retention ve read-disturb ile doğrular.
4. PAIR_VALID ayrı external C-element fixture'ında sınanır.
5. Daha sonra cross-cell recurrent link / mesh edge bir seferde tek bir link olarak eklenir; aynı-epoch combinational cycle oluşturulmaz.

## 8. RAQM-03 kabul koşulları
- Her bitin WRITE, HOLD, ters WRITE ve retention testi geçmiş olmalı.
- Dört sembolün tamamında doğru differential decode görülmeli.
- Bir hücre invalid olduğunda PAIR_VALID düşmeli.
- Besleme/bias kesintisi sonrası undefined-state recovery yapılmalı.
- Metastabilite çözülmeden ACK yükselmemeli.
- İki hücre birbirini bozacak bias/common-mode/ground bounce üretmemeli.

**Release status: ARCHITECTURE DEFINED / PHYSICAL INTEGRATION HOLD.**
