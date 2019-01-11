//
//  ViewController.swift
//  InspeeroLibDemo
//
//  Created by Bhavesh Sarwar on 09/01/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let tableData = [["title":"In App Purchase","segue":"InAppPurchase"],
                     ["title":"Xmpp Client","segue":"xmppClient"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tableData[indexPath.row]["title"] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: tableData[indexPath.row]["segue"] as! String, sender: self)
    }
    
    
}
