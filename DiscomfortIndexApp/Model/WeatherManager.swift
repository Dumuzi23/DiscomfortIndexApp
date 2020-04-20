//
//  WeatherManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/19.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=[apiKey]&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)
                }
            }
            task.resume()
        }
    }
    
}
