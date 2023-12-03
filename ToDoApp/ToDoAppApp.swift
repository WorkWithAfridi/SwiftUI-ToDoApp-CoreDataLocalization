import SwiftUI

@main
struct ToDoAppApp: App {
    var body: some Scene {
        WindowGroup {
            LandingView().environment(\.locale, .init(identifier: LanguageManager.shared.currentLanguage))
        }
    }
}
