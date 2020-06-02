//
//  ForecastManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/08.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastManagerDelegate {
    func didUpdateForecast(weatherManager: ForecastManager, firstWeather: WeatherModel)
    func didFailWithError(error: Error)
}

struct ForecastManager {
    let weatherURL = "https://api.weatherapi.com/v1/forecast.json?days=2&"
    let apiKey = APIKey()

    var delegate: ForecastManagerDelegate?
    
    func fetchForecast(cityName: String) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchForecast(latitude: CLLocationDegrees, longtude: CLLocationDegrees) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(latitude),\(longtude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let firstWeather  = self.parseJSONforForecast(forecastData: safeData) {
                        self.delegate?.didUpdateForecast(weatherManager: self, firstWeather: firstWeather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONforForecast(forecastData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            let name = decodedData.location.name
            let date = decodedData.forecast.forecastday[1].date
            let sixAMWeatherId = decodedData.forecast.forecastday[1].hour[6].condition.code
            let sixAMTemperature = decodedData.forecast.forecastday[1].hour[6].temp_c
            
            let firstWeather = WeatherModel(conditionId: sixAMWeatherId, cityName: name, date: date, currentTemperature: sixAMTemperature, maxTemperature: 0.0, minTemperature: 0.0, avgTemperature: 0.0, humidity: 0)
            
            return firstWeather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
