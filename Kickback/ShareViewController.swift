//
//  ShareViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/19/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import QRCode

class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let accessCode = Queue.current!.accessCode
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        let qrCode = QRCode(accessCode)
        qrImage.image = qrCode?.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        codeButton.setTitle(accessCode, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapCode(_ sender: Any) {
        let shareSheet = UIActivityViewController(activityItems: [accessCode], applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = self.view
        shareSheet.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks, .postToFlickr, .postToVimeo, .postToWeibo, .postToTencentWeibo, .saveToCameraRoll, .print]
        self.present(shareSheet, animated: true, completion: nil)
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
            onTapCode(self)
        } else if indexPath.row == 2 {
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
