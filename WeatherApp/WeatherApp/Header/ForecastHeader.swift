//
//  ForecastHeader.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/28/21.
//

import UIKit

class ForecastHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with weekDay: String){
        dayLabel.text = weekDay
    }
    
}
