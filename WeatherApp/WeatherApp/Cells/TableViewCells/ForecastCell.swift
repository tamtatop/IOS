//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/27/21.
//

import UIKit
import SDWebImage

class ForecastCell: UITableViewCell {
    
    @IBOutlet var iconImg: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    private var imageURL = "https://openweathermap.org/img/wn/"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with threeHourForecast: ThreehForecast) {
        var hour = ""
        if threeHourForecast.hour < 10 {
            hour = "0"
        }
        titleLabel.text = hour + String(threeHourForecast.hour) + ":00"
        subtitleLabel.text = threeHourForecast.desciption
        temperatureLabel.text = threeHourForecast.temperature + "°C"
        iconImg.sd_setImage(with: URL(string: imageURL + threeHourForecast.icon + ".png"))
    }
    
}
