import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: SettingsManager
    @StateObject private var model: WebViewModel
    @State private var showSettings = false

    init() {
        // سيتم تحديثه في onAppear من الإعدادات المحفوظة.
        _model = StateObject(wrappedValue: WebViewModel(homeURL: "https://chat.hackerai.co"))
    }

    init(homeURL: String) {
        _model = StateObject(wrappedValue: WebViewModel(homeURL: homeURL))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.06, blue: 0.09)
                    .ignoresSafeArea()

                WebView(model: model)
                    .ignoresSafeArea(edges: .bottom)

                if model.isLoading {
                    VStack {
                        ProgressView()
                            .tint(.green)
                            .scaleEffect(1.3)
                        Text("جارٍ التحميل...")
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
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
            }
            .navigationTitle(settings.appTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button { model.goBack() } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!model.canGoBack)

                    Button { model.goForward() } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!model.canGoForward)

                    Spacer()

                    Button { model.goHome() } label: {
                        Image(systemName: "house")
                    }

                    Spacer()

                    Button { model.reload() } label: {
                        Image(systemName: "arrow.clockwise")
                    }

                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .toolbarBackground(Color(red: 0.05, green: 0.06, blue: 0.09), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black.opacity(0.9), for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .tint(.green)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .preferredColorScheme(.dark)
            .onAppear {
                // مزامنة الرابط المحفوظ مع الـ WebView عند أول ظهور.
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
    }
}
