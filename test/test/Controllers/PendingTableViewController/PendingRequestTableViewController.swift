//
//  PendingRequestTableViewController.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift
import ObjectMapper

class PendingRequestTableViewController: BaseTableViewController {
    
    
    var pendingRequest = [Request]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.register(UINib(nibName: "PendingRequestsTableViewCell", bundle: nil), forCellReuseIdentifier: "PendingRequestsTableViewCell")
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        addPullToRefesh()
        if User.isAdmin {
            self.navigationItem.rightBarButtonItem = nil
        }
        tableView.tableHeaderView       = refreshControl
        tableView.tableFooterView       = UIView()
        tableView.estimatedRowHeight    = 60
        tableView.rowHeight             = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.isLoggedIn {
            let loginNavigation = Navigation.loginNavigationController()
            let loginVC         = loginNavigation.topViewController as? LoginViewController
            
            loginVC?.loginClosure = {
                self.dismiss(animated: true, completion: nil)
                self.getPendingRequest()
            }
            present(loginNavigation, animated: true, completion: nil)
        }else {
            getPendingRequest()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pendingRequest.count == 0 ? 1:pendingRequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pendingRequest.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PendingRequestsTableViewCell", for: indexPath) as! PendingRequestsTableViewCell
            
            
            cell.setupCell(request: pendingRequest[indexPath.row])
            // Configure the cell...
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            
            if !User.isAdmin {
                cell.setupCell(message: "Please Add a request")
            }else {
                cell.setupCell(message: "You do not have pending request :)")
            }
            
            return cell
        }
    }
    
    
    
    private func getPendingRequest() {
        Request.getAllRequest(endPoint: EndPoint.getRequest(), successClosure: { (requests) in
            self.pendingRequest = requests
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.show(withStatus: error)
        }
        
    }
    
    
    //MARK:Refresh Request
    
    override func refesh() {
        super.refesh()
        
        getPendingRequest()
    }
    
    
    //    private func populatePredefinedData() {
    //        Realm.update { (realm) in
    //            if realm.objects(Request.self).count == 0 {
    //                if let activities = self.adddPredefinedData() {
    //                    let activitiesArray = Mapper<Request>().mapArray(JSONArray: activities)
    //                    realm.add(activitiesArray)
    //                }
    //            }
    //        }
    //    }
    //
    //    private func adddPredefinedData() -> [[String:Any]]? {
    //        if let path = Bundle.main.path(forResource: "activities", ofType: nil) {
    //            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
    //            guard let activitiesData = data else {
    //                return [[:]]
    //            }
    //            let json = try? JSONSerialization.jsonObject(with: activitiesData, options: [])
    //            if let jsonArray = json as? [[String:Any]] {
    //                return jsonArray
    //            }
    //        }
    //        return [[:]]
    //    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
