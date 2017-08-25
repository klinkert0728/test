//
//  BaseTableViewController.swift
//  test
//
//  Created by Daniel Klinkert Houfer on 8/24/17.
//  Copyright © 2017 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureAppearance() {
        
    }
    
    func registerCells() {
        tableView.register(UINib(nibName:"EmptyTableViewCell",bundle:nil), forCellReuseIdentifier: "EmptyTableViewCell")
    }
    
    func addPullToRefesh() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refesh), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    func refesh() {
        self.refreshControl?.endRefreshing()
        
    }
    

    
}


