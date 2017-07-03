//
//  ViewController.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 6/28/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        TwitterClient.sharedInstance?.login(success: { 
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
}

