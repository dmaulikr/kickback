//
//  QRPopupViewController.swift
//  Kickback
//
//  Created by Katie Jiang on 7/25/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit

class QRPopupViewController: UIViewController {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var qrImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        qrView.layer.cornerRadius = 5
        qrView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
