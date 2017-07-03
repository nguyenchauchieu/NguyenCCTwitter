//
//  ComposeTweetTableViewController.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/3/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet var tweetingTextField: UITextField!
    
    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            self.alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTweeted(_ sender: Any) {
        TwitterClient.sharedInstance?.tweeting(tweetContent: tweetingTextField.text!, success: { (tweet: Tweet) in
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            self.alertController.message = "Can not tweet !"
            self.present(self.alertController, animated: true, completion: nil)
        })
    }
}
