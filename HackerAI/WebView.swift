import SwiftUI
import WebKit

/// مغلّف WKWebView يعرض واجهة الويب مباشرة مع شريط تقدّم وتحديث.
struct WebView: UIViewRepresentable {
    @ObservedObject var model: WebViewModel

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = nil // احتفظ بمعرّف المتصفح الافتراضي الصحيح

        model.webView = webView
        if let url = URL(string: model.homeURL) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(model: model)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let model: WebViewModel
        init(model: WebViewModel) { self.model = model }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            model.isLoading = true
            model.errorMessage = nil
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            model.isLoading = false
            model.canGoBack = webView.canGoBack
            model.canGoForward = webView.canGoForward
            model.currentURL = webView.url?.absoluteString ?? model.homeURL
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            model.isLoading = false
            model.errorMessage = error.localizedDescription
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            model.isLoading = false
            model.errorMessage = error.localizedDescription
        }
    }
}

/// حالة مشتركة بين SwiftUI والـ WebView.
final class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var currentURL = ""
    @Published var errorMessage: String?
    @Published var homeURL: String

    weak var webView: WKWebView?

    init(homeURL: String) {
        self.homeURL = homeURL
    }

    func reload() { webView?.reload() }
    func goBack() { webView?.goBack() }
    func goForward() { webView?.goForward() }
    func goHome() {
        if let url = URL(string: homeURL) {
            webView?.load(URLRequest(url: url))
        }
    }
}
