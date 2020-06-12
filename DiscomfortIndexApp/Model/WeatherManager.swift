//
//  WeatherManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/19.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel, discomfortIndex: DiscomfortIndexModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.weatherapi.com/v1/current.json?"
    let apiKey = APIKey()
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtude: CLLocationDegrees) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(latitude),\(longtude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        AF.request(urlString, method: .get).responseJSON { response in
            if let safeData = response.data {
                if let weather = self.parseJSONforWeather(weatherData: safeData).0, let di = self.parseJSONforWeather(weatherData: safeData).1 {
                    self.delegate?.didUpdateWeather(weatherManager: self, weather: weather, discomfortIndex: di)
                }
            } else {
                print("error")
            }
        }
    }
    
    func parseJSONforWeather(weatherData: Data) -> (WeatherModel?, DiscomfortIndexModel?) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.current.condition.code
            let name = decodedData.location.name
            let temp = decodedData.current.temp_c
            let humid = decodedData.current.humidity
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: temp, humidity: humid)
            let discomfortIndex = DiscomfortIndexModel(temperature: temp, humidity: humid)
            
            return (weather, discomfortIndex)
        } catch {
            delegate?.didFailWithError(error: error)
            return (nil, nil)
        }
    }
    
}
