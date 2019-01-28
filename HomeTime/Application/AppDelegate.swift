//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    //Try to fetch the token at the start of the application
    TokenLoader().loadToken { (token, error) in DataManager.shared.saveTokenLocally(token: token ?? "")}
    
    return true
  }

}
