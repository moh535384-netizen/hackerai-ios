# كيف تحصل على ملف HackerAI.ipa — 3 طرق

> ⚠️ **لماذا لا يمكن تسليمك ملف .ipa جاهزاً من هنا؟**
> بناء تطبيق iOS يتطلب **macOS + Xcode + iOS SDK** حصراً. بيئة العمل الحالية هي **Kali Linux x86_64** بلا أي من هذه الأدوات (تم التحقق: `xcodebuild`/`swiftc`/`clang` غير موجودة، لا iOS SDK). لا يوجد مسار تقني لإنتاج `.ipa` على Linux.

---

## الطريقة 1 — GitHub Actions (بدون Mac، الأسرع)

خادم GitHub يستخدم **macOS مع Xcode** مجاناً لبناء الملف.

```bash
# 1) أنشئ مستودعاً على GitHub ثم من جهازك:
cd hackerai-ios
git init
git add .
git commit -m "HackerAI iOS"
git branch -M main
git remote add origin https://github.com/<اسمك>/hackerai-ios.git
git push -u origin main
```

2) اذهب إلى: **Actions → Build HackerAI IPA → Run workflow**
3) بعد دقائق: **Artifacts → HackerAI-IPA → تنزيل** → ستحصل على:
   - `HackerAI-unsigned.ipa` (جاهز للتوقيع عبر Sideloadly/AltStore)

### (اختياري) إنتاج IPA موقّع Ad Hoc مباشرة
أضف في **Settings → Secrets and variables → Actions**:

| Secret | القيمة |
|--------|--------|
| `BUILD_CERTIFICATE_BASE64` | شهادتك `.p12` مُرمّزة base64 |
| `P12_PASSWORD` | كلمة مرور ملف .p12 |
| `PROVISIONING_PROFILE_BASE64` | ملف `.mobileprovision` مُرمّز base64 |
| `KEYCHAIN_PASSWORD` | أي كلمة مؤقتة (مثلاً `temp123`) |

ترميز الملفات على جهازك:
```bash
# على Mac/Linux
base64 -i certificate.p12 | pbcopy      # Mac
base64 -w0 certificate.p12              # Linux
base64 -i profile.mobileprovision | pbcopy
```

---

## الطريقة 2 — جهاز Mac (الأكثر تحكّماً)

```bash
cd hackerai-ios
open HackerAI.xcodeproj          # اختر فريقك في Signing & Capabilities
./build_ipa.sh unsigned          # أو: ./build_ipa.sh signed
```
الناتج: `build/HackerAI-unsigned.ipa`

---

## الطريقة 3 — AltStore / Sideloadly مباشرة (بدون IPA)

هذه الأدوات تبني وتوقّع وتثبّت على جهازك **بدون إنتاج .ipa يدوياً**:
- **Sideloadly** (Win/Mac): https://sideloadly.io — اسحب المشروع أو الـ ipa الذي بنيته.
- **AltStore**: https://altstore.io

---

## بعد حصولك على الـ IPA: التثبيت

| الطريقة | المنصة | ملاحظة |
|---------|--------|--------|
| Xcode → Devices | Mac | اسحب .ipa للجهاز |
| Apple Configurator 2 | Mac | توزيع Ad Hoc على UDIDs مسجّلة |
| Sideloadly | Win/Mac | يوقّع بـ Apple ID (مجاني = 7 أيام) |
| AltStore | Win/Mac | تجديد تلقائي أسبوعي |
| Diawi / TestFlight | الويب | رابط تثبيت OTA |

## قيود مهمة
- **غير موقّع**: لن يعمل على آيفون غير مكسور الحماية حتى توقّعه بـ Sideloadly/AltStore.
- **شهادة مجانية (Apple ID)**: صلاحية 7 أيام، 3 تطبيقات، إعادة التثبيت أسبوعياً.
- **شهادة مدفوعة ($99/سنة)**: Ad Hoc — سنة كاملة، حتى 100 جهاز مسجّل بـ UDID.
