//
//  APIManager.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/11/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation

class APIManager {
    var auth = SPTAuth.defaultInstance()!
    
//    var session:SPTSession!
//    var player: SPTAudioStreamingController?
    
    var loginUrl: URL?
    
    func setup() {
      
        SPTAuth.defaultInstance().clientID = "7d5032c6d7294aeb8a4fdc7662062655"
        SPTAuth.defaultInstance().redirectURL = URL(string: "Kickback://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    func login() {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
}
