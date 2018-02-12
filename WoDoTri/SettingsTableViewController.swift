//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit
import OAuthSwift

final class SettingsTableViewController: UITableViewController {

    private var oauthswift: OAuth2Swift!
    private let defaults = UserDefaults.standard
    @IBOutlet private weak var stravaSwitch: UISwitch!

    @IBAction private func stravaSwitchToggled(_ sender: Any) {
        if stravaSwitch.isOn {
            // Create OAuth Object
            self.oauthswift = OAuth2Swift(
                consumerKey: "21913",
                consumerSecret: "a4bef18ded5104e4c6d00b37dfe40b2512b69730",
                authorizeUrl: "https://www.strava.com/oauth/authorize",
                accessTokenUrl: "https://www.strava.com/oauth/token",
                responseType: "code"
            )

            oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

            oauthswift.authorize(
                withCallbackURL: URL(string: "com.starkusmaas.WoDoTri://oauth-callback/strava")!,
                scope: "write",
                state: "mystate",
                success: { credential, _, _ in
                    print(credential.oauthToken)
                    self.defaults.set(true, forKey: "ShareWithStrava")
                    self.defaults.set(credential.oauthToken, forKey: "StravaToken")
                    self.stravaSwitch.isOn = true
            },
                failure: { error in
                    print(error.localizedDescription)
            }
            )

        } else {
            defaults.set(false, forKey: "ShareWithStrava")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareWithStrava = defaults.bool(forKey: "ShareWithStrava")
        if  shareWithStrava == true {
            stravaSwitch.isOn = true
        } else {
            stravaSwitch.isOn = false
        }
    }

}
