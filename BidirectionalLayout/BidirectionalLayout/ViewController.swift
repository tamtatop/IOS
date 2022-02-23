//
//  ViewController.swift
//  BidirectionalLayout
//
//  Created by Tamta Topuria on 12/18/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: "blueHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "blueHeader"
        )
        
        tableView.register(
            UINib(nibName: "redCell", bundle: nil),
            forCellReuseIdentifier: "redCell"
        )
        
        tableView.register(
            UINib(nibName: "collectionCell", bundle: nil),
            forCellReuseIdentifier: "collectionCell"
        )
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            return tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: "redCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "blueHeader")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    
    
}

