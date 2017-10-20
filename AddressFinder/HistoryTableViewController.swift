//
//  HistoryTableViewController.swift
//  AddressFinder
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var model = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        model.getMediaHistory()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Initial history count: \(model.mediaDB.count)")
//        model.deleteAllHistory()
//        print("Now the history count is: \(model.mediaDB.count)")
        
//        return model.mediaDB.count
        // Too complicated to do!
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        let media = model.getMedia(indexPath)
        
        cell?.textLabel?.text = (media.name as! NSString) as String
        
        return cell!
    }
}
