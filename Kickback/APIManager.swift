//
//  APIManager.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/11/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var loginURL: URL?
    
    typealias JSON = [String: Any]
    
    func setup() {
        let clientID = "7d5032c6d7294aeb8a4fdc7662062655" // put your client ID here
        let redirectURL = "Kickback://returnAfterLogin" // put your direct URL here
        auth.clientID = clientID
        auth.redirectURL = URL(string: redirectURL)
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = auth.spotifyWebAuthenticationURL()
        print("Setup login URL: " + String(describing: loginURL))
    }
    
    func updateAfterFirstLogin() {
        let userDefaults = UserDefaults.standard
        if let sessionObject = userDefaults.object(forKey: "SpotifySession") {
            let sessionsDataObj = sessionObject as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionsDataObj) as? SPTSession
            session = firstTimeSession
//            if let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionsDataObj) as? SPTSession {
//                session = firstTimeSession
//            }
        }
    }
    
    func logout() {
        session = nil
    }
    
    func searchUsers(query: String, user: User?) -> [User] {
        let searchURL = "https://api.spotify.com/v1/users/ktjiang"
        var results: [User] = []
        Alamofire.request(searchURL).responseJSON { response in
            do {
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
                if let users = readableJSON["users"] as? JSON {
                    if let items = users["items"] as? [JSON] {
                        for i in 0..<items.count {
                            let item = items[i]
                            var dictionary: [String: Any] = [:]
                            dictionary["spotify_id"] = item["id"]
                            dictionary["name"] = item["name"]
                            
                            var status = item["product"] as! String
                            var premium: Bool
                            if status == "premium" {
                                premium = true
                            } else {
                                premium = false
                            }
                            dictionary["premium"] = premium

                            let user = User(dictionary)
                            results.append(user)
                            
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return results
    }

    
}
