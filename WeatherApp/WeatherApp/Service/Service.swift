//
//  Service.swift
//  WeatherApp
//
//  Created by Tamta Topuria on 1/25/21.
//

import Foundation

class Service {
    
    private let apiKey = "eca27f4cf8bf552aadc27c031205eb9d"
    private var components = URLComponents()
    
    init(){
        components.scheme = "https"
        components.host = "api.openweathermap.org"
//        components.path = "/data/2.5"
    }
    
    private func addParameters(for city: String){
        let parameters = [
            "q": city.description,
            "appid": apiKey.description
        ]
        
        components.queryItems = parameters.map{ key, value in
            return URLQueryItem(name: key, value: value)
        }
    }
    
    private func addParameters(lat: Double, lon: Double) {
        let parameters = [
            "lat": lat.description,
            "lon": lon.description,
            "appid": apiKey.description
        ]
        
        components.queryItems = parameters.map{ key, value in
            return URLQueryItem(name: key, value: value)
        }
    }
    
    private func loadCurrWeatherData(completion: @escaping (Result<WeatherResponse, ServiceError>) -> ()){
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(.failure(ServiceError.HttpLayerError))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(WeatherResponse.self, from: data)
//                        print(result)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ServiceError.parsingError))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
                
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
        
    }
    
    func get5DayForecast(for city: String, completion: @escaping (Result<ForecastResponse, ServiceError>) -> ()){
        components.path = "/data/2.5/forecast"
        addParameters(for: city)
        
        if let url = components.url {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(.failure(ServiceError.HttpLayerError))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ForecastResponse.self, from: data)
//                        print(result)
                        completion(.success(result))
                    } catch {
                        completion(.failure(ServiceError.parsingError))
                    }
                } else {
                    completion(.failure(ServiceError.noData))
                }
                
            })
            task.resume()
        } else {
            completion(.failure(ServiceError.invalidParameters))
        }
        
    }
    
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, ServiceError>) -> ()){
        components.path = "/data/2.5/weather"
        addParameters(lat: lat, lon: lon)
        
        loadCurrWeatherData(completion: completion)
    }
    
    func getCurrentWeather(for city: String, completion: @escaping (Result<WeatherResponse, ServiceError>) -> ()){
        components.path = "/data/2.5/weather"
        addParameters(for: city)
        
        loadCurrWeatherData(completion: completion)
    }
    
}

enum ServiceError: String, Error {
    case noData = "No Data was found, contact us about this error"
    case invalidParameters = "invalid Parameters error, Contact us about this error"
    case HttpLayerError = "HttpLayerError Occured, check your connection, try reloading"
    case parsingError = "City with that name wasn't found"
}
