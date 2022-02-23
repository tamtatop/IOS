//
//  Forecast.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/26/21.
//

import Foundation

// temp
// icon
// hour
// day
// desc

// Parsing struct

struct ForecastResponse: Codable {
    let list: [ForecastFor3Hours]
}

struct ForecastFor3Hours: Codable {
    let main: Temperature
    let weather: [Details]
    let dt_txt: String
}

struct Temperature: Codable {
    let temp: Double
}

struct Details: Codable {
    let description: String
    let icon: String
}

// Usable struct

struct Forecast {
    init?(resp: ForecastResponse){
        var allForc = [WeekForecast]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var i = 0
        var lastDay = -1
        var myWeek = [ThreehForecast]()
        for forc in resp.list {
            guard let date = dateFormatter.date(from: forc.dt_txt) else { return nil }
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            let hour = myCalendar.component(.hour, from: date)
            let myForc = ThreehForecast(forc: forc, hourTime: hour)
            myWeek.append(myForc)
            if i == 0 {
                lastDay = weekDay
            }
            if weekDay != lastDay {
                allForc.append(WeekForecast(weekDay: weekDays[lastDay-1], week: myWeek))
                myWeek.removeAll()
                lastDay = weekDay
            }
            i += 1
        }
        forecast = allForc
//        size = resp.list.count
    }
    let forecast: [WeekForecast]
//    let size: Int
}

struct WeekForecast {
    init(weekDay: String, week: [ThreehForecast]){
        day = weekDay.uppercased()
        weekForecast = week
    }
    let day: String
    let weekForecast: [ThreehForecast]
}

struct ThreehForecast {
    init(forc: ForecastFor3Hours, hourTime: Int){
        temperature = String(round((forc.main.temp - 273.15)*10)/10)
        icon = forc.weather[0].icon
        hour = hourTime
        desciption = forc.weather[0].description
    }
    let temperature: String
    let icon: String
    let hour: Int
    let desciption: String
}

let weekDays: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

//func fromParsedToUsable(resp: ForecastResponse){
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    var i = 0
//    var lastDay = -1
//
//    for forc in resp.list {
////        var my3hForc = ThreehForecast()
//        guard let date = dateFormatter.date(from: forc.dt_txt) else { return }
//        let myCalendar = Calendar(identifier: .gregorian)
//        let weekDay = myCalendar.component(.weekday, from: date)
//        if weekDay != lastDay{
//            lastDay = weekDay
//        }
//        let hour = myCalendar.component(.hour, from: date)
//        i += 1
//    }
//}
