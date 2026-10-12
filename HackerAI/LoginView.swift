import SwiftUI

// MARK: - شاشة الدخول (تحاكي واجهة hackerai.co)

struct LoginView: View {
    var onEnter: () -> Void
    @State private var skipNext = false
    @EnvironmentObject var settings: SettingsManager

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // الشعار
            VStack(spacing: 10) {
                Image(systemName: "terminal.fill")
                    .font(.system(size: 54))
                    .foregroundColor(.green)

                Text("HackerAI")
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)

                Text("منصة الاختراق الأخلاقي المدعومة بالذكاء الاصطناعي")
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 46)

            // زرّا الدخول والتسجيل
            VStack(spacing: 14) {
                Button {
                    settings.homeURL = "https://chat.hackerai.co"
                    settings.save()
                    enter()
                } label: {
                    Text("دخول")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                }

                Button {
                    settings.homeURL = "https://chat.hackerai.co/register"
                    settings.save()
                    enter()
                } label: {
                    Text("تسجيل دخول")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 1.5)
                        )
                }
            }
            .padding(.horizontal, 32)

            // خيار تخطي الشاشة
            Toggle(isOn: $skipNext) {
                Text("لا تظهر هذه الشاشة مرة أخرى")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.gray)
            }
            .toggleStyle(.switch)
            .tint(.green)
            .padding(.horizontal, 32)
            .padding(.top, 22)

            Spacer()

            Text("يعمل مباشرة عبر سيرفرات HackerAI — بدون مفتاح API")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.gray.opacity(0.7))
                .padding(.bottom, 18)
        }
    }

    private func enter() {
        if skipNext {
            UserDefaults.standard.set(true, forKey: "hackerai_skipLogin")
        }
        onEnter()
    }
}
