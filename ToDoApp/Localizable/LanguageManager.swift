import Foundation

class LanguageManager {
    static let shared = LanguageManager()

    private init() {}

    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "AppLanguage") ?? Locale.preferredLanguages.first ?? "en"
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.set(newValue, forKey: "AppLanguage")
            UserDefaults.standard.synchronize()
        }
    }
}
