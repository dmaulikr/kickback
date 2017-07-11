//
//  SearchAPIManager.swift
//  Kickback
//
//  Created by Katie Jiang on 7/11/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Alamofire

class SearchAPIManager {
    
    typealias JSON = [String: Any]
    
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
