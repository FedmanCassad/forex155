import UIKit
import ApphudSDK
import Amplitude
import OneSignal
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var mainController = MainTabBar()
    private lazy var coordinator = ForexAppCoordinator(window: window)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        Apphud.start(apiKey: "9117593163ba4bb7abf75a0a8d9aee41")
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
            
            OneSignal.initWithLaunchOptions(launchOptions)
            OneSignal.setAppId("SET")
            
            OneSignal.promptForPushNotifications(userResponse: { accepted in
              print("User accepted notifications: \(accepted)")
            })
        let externalUserId = randomString(of: 10)
          
            OneSignal.setExternalUserId(externalUserId, withSuccess: { results in
              print("External user id update complete with results: ", results!.description)
              if let pushResults = results!["push"] {
                print("Set external user id push status: ", pushResults)
              }
              if let emailResults = results!["email"] {
                print("Set external user id email status: ", emailResults)
              }
              if let smsResults = results!["sms"] {
                print("Set external user id sms status: ", smsResults)
              }
            }, withFailure: {error in
              print("Set external user id done with error: " + error.debugDescription)
            })
        coordinator.start()
        return true
    }
    
    private func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
          s.append(letters.randomElement()!)
        }
        return s
      }
}
