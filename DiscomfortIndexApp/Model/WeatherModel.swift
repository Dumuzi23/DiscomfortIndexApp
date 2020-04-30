//
//  WeatherModel.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/26.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let humidity: Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var humidityString: String {
        return String(humidity)
    }
    
    var discomfortIndexName: String {
        let di = 0.81 * temperature + 0.01 * Double(humidity) * (0.99 * temperature - 14.3) + 46.3
        
        switch di {
        case ..<55:
            return "worst"
        case 55..<60:
            return "not-comfort"
        case 60..<65:
            return "normal"
        case 65..<70:
            return "confort"
        case 70..<75:
            return "normal"
        case 75..<80:
            return "not-comfort"
        case 80...:
            return "worst"
        default:
            return "normal"
        }
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
