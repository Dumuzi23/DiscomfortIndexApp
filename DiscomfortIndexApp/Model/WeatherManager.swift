//
//  WeatherManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/19.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.weatherapi.com/v1/current.json?key=[apiKey]"
    
    var isCurrentWeather = false
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        var urlString = "\(weatherURL)&q=\(cityName)"
        
        // isCurrentWeatherがfalseのとき（ForecastViewControllerから気象情報を要求されたとき）、urlStringを天気予報用に書き換えます。
        if !isCurrentWeather {
            urlString = "https://api.weatherapi.com/v1/forecast.json?key=[apiKey]]&days=2&q=\(cityName)"
            print(urlString)
        }
        
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
                    if self.isCurrentWeather {
                        if let weather = self.parseJSONforCurrentWeather(weatherData: safeData) {
                            self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                        }
                    } else {
                        if let weather  = self.parseJSONforForecast(forecastData: safeData) {
                            self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONforCurrentWeather(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.current.condition.code
            let name = decodedData.location.name
            let temp = decodedData.current.temp_c
            let humid = decodedData.current.humidity
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: temp, maxTemperature: 0.0, minTemperature: 0.0, avgTemperature: 0.0, humidity: humid)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseJSONforForecast(forecastData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            let id = decodedData.forecast.forecastday[0].day.condition.code
            let name = decodedData.location.name
            let maxTemp = decodedData.forecast.forecastday[0].day.maxtemp_c
            let minTemp = decodedData.forecast.forecastday[0].day.mintemp_c
            let avgTemp = decodedData.forecast.forecastday[0].day.avgtemp_c
            let humid = decodedData.forecast.forecastday[0].day.avghumidity
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: 0.0, maxTemperature: maxTemp, minTemperature: minTemp, avgTemperature: avgTemp, humidity: Int(humid))
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
