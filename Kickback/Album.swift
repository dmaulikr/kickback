//
//  Album.swift
//  Kickback
//
//  Created by Daniel Afolabi on 7/21/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import Foundation
import Parse

class Album {
    
    // Properties
    var dictionary: [String: Any]
    
    var id: String {
        get {
            return dictionary["id"] as! String
        }
        set (id) {
            dictionary["id"] = id
        }
    }
    var name: String {
        get {
            return dictionary["name"] as! String
        }
        set (name) {
            dictionary["name"] = name
        }
    }
    var images: [[String: Any]] {
        get {
            return dictionary["images"] as! [[String: Any]]
        }
        set (album) {
            dictionary["images"] = album
        }
    }
    
    var artists: [[String: Any]] {
        get {
            return dictionary["artists"] as! [[String: Any]]
        }
        set (artists) {
            dictionary["artists"] = artists
        }
    }
    var userId: String? {
        get {
            return dictionary["userId"] as? String
        }
        set (userId) {
            dictionary["userId"] = userId
        }
    }
    var uri: String {
        get {
            return dictionary["uri"] as! String
        }
        set (uri) {
            dictionary["uri"] = uri
        }
    }
    
    var albumType: String {
        get {
            return dictionary["album_type"] as! String
        }
        set (albumType) {
            dictionary["album_type"] = albumType
        }
    }
    var availableMarkets: [String] {
        get {
            return dictionary["available_markets"] as! [String]
        }
        set (availableMarkets) {
            dictionary["available_markets"] = availableMarkets
        }
    }
    var externalURLS: [[String: Any]] {
        get {
            return dictionary["external_urls"] as! [[String: Any]]
        }
        set (externalURLS) {
            dictionary["external_urls"] = externalURLS
        }
    }
    var href: String {
        get {
            return dictionary["href"] as! String
        }
        set (href) {
            dictionary["href"] = href
        }
    }
    var type: String {
        get {
            return dictionary["type"] as! String
        }
        set (type) {
            dictionary["type"] = type
        }
    }
    
    init(_ dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
}
