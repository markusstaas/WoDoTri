//
//  StravaAuthViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 12/11/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import OAuthSwift

class StravaAuthViewController: UIViewController {
    var oauthswift: OAuth2Swift!
    
     func login(){

    // Create OAuth Object
    self.oauthswift = OAuth2Swift(
        consumerKey:    "21913",
        consumerSecret: "a4bef18ded5104e4c6d00b37dfe40b2512b69730",
        authorizeUrl:   "https://www.strava.com/oauth/authorize",
        accessTokenUrl: "https://www.strava.com/oauth/token",
        responseType:   "code"
    )
    
        //oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
       
        oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/strava")!,
            scope: "write", state:"mystate",
            success: { credential, response, parameters in
                //print(credential.oauthToken)
                // Do your request
        },
            failure: { error in
                print(error.localizedDescription)
        }
        )
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()        // Do any additional setup after loading the view.
    }


}
