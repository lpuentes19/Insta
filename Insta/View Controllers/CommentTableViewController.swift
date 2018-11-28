//
//  CommentTableViewController.swift
//  Insta
//
//  Created by Luis Puentes on 11/28/18.
//  Copyright © 2018 LuisPuentes. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        return cell
    }
}
