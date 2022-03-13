import Foundation

class UserPasswordManager {
    //MARK: - properties
    static let shared = UserPasswordManager()
    
    //MARK: - private init
    private init() {}
    
    //MARK: - methods
    func savePassword(userPassword: UserPassword) {
        UserDefaults.standard.setValue(encodable: userPassword, forKey: UserDefaultsKeys.passwordKey)
    }
    
    func receiveUserPassword() -> UserPassword? {
        guard let model = UserDefaults.standard.loadValue(UserPassword.self, forKey: UserDefaultsKeys.passwordKey) else { return nil }
        return model
    }
}
