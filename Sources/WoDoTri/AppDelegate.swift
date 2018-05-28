//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import CoreData
import OAuthSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_

        app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.host == "oauth-callback" {
            OAuthSwift.handle(url: url)
        } else {
        }
        return true
    }

    func application(

        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }
}
