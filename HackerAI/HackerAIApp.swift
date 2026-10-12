import SwiftUI

@main
struct HackerAIApp: App {
    @StateObject private var settings = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
