//
//  ViewController.swift
//  Bananas
//
//  Created by Peter Tao on 10/4/16.
//  Copyright © 2016 Poetic Pete. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func buttonAction(_ sender: AnyObject) {
        FIRDatabase.database().reference().child("test").setValue(textField.text)

        
    }
    
    @IBAction func getInfoAction(_ sender: AnyObject) {
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
        
        req?.start(completionHandler: { (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                print("result \(result)")
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton.init()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

