//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/30/21.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cloudinessLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var weatherView: UIView!
    @IBOutlet var detailsView: UIView!
    
    private var imageURL = "https://openweathermap.org/img/wn/"
    
    private var order: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with weather: Weather, order: Int) {
        weatherImg.sd_setImage(with: URL(string: imageURL + weather.icon + ".png"))
        locationLabel.text = weather.location.city + ", " + countryName(countryCode: weather.location.country)
        descriptionLabel.text = String(weather.temperature) + "°C" + " | " + weather.description
        cloudinessLabel.text = String(weather.cloudinessPerc) + " %"
        humidityLabel.text = String(weather.humidityMM) + " mm"
        windSpeedLabel.text = String(weather.wind.speed) + " km/h"
        windDirectionLabel.text = weather.wind.direction
        containerView.backgroundColor = carouselColors[order % carouselColors.count]
        weatherView.backgroundColor = carouselColors[order % carouselColors.count]
        detailsView.backgroundColor = carouselColors[order % carouselColors.count]
    }
    
    private func countryName(countryCode: String) -> String {
        let current = Locale(identifier: "en_US")
        if let country = current.localizedString(forRegionCode: countryCode) {
            return country
        } else { return countryCode }
    }
    
    // Constants
    let carouselColors = [UIColor.init(named: "blue-gradient-end"),
                          UIColor.init(named: "green-gradient-end"),
                          UIColor.init(named: "ochre-gradient-end"),
                          UIColor.init(named: "blue-gradient-start"),
                          UIColor.init(named: "green-gradient-start"),
                          UIColor.init(named: "ochre-gradient-start")
    ]

}
