import UIKit
import SwiftyKeychainKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var rootViewController: UIViewController?
    let keychain = Keychain(service: "keychain.service")
    var window: UIWindow?
    let userPassword = UserPasswordManager.shared.receiveUserPassword()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        switch userPassword?.isEmpty {
        case true:
            rootViewController = AuthorizationViewController()
            
        case false:
            rootViewController = LoginViewViewController()
            rootViewController?.view.backgroundColor = .white
        case .none:
            debugPrint()
            
        case .some(_):
            debugPrint()
        }
        
        window?.rootViewController = rootViewController
        return true
    }
    
}


