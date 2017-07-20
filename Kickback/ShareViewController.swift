//
//  ShareViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/19/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var codeButton: UIButton!
    
    let accessCode = Queue.current!.accessCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
