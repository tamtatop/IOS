//
//  ViewController.swift
//  BurgerMenu
//
//  Created by Tamta Topuria on 12/10/20.
//

import UIKit

class BurgerMenu {
    var headerModel: BurgerHeaderModel!
    var cells = [BurgerCellModel]()
    
    var numberOfRows: Int {
        return headerModel.isExpanded ? cells.count : 0
    }
    
    init(headerModel: BurgerHeaderModel?, cells: [BurgerCellModel]){
        self.headerModel = headerModel
        self.cells = cells
    }
}

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private var burgerMenu: BurgerMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        createBurgerMenu()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BurgerCell", bundle: nil), forCellReuseIdentifier: "BurgerCell")
        tableView.register(UINib(nibName: "BurgerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "BurgerHeader")
    }
    
    func createBurgerMenu(){
        burgerMenu = BurgerMenu(
            headerModel: BurgerHeaderModel(isExpanded: false, delegate: self),
            cells: [
                BurgerCellModel(title: "about us"),
                BurgerCellModel(title: "products"),
                BurgerCellModel(title: "media"),
                BurgerCellModel(title: "contact us")
            ]
        )
    }
}

extension ViewController: BurgerHeaderDelegate {
    func burgerHeaderDidClickButton(_ header: BurgerHeader) {
        if burgerMenu.headerModel.isExpanded {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .bottom)
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.tableView.backgroundColor = .systemGray2
//                    self.tableView.alpha = 0.4
                }
            )
        } else {
            UIView.animate(
                withDuration: 0.25,
                animations: {
                    self.tableView.backgroundColor = .white
//                    self.tableView.alpha = 1
                }
            )
            self.tableView.reloadSections(IndexSet(integer: 1), with: .top)
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : burgerMenu.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BurgerHeader")
            if let burgerHeader  = header as? BurgerHeader {
                burgerHeader.configure(with: burgerMenu.headerModel!)
            }
            return header
        } else { return UIView() }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BurgerCell", for: indexPath)
        
        if let burgerCell = cell as? BurgerCell {
            burgerCell.configure(with: burgerMenu.cells[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? .leastNormalMagnitude : 66
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }


    func tableView (_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}

