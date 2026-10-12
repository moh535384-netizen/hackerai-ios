# تثبيت HackerAI على آيفونك عبر متجر البرامج (بدون Mac)

الملف الذي تحتاجه: **`HackerAI-unsigned.ipa`** — غالباً متاجر مثل ESign و Scarlet و GBox و TrollStore تقبلها وتوقّعها على الجهاز.

---

## الخطوة 1 — ابنِ ملف .ipa (مرة واحدة عبر GitHub)

### أ) أنشئ مستودعاً فارغاً على GitHub
- ادخل https://github.com/new
- الاسم: `hackerai-ios` → **Create repository** (لا تضف README).

### ب) من جهازك (Linux/Mac/Windows مع git)
```bash
cd hackerai-ios
chmod +x push_to_github.sh
./push_to_github.sh <اسم_مستخدمك> hackerai-ios
```

### ج) شغّل البناء
- افتح `https://github.com/<اسمك>/hackerai-ios/actions`
- اختر **Build HackerAI IPA** → **Run workflow** → **Run**
- انتظر ~3–5 دقائق
- افتح آخر تشغيل ناجح → قسم **Artifacts** → نزّل **HackerAI-IPA**
- داخله: `HackerAI-unsigned.ipa`

> بديل بدون git: من صفحة المستودع **Add file → Upload files** وارفع محتويات المجلد، ثم شغّل الـ workflow.

---

## الخطوة 2 — استورد الـ IPA في متجرك

### ESign / GBox / Scarlet ونحوها
1. انقل `HackerAI-unsigned.ipa` إلى الآيفون (AirDrop / iCloud Drive / Files).
2. افتح المتجر → **Import / استيراد** → اختر الملف من Files.
3. اضغط **Sign / توقيع** (غالباً: Sign with certificate أو توقيع بشهادة).
4. اضغط **Install / تثبيت**.
5. من الإعدادات → **عام → VPN وإدارة الجهاز** → ائتمن الشهادة (إن طُلب).
6. افتح التطبيق.

### TrollStore (إن كان متاحاً على جهازك/iOSك)
1. انقل الـ IPA إلى الآيفون.
2. افتح **TrollStore** → **+** → اختر الملف.
3. يثبّت **دائماً** بلا شهادة ولا انتهاء صلاحية (أفضل خيار إن كان مدعوماً).

---

## الخطوة 3 — أول تشغيل

افتراضياً يفتح التطبيق: `https://chat.hackerai.co`
غيّره من داخل التطبيق: ⚙️ → **رابط الواجهة** → ضع رابط خدمتك → حفظ.
(يمكن وضعه أيضاً مباشرة في `HackerAI/SettingsManager.swift` قبل البناء.)

---

## نصائح وحلول مشاكل

| المشكلة | الحل |
|---------|------|
| "Untrusted Developer" | الإعدادات → عام → VPN وإدارة الجهاز → ائتمن |
| التطبيق يتوقف عند الفتح | تأكد أن البناء Release وأن المعرّف `com.hackerai.app` مطابق للشهادة |
| صفحة بيضاء في WebView | الموقع يمنع التضمين؛ جرّب واجهة self-hosted أو خدمة تسمح بالعرض |
| انتهت الشهادة | أعد التوقيع في المتجر (شهادات Apple ID المجانية = 7 أيام) |
| "App not installed" في المتجر | تأكد أن الـ IPA من Artifacts وليس المصدر؛ أعد تنزيله كاملاً |

---

## ملاحظة
الملف من GitHub Actions هو **unsigned**، وهذا **مطلوب** لمتجرك (المتجر يقوم بالتوقيع). لا تستخدم أي IPA "موقّع" من مصادر مجهولة — قد يحوي كوداً ضاراً.
