//
//  History.swift
//  LatePass
//
//  Created by alden lamp on 4/22/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class History: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var tableView: UITableView!
    
    var history: [[String : Any]] = [[String : Any]]()
    
    func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        if let his = data["history"] as? [[String : Any]]{
            history = his
        }
        
        super.viewDidLoad()
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        gesture.direction = .right
        self.view.addGestureRecognizer(gesture)
        
        tableView.backgroundColor = UIColor.clear
        
        tableView.delegate = self
        tableView.dataSource = self
        print(history)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(history.count)
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        cell.reason.text = history[indexPath.row]["reason"]! as! String
        cell.date.text = "\(history[indexPath.row]["date"] as! String) \(history[indexPath.row]["time"] as! String)"
        cell.status.text = history[indexPath.row]["status"] as! Bool ? "Accepted" : "Rejected"
        cell.title.text = "\(history[indexPath.row]["from"] as! String) to \(history[indexPath.row]["to"] as! String)"
        cell.title.adjustsFontSizeToFitWidth = true
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}


class customCell: UITableViewCell{
    
    @IBOutlet var reason: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var date: UILabel!
    
}
