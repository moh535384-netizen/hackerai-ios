#!/bin/bash
# ============================================================
#  HackerAI — بناء .ipa (خياران)
#   1) غير موقّع (unsigned)  → للاستخدام مع Sideloadly/AltStore
#   2) موقّع Ad Hoc          → إن توفّر ملف التوقيع
#  يتطلب: macOS + Xcode 15+
# ============================================================
set -euo pipefail

PROJECT="HackerAI.xcodeproj"
SCHEME="HackerAI"
BUNDLE_ID="com.hackerai.app"
OUT="build"
MODE="${1:-unsigned}"   # unsigned | signed

echo "==> تنظيف"
rm -rf "$OUT"
mkdir -p "$OUT"

if [ "$MODE" = "unsigned" ]; then
  echo "==> بناء غير موقّع"
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -sdk iphoneos \
    -derivedDataPath "$OUT" \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGN_ENTITLEMENTS="" \
    clean build

  APP=$(find "$OUT/Build/Products/Release-iphoneos" -maxdepth 1 -name "*.app" | head -n1)
  echo "==> الحزمة: $APP"
  rm -rf "$OUT/pkg" && mkdir -p "$OUT/pkg/Payload"
  cp -R "$APP" "$OUT/pkg/Payload/"
  (cd "$OUT/pkg" && zip -qry "../HackerAI-unsigned.ipa" Payload)
  echo "==> تم: $OUT/HackerAI-unsigned.ipa"
  echo "    ثبّته عبر Sideloadly / AltStore (يوقّعه بمعرّف Apple ID الخاص بك)."

elif [ "$MODE" = "signed" ]; then
  : "${TEAM_ID:?ضع TEAM_ID أولاً: export TEAM_ID=XXXXXXXXXX}"
  : "${EXPORT_METHOD:=ad-hoc}"   # ad-hoc | development | app-store
  echo "==> أرشفة"
  xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$OUT/HackerAI.xcarchive" \
    DEVELOPMENT_TEAM="$TEAM_ID" \
    PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
    CODE_SIGN_STYLE=Automatic

  cat > "$OUT/ExportOptions.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key><string>${EXPORT_METHOD}</string>
  <key>teamID</key><string>${TEAM_ID}</string>
  <key>compileBitcode</key><false/>
  <key>stripSwiftSymbols</key><true/>
  <key>thinning</key><string>&lt;none&gt;</string>
</dict>
</plist>
EOF

  echo "==> تصدير"
  xcodebuild -exportArchive \
    -archivePath "$OUT/HackerAI.xcarchive" \
    -exportOptionsPlist "$OUT/ExportOptions.plist" \
    -exportPath "$OUT"
  echo "==> تم: $OUT/HackerAI.ipa"
else
  echo "استخدام: $0 [unsigned|signed]"; exit 1
fi
