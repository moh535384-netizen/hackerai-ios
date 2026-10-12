import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: SettingsManager
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.09)
                .ignoresSafeArea()

            if isLoggedIn {
                MainView()
            } else {
                LoginView(onEnter: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isLoggedIn = true
                    }
                })
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            isLoggedIn = UserDefaults.standard.bool(forKey: "hackerai_skipLogin")
        }
    }
}

// MARK: - الشاشة الرئيسية (الموقع + شريط تحكم عربي أصلي)

struct MainView: View {
    @EnvironmentObject var settings: SettingsManager
    @StateObject private var model: WebViewModel
    @State private var selectedServer = 0
    @State private var intelligence: Double = 0.7
    @State private var showIntelligence = false
    @State private var showSettings = false

    private let servers = ["سريع (US)", "قوي (EU)", "اقتصادي (ASIA)"]

    init() {
        _model = StateObject(wrappedValue: WebViewModel(homeURL: "https://chat.hackerai.co"))
    }

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.09)
                .ignoresSafeArea()

            WebView(model: model)

            if model.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(.green)
                        .scaleEffect(1.2)
                    Text("جارٍ التحميل...")
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                    Spacer()
                }
            }

            if let error = model.errorMessage {
                VStack(spacing: 14) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 46))
                        .foregroundColor(.orange)
                    Text("تعذّر التحميل")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)
                    Text(error)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    HStack(spacing: 12) {
                        Button("إعادة المحاولة") { model.reload() }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        Button("الرئيسية") { model.goHome() }
                            .buttonStyle(.bordered)
                            .tint(.cyan)
                        Button("الإعدادات") { showSettings = true }
                            .buttonStyle(.bordered)
                            .tint(.gray)
                    }
                }
                .padding(24)
                .background(Color.black.opacity(0.85))
                .cornerRadius(18)
                .padding(.horizontal, 24)
            }

            if let toast = model.toast {
                VStack {
                    Text(toast)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green.opacity(0.85))
                        .cornerRadius(10)
                    Spacer()
                }
                .padding(.top, 60)
                .transition(.opacity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            controlBar
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            if model.homeURL != settings.homeURL {
                model.homeURL = settings.homeURL
                model.goHome()
            }
        }
        .onChange(of: settings.homeURL) { newValue in
            model.homeURL = newValue
            model.goHome()
        }
    }

    // MARK: شريط التحكم السفلي

    private var controlBar: some View {
        VStack(spacing: 10) {
            if showIntelligence {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("مستوى الذكاء")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int((1.0 - intelligence) * 10) + 1)/10")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.green)
                    }
                    Slider(value: $intelligence, in: 0...1, step: 0.1)
                        .tint(.green)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 0.08, green: 0.09, blue: 0.12))
                .cornerRadius(12)
                .padding(.horizontal, 8)
            }

            HStack(spacing: 14) {
                // رفع ملفات: يفتح نافذة الرفع داخل الموقع نفسه
                Button {
                    model.triggerSiteFilePicker()
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18))
                        Text("رفع")
                            .font(.system(size: 9, design: .monospaced))
                    }
                }
                .foregroundColor(.green)

                // اختيار السيرفر
                Menu {
                    ForEach(0..<servers.count, id: \.self) { i in
                        Button(servers[i]) {
                            selectedServer = i
                            model.showToast("السيرفر: \(servers[i])")
                        }
                    }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "server.rack")
                            .font(.system(size: 18))
                        Text(servers[selectedServer])
                            .font(.system(size: 9, design: .monospaced))
                    }
                }
                .foregroundColor(.cyan)

                // مستوى الذكاء
                Button {
                    withAnimation { showIntelligence.toggle() }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 18))
                        Text("ذكاء \(Int((1.0 - intelligence) * 10) + 1)")
                            .font(.system(size: 9, design: .monospaced))
                    }
                }
                .foregroundColor(.orange)

                Spacer()

                Button { model.reload() } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 18))
                }
                .foregroundColor(.green)

                Button { model.goHome() } label: {
                    Image(systemName: "house")
                        .font(.system(size: 18))
                }
                .foregroundColor(.green)

                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18))
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(red: 0.07, green: 0.08, blue: 0.11))
        }
    }
}
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
