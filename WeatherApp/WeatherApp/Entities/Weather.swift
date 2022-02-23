//
//  Weather.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/26/21.
//

import Foundation

// cloudiness
// humidity
// wind speed
// wind direction
// city
// country
// icon
// temperature
// description

// Parsing struct

struct WeatherResponse: Codable {
    let weather: [Desc]
    let main: MainInfo
    let wind: WindInfo
    let clouds: Cloudiness
    let sys: Country
    let name: String
}

struct Desc: Codable {
    let main: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Double
    let humidity: Int
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}

struct Cloudiness: Codable {
    let all: Int
}

struct Country: Codable {
    let country: String
}

// Usable struct

struct Weather {
    init(resp: WeatherResponse){
        icon = resp.weather[0].icon
        location = Location(resp: resp)
        temperature = round((resp.main.temp - 273.15)*10)/10
        description = resp.weather[0].main
        cloudinessPerc = resp.clouds.all
        humidityMM = resp.main.humidity
        wind = Wind(windResp: resp.wind)
    }
    let icon: String
    let location: Location
    let temperature: Double
    let description: String
    let cloudinessPerc: Int
    let humidityMM: Int
    let wind: Wind
}

struct Wind {
    init(windResp: WindInfo) {
        speed = windResp.speed
        direction = getDirection(degree: windResp.deg)
    }
    let speed: Double
    let direction: String
}

struct Location {
    init(resp: WeatherResponse){
        city = resp.name
        country = resp.sys.country
    }
    let city: String
    let country: String
}

private func getDirection(degree: Int) -> String{
    if 45...135 ~= degree { return "N" }
    if 136...225 ~= degree { return "W" }
    if 226...315 ~= degree { return "S" }
    if degree < 45 || degree > 315 { return "E" }
    return "INVALID"
}


