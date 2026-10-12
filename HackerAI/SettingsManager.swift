import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    /// رابط الواجهة التي سيفتحها التطبيق.
    @Published var homeURL: String = "https://chat.hackerai.co"
    /// اسم يظهر في الشريط العلوي (اختياري).
    @Published var appTitle: String = "HackerAI"

    private let homeURLKey = "hackerai_homeURL"
    private let appTitleKey = "hackerai_appTitle"

    init() {
        load()
    }

    func load() {
        homeURL = UserDefaults.standard.string(forKey: homeURLKey) ?? "https://chat.hackerai.co"
        appTitle = UserDefaults.standard.string(forKey: appTitleKey) ?? "HackerAI"
    }

    func save() {
        UserDefaults.standard.set(homeURL, forKey: homeURLKey)
        UserDefaults.standard.set(appTitle, forKey: appTitleKey)
    }

    func reset() {
        homeURL = "https://chat.hackerai.co"
        appTitle = "HackerAI"
        save()
    }
}
