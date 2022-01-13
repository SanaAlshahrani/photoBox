//Created by Sana Alshahrani on 19/04/1443 AH.

import UIKit


private let appleLanguagesKey = "AppleLanguages"

enum Language: String {
    
    case `default` = "_"
    case english = "en"
    case arabic = "ar"
    
    var semantic: UISemanticContentAttribute {
        switch self {
        case .default:
            return .unspecified
        case .arabic:
            return .forceRightToLeft
        default:
            return .forceLeftToRight
        }
    }
    
    var isRTL: Bool {
        switch self {
        case .arabic:
            return true
        default:
            return false
        }
    }
    
    static var current: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
                let language = Language(rawValue: languageCode) {
                return language
                
            } else {
                
                let preferredLanguage = NSLocale.preferredLanguages[0]
                let index = preferredLanguage.index(preferredLanguage.startIndex, offsetBy: 2)
                
                if let localization = Language(rawValue: preferredLanguage) {
                    return localization
                    
                } else if let localization = Language(rawValue: String(preferredLanguage[..<index])) {
                    return localization
                    
                } else {
                    return Language.english
                    
                }
                    
            }

        }
        
        set {
            guard current != newValue else { return }
            
            if newValue == .default {
                UserDefaults.standard.removeObject(forKey: appleLanguagesKey)
                UserDefaults.standard.synchronize()

            } else {
                // change language in the app
                // the language will be changed after restart
                UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
                UserDefaults.standard.synchronize()
                
            }
            
            //Changes semantic to all views
            //this hack needs in case of languages with different semantics: leftToRight(en/uk) & rightToLeft(ar)
            if newValue == .arabic {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UIImageView.appearance().semanticContentAttribute = .forceRightToLeft

            }else if newValue == .english{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UIImageView.appearance().semanticContentAttribute = .forceLeftToRight

            }
            
            //initialize the app from scratch
            //show initial view controller
            //so it seems like the is restarted
        }
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
        // return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized( _ args: CVarArg...) -> String {
        // return String.localizedStringWithFormat(self.localized, args)
        return String(format: self.localized, locale: Locale.current, arguments: args)
    }
    
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
