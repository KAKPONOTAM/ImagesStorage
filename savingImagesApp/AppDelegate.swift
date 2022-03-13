import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var rootViewController: UIViewController?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if let _ = UserPasswordManager.shared.receiveUserPassword() {
            rootViewController = LoginViewViewController()
            rootViewController?.view.backgroundColor = .white
        } else {
            rootViewController = AuthorizationViewController()
        }
        
        window?.rootViewController = rootViewController
        return true
    }
    
}


