#!/bin/bash
# ============================================================
#  ارفع المشروع إلى GitHub بأمر واحد — ثم GitHub يبني الـ .ipa تلقائياً
#  الاستخدام:
#     ./push_to_github.sh <اسم_مستخدمك> <اسم_المستودع>
#  مثال:
#     ./push_to_github.sh myname hackerai-ios
# ============================================================
set -euo pipefail

GH_USER="${1:?الاستخدام: $0 <github_user> <repo_name>}"
REPO="${2:?الاستخدام: $0 <github_user> <repo_name>}"

echo "==> تهيئة git"
git init -q 2>/dev/null || true
git add -A
git -c user.email="build@local" -c user.name="HackerAI Build" commit -q -m "HackerAI iOS build" || echo "(لا تغييرات جديدة)"
git branch -M main

echo "==> ربط المستودع"
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${GH_USER}/${REPO}.git"

echo "==> رفع"
git push -u origin main

echo ""
echo "✅ تم الرفع."
echo "الآن افتح: https://github.com/${GH_USER}/${REPO}/actions"
echo "→ اختر 'Build HackerAI IPA' → Run workflow"
echo "→ بعد دقائق: Artifacts → HackerAI-IPA → نزّل HackerAI-unsigned.ipa"
echo ""
echo "ثم استورده في متجر البرامج لديك (ESign / Scarlet / TrollStore ...)."
