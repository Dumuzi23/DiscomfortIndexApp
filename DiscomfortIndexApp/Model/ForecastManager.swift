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
    func didUpdateForecast(weatherManager: ForecastManager, firstWeather: WeatherModel, secondWeather: WeatherModel)
    func didFailWithError(error: Error)
}

struct ForecastManager {
    let weatherURL = "https://api.weatherapi.com/v1/forecast.json?days=3&"
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
                    if let firstWeather  = self.parseJSONforForecast(forecastData: safeData).0, let secondWeather = self.parseJSONforForecast(forecastData: safeData).1 {
                        self.delegate?.didUpdateForecast(weatherManager: self, firstWeather: firstWeather, secondWeather: secondWeather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONforForecast(forecastData: Data) -> (WeatherModel?, WeatherModel?) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            let id = decodedData.forecast.forecastday[1].day.condition.code
            let name = decodedData.location.name
            let firstDate = decodedData.forecast.forecastday[1].date
            let firstMaxTemp = decodedData.forecast.forecastday[1].day.maxtemp_c
            let firstMinTemp = decodedData.forecast.forecastday[1].day.mintemp_c
            let firstAvgTemp = decodedData.forecast.forecastday[1].day.avgtemp_c
            let firstHumid = decodedData.forecast.forecastday[1].day.avghumidity
            let secondDate = decodedData.forecast.forecastday[2].date
            let secondMaxTemp = decodedData.forecast.forecastday[2].day.maxtemp_c
            let secondMinTemp = decodedData.forecast.forecastday[2].day.mintemp_c
            let secondAvgTemp = decodedData.forecast.forecastday[2].day.avgtemp_c
            let secondHumid = decodedData.forecast.forecastday[2].day.avghumidity
            
            let firstWeather = WeatherModel(conditionId: id, cityName: name, date: firstDate, currentTemperature: 0.0, maxTemperature: firstMaxTemp, minTemperature: firstMinTemp, avgTemperature: firstAvgTemp, humidity: Int(firstHumid))
            let secondWeather = WeatherModel(conditionId: id, cityName: name, date: secondDate, currentTemperature: 0.0, maxTemperature: secondMaxTemp, minTemperature: secondMinTemp, avgTemperature: secondAvgTemp, humidity: Int(secondHumid))
            
            return (firstWeather, secondWeather)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return (nil, nil)
        }
    }
    
}
