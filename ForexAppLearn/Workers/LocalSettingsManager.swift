import Foundation

final class UserLocalSettings {
    enum UDKeys: String {
        case user, didShowOnboarding, selectedCountry, seed
    }
    
    static var selectedCountry: CountryModel {
        get {
            guard let value: Data = getValue(for: .selectedCountry),
                  let country = try? JSONDecoder().decode(CountryModel.self, from: value) else {
                return CountryModel.allCountries[0]
            }
            return country
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            setValue(value: data, for: .selectedCountry)
        }
    }
    
    static var user: User? {
        get {
            guard let value: Data = getValue(for: .user),
                  let user = try? JSONDecoder().decode(User.self, from: value) else {
                return nil
            }
            return user
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            setValue(value: data, for: .user)
        }
    }
    
    static var didShowOnboarding: Bool {
        get {
            guard let value: Bool = getValue(for: .didShowOnboarding) else {
                return false
            }
            return value
        }
        set {
            setValue(value: newValue, for: .didShowOnboarding)
        }
    }
    
    private static func setValue<T>(value: T, for key: UDKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func getValue<T>(for key: UDKeys) -> T? {
        UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
