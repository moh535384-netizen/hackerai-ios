import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: SettingsManager
    @State private var localURL: String = ""
    @State private var localTitle: String = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()

                Form {
                    Section("الواجهة") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("رابط الواجهة (Home URL)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.green)
                            TextField("https://chat.hackerai.co", text: $localURL)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                                .disableAutocorrection(true)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("اسم التطبيق (العنوان العلوي)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.green)
                            TextField("HackerAI", text: $localTitle)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }

                    Section {
                        Button("حفظ ومتابعة") { save() }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        Button("استعادة الافتراضي") {
                            settings.reset()
                            localURL = settings.homeURL
                            localTitle = settings.appTitle
                            alertMessage = "تمت الاستعادة"
                            showAlert = true
                        }
                        .foregroundColor(.orange)
                    }

                    Section("نصائح") {
                        Text("• ضع هنا رابط أي واجهة ويب تدعم الذكاء الاصطناعي (خدمة HackerAI، ChatGPT، أو واجهة self-hosted مثل Open WebUI / LibreChat).")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.gray)
                        Text("• يجب أن يبدأ الرابط بـ https:// ليعمل بشكل آمن.")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("الإعدادات")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("إغلاق") { dismiss() }
                            .foregroundColor(.green)
                    }
                }
                .toolbarBackground(Color(red: 0.05, green: 0.06, blue: 0.09), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    localURL = settings.homeURL
                    localTitle = settings.appTitle
                }
            }
            .preferredColorScheme(.dark)
            .alert("تنبيه", isPresented: $showAlert) {
                Button("موافق", role: .cancel) { dismiss() }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func save() {
        let url = localURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = localTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !url.isEmpty, let parsed = URL(string: url), parsed.scheme != nil else {
            alertMessage = "يرجى إدخال رابط صالح (مثال: https://...)"
            showAlert = true
            return
        }

        settings.homeURL = url
        settings.appTitle = title.isEmpty ? "HackerAI" : title
        settings.save()

        alertMessage = "تم الحفظ"
        showAlert = true
    }
}
