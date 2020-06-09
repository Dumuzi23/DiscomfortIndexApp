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
    let date: String
    let currentTemperature: Double
    let maxTemperature: Double
    let minTemperature: Double
    let avgTemperature: Double
    let humidity: Int
    
    var formattedDate: String {
        let dateArray = date.components(separatedBy: "-")
        
        return String(format: "%@/%@", dateArray[1], dateArray[2])
    }
    
    var temperatureString: String {
        let temperatureInt = Int((round(currentTemperature)))
        return String(temperatureInt)
    }
    
    var humidityString: String {
        return String(humidity)
    }
    
    var conditionName: String {
        switch conditionId {
        case 1000:
            return "sun.max"
        case 1003:
            return "cloud.sun"
        case 1006...1009:
            return "cloud"
        case 1030, 1135, 1147:
            return "cloud.fog"
        case 1063, 1072, 1150...1153, 1180...1195, 1240...1246:
            return "cloud.rain"
        case 1066, 1114...1117, 1210...1225, 1255...1258:
            return "cloud.snow"
        case 1069, 1168...1171, 1198...1207, 1237, 1249...1252, 1261...1264:
            return "cloud.sleet"
        case 1087:
            return "cloud.bolt"
        case 1273...1282:
            return "cloud.bolt.rain"
        default:
            return "cloud"
        }
    }
}
