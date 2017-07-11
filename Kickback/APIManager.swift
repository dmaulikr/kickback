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
    
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    
    var loginURL: URL?
    
    func setup() {
        let clientID = "7d5032c6d7294aeb8a4fdc7662062655" // put your client ID here
        let redirectURL = "Kickback://returnAfterLogin" // put your direct URL here
        auth.clientID = clientID
        auth.redirectURL = URL(string: redirectURL)
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginURL = auth.spotifyWebAuthenticationURL()
        print("Setup login URL: " + String(describing: loginURL))
    }
        
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
//            self.player!.playbackDelegate = self as! SPTAudioStreamingPlaybackDelegate
//            self.player!.delegate = self as! SPTAudioStreamingDelegate
//            try! player!.start(withClientId: auth.clientID)
//            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
//    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
//        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
//        print("logged in")
//        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
//            if (error != nil) {
//                print("playing!")
//            }
//        })
//    }
    
}
