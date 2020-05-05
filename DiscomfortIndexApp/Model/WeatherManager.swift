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
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=[apiKey]&units=metric"
    
    var isCurrentWeather = false
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        var urlString = "\(weatherURL)&q=\(cityName)"
        
        // isCurrentWeatherがfalseのとき（ForecastViewControllerから気象情報を要求されたとき）、urlStringを天気予報用に書き換えます。
        if !isCurrentWeather {
            urlString = "https://api.openweathermap.org/data/2.5/forecast/dayly?appid=[apiKey]&units=metric&cnt=2&q=\(cityName)"
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
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let humid = decodedData.main.humidity
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: temp, maxTemperature: 0.0, minTemperature: 0.0, dayTemperature: 0.0, humidity: humid)
            
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
            let id = decodedData.list[0].weather[0].id
            let name = decodedData.city.name
            let maxTemp = decodedData.list[0].temp.max
            let minTemp = decodedData.list[0].temp.min
            let dayTemp = decodedData.list[0].temp.day
            let humid = decodedData.list[0].humidity
            
            let weather = WeatherModel(conditionId: id, cityName: name, currentTemperature: 0.0, maxTemperature: maxTemp, minTemperature: minTemp, dayTemperature: dayTemp, humidity: humid)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
