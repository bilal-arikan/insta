# Instagram Projesi Kuralları

## Genel Proje Kuralları

### Windows PowerShell Komut Kullanımı

**Kural**: Windows işletim sisteminde PowerShell terminalinde komut zincirlemesi için `&&` operatörü yerine `;` kullanılmalıdır.

**Açıklama**: 
- PowerShell'de `&&` operatörü desteklenmez ve "InvalidEndOfLine" hatası verir
- Komutları zincirleme için `;` operatörü kullanılmalıdır
- Alternatif olarak komutlar ayrı satırlarda çalıştırılabilir

**Örnekler**:

✅ **DOĞRU Kullanım**:
```powershell
# Noktalı virgül ile komut zincirlemesi
cd insta_app; flutter pub get

# Ayrı komutlar olarak
cd insta_app
flutter pub get
```

❌ **YANLIŞ Kullanım**:
```powershell
# Bu PowerShell'de çalışmaz
cd insta_app && flutter pub get
```

**Uygulama Alanları**:
- Flutter komutları
- Git işlemleri
- Dosya operasyonları
- Geliştirme araçları komutları

---

## Sonraki Kurallar

*Bu bölüm proje geliştikçe güncellenecektir.*