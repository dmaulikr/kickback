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

class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var members: [String]!
    let accessCode = Queue.current!.accessCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        members = Queue.current!.members
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func onTapCode() {
        let shareSheet = UIActivityViewController(activityItems: [accessCode], applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = self.view
        shareSheet.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks, .postToFlickr, .postToVimeo, .postToWeibo, .postToTencentWeibo, .saveToCameraRoll, .print]
        self.present(shareSheet, animated: true, completion: nil)
    }
    
    // MARK: - Popup dialog
    
    func onShareQR() {
        let title = "Share QR Code"
        let image = QRCode(accessCode)?.image
        let popup = PopupDialog(title: title, message: nil, image: image, buttonAlignment: .vertical, transitionStyle: .bounceUp, gestureDismissal: true, completion: nil)
        self.present(popup, animated: true, completion: nil)
    }
    
    // MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell") as! ShareCell
        switch indexPath.row {
        case 0:
            cell.shareLabel.text = "Add friends by username"
        case 1:
            cell.shareLabel.text = "Share playlist code: \(accessCode)"
        case 2:
            cell.shareLabel.text = "Scan QR code"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "addFriendsSegue", sender: self)
        } else if indexPath.row == 1 {
            onTapCode()
        } else if indexPath.row == 2 {
            onShareQR()
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
