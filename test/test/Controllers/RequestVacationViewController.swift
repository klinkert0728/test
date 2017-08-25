//
//  RequestVacationViewController.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import RealmSwift

class RequestVacationViewController: BaseViewController {

    @IBOutlet weak var approveVacation: UIButton!
    
    var reloadClosure:(()->())?
    var request:Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        
        if !User.isAdmin {
            approveVacation.isHidden = true
        }else {
            approveVacation.isHidden = false
        }
    }
    
    @IBAction func aproveVacationAction(_ sender: Any) {
        guard let current  = request, !current.approved else {
            return
        }
        
        Realm.update { (realm) in
           current.approved = true
        }
        
        reloadClosure?()
        
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
