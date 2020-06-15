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
import SwiftyJSON

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
            switch response.result {
            case .success(_):
                if let safeData = response.data {
                    print("success")
                    if let weather = self.parseJSONforWeather(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather.0, discomfortIndex: weather.1)
                    }
                }
            case .failure(let error):
                print("fail")
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func parseJSONforWeather(weatherData: Data) -> (WeatherModel, DiscomfortIndexModel)? {
        do {
            let json = try JSON(data: weatherData)
            let id = json["current"]["condition"]["code"].intValue
            let name = json["location"]["name"].stringValue
            let temp = json["current"]["temp_c"].doubleValue
            let humid = json["current"]["humidity"].intValue
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: temp, humidity: humid)
            let discomfortIndex = DiscomfortIndexModel(temperature: temp, humidity: humid)
            
            return (weather, discomfortIndex)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
