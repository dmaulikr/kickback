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
    
    func createUser() -> User {
        let searchURL = "https://api.spotify.com/v1/me"
        var results: [User] = []
        Alamofire.request(searchURL).responseJSON { response in
            do {
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
                if let user = readableJSON["user"] as? JSON {
                    var dictionary: [String: Any] = [:]
                    dictionary["spotify_id"] = user["id"]
                    dictionary["name"] = user["display_name"]
                    let status = user["product"] as! String
                    dictionary["premium"] = status == "premium"
                    let user = User(dictionary)
                    results.append(user)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return results[0]
    }
    
    func searchTracks(query: String, user: User?) -> [Track] {
        let editedQuery = query.replacingOccurrences(of: " ", with: "+")
        let searchURL = "https://api.spotify.com/v1/search?q=\(editedQuery)&type=track"
        var results: [Track] = []
        Alamofire.request(searchURL).responseJSON { response in
            do {
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
                if let tracks = readableJSON["tracks"] as? JSON {
                    if let items = tracks["items"] as? [JSON] {
                        for i in 0..<items.count {
                            let item = items[i]
                            var dictionary: [String: Any] = [:]
                            dictionary["id"] = item["id"]
                            dictionary["name"] = item["name"]
                            let album = dictionary["album"] as! JSON
                            dictionary["albumID"] = album["id"]
                            let artist = dictionary["artist"] as! JSON
                            dictionary["artistID"] = artist["id"]
                            dictionary["user"] = user
                            let track = Track(dictionary)
                            results.append(track)
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
