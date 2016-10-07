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

class ViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate {

    
    let loginButton = FBSDKLoginButton.init()
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func buttonAction(sender: AnyObject) {
//        FIRDatabase.database().reference().child("test").setValue(textField.text)
        loginButton.removeFromSuperview()
        let value:[String:AnyObject] = ["timestamp":FIRServerValue.timestamp(),"message":textField.text!]
        FIRDatabase.database().reference().child("test").childByAutoId().setValue(value)
        
        showMessages()
   
    }
    
    @IBAction func getInfoAction(sender: AnyObject) {
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            loginButton.removeFromSuperview()
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            return
        } else {
            loginButton.removeFromSuperview()
            loginButton.center = CGPoint(x: self.view.center.x, y: 30)
            self.view.addSubview(loginButton)
        }
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,first_name,last_name,picture,friends"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        req?.startWithCompletionHandler({ [weak self] connection, result, error in
            if(error == nil)
            {
                var info = ""
                print("result \(result)\n")
                info += result["id"] as! String
                info += "\n"
                info += result["first_name"] as! String
                info += result["last_name"] as! String
                
                
                print("\(result["id"] as! String)")
                print("\(result["first_name"] as! String)")
                print("\(result["last_name"] as! String)")
                self?.outputLabel.text = info
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let loginButton = FBSDKLoginButton.init()
        
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
 */
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        self.loginButton.delegate = self
        textField.delegate = self //set delegate to textfile
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        textField.borderStyle = UITextBorderStyle.Bezel
        textField.textColor = UIColor(white: 0.8, alpha: 1.0)
        self.view.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        showMessages()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        buttonAction(textField)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("why didn't you login?")
        }
        else {
            // Navigate to other view
            print("I am logged in!")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logged out")
    }

    func showMessages() {
        textField.text = ""
        FIRDatabase.database().reference().child("test").queryLimitedToLast(10).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var labelText = ""
            for child in snapshot.children {
                let c = child as! FIRDataSnapshot
                let valueC = c.value!["message"] as! String
                labelText += valueC
                labelText += "\n"
            }
            self.outputLabel.text = labelText
        })
    }

}

