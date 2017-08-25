//
//  LoginViewController.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginClosure:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = usernameTextField.text, let password = passwordTextField.text, password.characters.count > 5 && isEmailFormat(email:email) else {
            SVProgressHUD.showInfo(withStatus: "Please enter ")
            return
        }
        
        Realm.update { (realm) in
            
            if realm.objects(User.self).count == 0 {
                if email == "admin@email.com" {
                    let admin = User()
                    admin.token = "1234abc"
                    admin.type  = "Admin"
                    admin.uuid  = "0000"
                    admin.email = "admin@email.com"
                    realm.add(admin)
                }else if email == "user@email.com" {
                    let user = User()
                    user.token = "abc12345"
                    user.type  = "User"
                    user.uuid  = "1111"
                    user.email = "user@email.com"
                    realm.add(user)
                }
            }
        }
        
        loginClosure?()
    }
    
    
    
    private func isEmailFormat(email:String) -> Bool {
        return true
    }
    
    
}
