import Foundation
import SwiftyKeychainKit

class UserPasswordManager {
    //MARK: - properties
    static let shared = UserPasswordManager()
    let keychain = Keychain(service: "keychain.service")
    
    //MARK: - private init
    private init() {}
    
    //MARK: - methods
    func savePassword(userPassword: String) {
        do {
            try keychain.set(userPassword, for: KeychainKeys.passwordKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func receiveUserPassword() -> String? {
        guard let userPassword = try? keychain.get(KeychainKeys.passwordKey) else { return "" }
        return userPassword
    }
}
