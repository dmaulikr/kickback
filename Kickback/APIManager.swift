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
    typealias JSON = [String: Any]
    var auth: SPTAuth
    var session: SPTSession!
    var loginURL: URL?
    
    private static var _current: APIManager?
    
    static var current: APIManager? {
        get {
            if _current == nil {
                // check if there is a stored session; if so, regenerate an API manager from that session
                let defaults = UserDefaults.standard
                if let sessionObject = defaults.object(forKey: "currentSPTSession") {
                    let sessionData = sessionObject as! Data
                    let session = NSKeyedUnarchiver.unarchiveObject(with: sessionData) as! SPTSession
                    _current = APIManager(session: session)
                }
            }
            return _current
        }
        set (manager) {
            _current = manager
            if let manager = manager {
                // store the session data
                if let session = manager.session {
                    let defaults = UserDefaults.standard
                    let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                    defaults.set(sessionData, forKey: "currentSPTSession")
                    defaults.synchronize()
                }
            }
        }
    }
    
    init() {
        self.auth = SPTAuth.defaultInstance()!
        self.auth.clientID = "7d5032c6d7294aeb8a4fdc7662062655" // put your client ID here
        self.auth.redirectURL = URL(string: "Kickback://returnAfterLogin") // put your direct URL here
        self.auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistModifyPrivateScope]
        self.auth.sessionUserDefaultsKey = "currentSPTSession" // user defaults key to automatically save the session when it changes
        self.loginURL = auth.spotifyWebAuthenticationURL()
    }
    
    init(session: SPTSession) {
        self.auth = SPTAuth.defaultInstance()!
        self.auth.clientID = "7d5032c6d7294aeb8a4fdc7662062655" // put your client ID here
        self.auth.redirectURL = URL(string: "Kickback://returnAfterLogin") // put your direct URL here
        self.auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistModifyPrivateScope]
        self.loginURL = auth.spotifyWebAuthenticationURL()
        self.session = session
    }
    
    func createUser() {
        SPTUser.requestCurrentUser(withAccessToken: session.accessToken, callback: { (error: Error?, response: Any?) in
            if let error = error {
                print("Error requesting in createUser(): \(error.localizedDescription)")
            } else {
                let spotifyUser = response as! SPTUser
                var dictionary: [String: Any] = [:]
                dictionary["id"] = spotifyUser.canonicalUserName
                dictionary["name"] = spotifyUser.displayName
                dictionary["profileImageURL"] = spotifyUser.smallestImage.imageURL.absoluteString
                let status = spotifyUser.product
                dictionary["premium"] = status == SPTProduct.premium
                let user = User(dictionary)
                User.current = user 
            }
        })
    }
    
    func searchTracks(query: String, user: User?) -> [Track] {
        var results: [Track] = []
        let urlRequest = try! SPTSearch.createRequestForSearch(withQuery: query, queryType: .queryTypeTrack, accessToken: session.accessToken)
        print("request went through")
        Alamofire.request(urlRequest).responseJSON { (response) in
            do {
                print("inside alamofire")
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: Any]
                if let tracks = readableJSON["tracks"] as? JSON {
                    if let items = tracks["items"] as? [JSON] {
                        for i in 0..<items.count {
                            let item = items[i]
                            var dictionary: [String: Any] = [:]
                            dictionary["id"] = item["id"]
                            dictionary["name"] = item["name"]
                            dictionary["album"] =  item["album"] as! JSON
                            dictionary["artists"] = item["artists"] as! [JSON]
                            dictionary["user"] = user
                            let track = Track(dictionary)
                            results.append(track)
                            print(results)
                            print("end of alamofire")
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        print("Results: \(results)")
        return results
        //print(results)
    }
    
}
