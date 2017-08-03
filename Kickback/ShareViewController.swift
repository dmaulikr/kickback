//
//  ShareViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/19/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import QRCode
import PopupDialog
import Parse

class ShareViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var accessCodeLabel: UILabel!
    
    var members: [String] = []
    let accessCode = Queue.current!.accessCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCodeLabel.text = accessCode
        members = Queue.current!.members
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        for button in [searchButton, shareButton, scanButton] {
            button!.layer.cornerRadius = button!.frame.height / 2
            button!.layer.masksToBounds = true
            button!.clipsToBounds = true
        }

        self.navigationController?.title = "Share"
        self.navigationController?.navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Queue.current!.updateFromParse {
            self.members = Queue.current!.members
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: Any) {
        performSegue(withIdentifier: "addFriendsSegue", sender: self)
    }
    
    @IBAction func onShare(_ sender: Any) {
        let shareSheet = UIActivityViewController(activityItems: [accessCode], applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = self.view
        shareSheet.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks, .postToFlickr, .postToVimeo, .postToWeibo, .postToTencentWeibo, .saveToCameraRoll, .print]
        self.present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction func onScan(_ sender: Any) {
        let title = "Share QR Code"
        let image = QRCode(accessCode)?.image
        let popup = PopupDialog(title: title, message: nil, image: image, buttonAlignment: .vertical, transitionStyle: .bounceUp, gestureDismissal: true, completion: {
            Queue.current!.updateFromParse {
                self.members = Queue.current!.members
                self.collectionView.reloadData()
            }
        })
        self.present(popup, animated: true, completion: nil)
    }
    
    
    @IBAction func changeSelectedColor(_ sender: Any) {
        let button = sender as! UIButton
        button.alpha = 0.1
    }
    
    @IBAction func changeNormalColor(_ sender: Any) {
        let button = sender as! UIButton
        button.alpha = 0.25
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        let memberId = members[indexPath.row]
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.clipsToBounds = true
        let parseUser = try! PFQuery(className: "SPTUser").whereKey("id", equalTo: memberId).getFirstObject()
        if let url = parseUser["profileImageURL"] {
            cell.profileImage.af_setImage(withURL: URL(string: url as! String)!)
        }
        let name = parseUser["name"] as! String
        cell.usernameLabel.text = name != "" ? name : parseUser["id"] as! String
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
