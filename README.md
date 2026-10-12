# HackerAI — تطبيق iOS خاص (WebView Wrapper)

تطبيق iOS أصلي (SwiftUI) يغلّف **WKWebView** يعرض واجهة ويب للذكاء الاصطناعي مباشرة. لا يحتاج مفتاح API داخل التطبيق — تعمل الواجهة كما تعمل في Safari. للتوزيع الخاص فقط (Ad Hoc / Personal)، بدون رفع على App Store.

## الميزات
- ✅ **مغلّف WebView** يعرض أي واجهة ويب (HackerAI، ChatGPT، Open WebUI، LibreChat...)
- ✅ **بدون مفتاح API** — تسجّل الدخول داخل الواجهة نفسها كما في المتصفح
- ✅ أزرار التنقّل: رجوع/تقدّم/الرئيسية/تحديث
- ✅ شاشة إعدادات لتغيير الرابط واسم التطبيق، مع حفظ دائم
- ✅ إيماءات السحب للرجوع/التقدّم (native gestures)
- ✅ شريط تقدّم ومؤشّر تحميل + معالجة أخطاء الشبكة
- ✅ تصميم داكن بطابع HackerAI

## البنية
```
hackerai-ios/
├── HackerAI.xcodeproj/          # مشروع Xcode
├── HackerAI/
│   ├── HackerAIApp.swift        # نقطة الدخول
│   ├── ContentView.swift        # WebView + شريط الأدوات
│   ├── WebView.swift            # مغلّف WKWebView + WebViewModel
│   ├── SettingsManager.swift    # حفظ رابط الواجهة والاسم
│   ├── SettingsView.swift       # شاشة الإعدادات
│   ├── Info.plist
│   ├── Entitlements.plist
│   └── Assets.xcassets/
├── build_ipa.sh                 # سكربت البناء والتوقيع
└── README.md
```

## الاستخدام السريع

1. **افتح المشروع في Xcode** (على macOS):
   ```bash
   cd hackerai-ios
   open HackerAI.xcodeproj
   ```
2. **اختر فريقك** في `Signing & Capabilities`.
3. **شغّل** على جهازك (Cmd+R).
4. **داخل التطبيق**: اضغط ⚙️ الإعدادات → ضع رابط الواجهة → حفظ.

> الافتراضي: `https://chat.hackerai.co` — عدّله لأي خدمة تريدها.

## بناء IPA
```bash
chmod +x build_ipa.sh
./build_ipa.sh
```
الناتج: `build/HackerAI.ipa`

## إعداد رابط الواجهة

| الخدمة | رابط مقترح |
|--------|-----------|
| HackerAI | `https://chat.hackerai.co` (أو رابط خدمتك) |
| ChatGPT | `https://chat.openai.com` (أو `chatgpt.com`) |
| Open WebUI | `https://your-server/ui` |
| LibreChat | `https://your-server/` |

> **مهم**: استخدم `https://` دائماً. بعض الخدمات (مثل OpenAI) قد تمنع التضمين داخل WebView أو تطلب تحققاً بشرياً — استخدم واجهة تسمح بالعرض، أو Deploy خاص بك.

## طرق التثبيت على الآيفون
1. **Xcode**: المشروع → جهازك → Run (الأسهل).
2. **Apple Configurator 2** (Mac): اسحب الـ IPA للجهاز.
3. **Sideloadly** (Windows/Mac): https://sideloadly.io
4. **AltStore**: https://altstore.io
5. **Diawi**: https://diawi.com لرابط تثبيت سريع.

## أنواع التوزيع

| النوع | المدة | الأجهزة | ملاحظات |
|-------|------|---------|---------|
| Development | سنة | 100 UDID | يحتاج Mac لإعادة التوقيع |
| Ad Hoc | سنة | 100 UDID | **الأفضل للتوزيع الخاص** |
| Enterprise | سنة | غير محدود | $299/سنة |
| مجاني | 7 أيام | 1 جهاز | إعادة تثبيت أسبوعياً |

## متطلبات النظام
- **iOS**: 16.0 أو أحدث
- **Xcode**: 15.0 أو أحدث
- **macOS**: Sonoma (14.0) أو أحدث

---

**الإصدار**: 1.0 (WebView) • **الرخصة**: خاص
