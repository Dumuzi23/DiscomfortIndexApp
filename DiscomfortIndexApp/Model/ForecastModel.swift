//
//  ForecastModel.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/06/02.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct ForecastModel {
    let cityName: String
    let date: String
    let sixAMConditionId: Int
    let nineAMConditionId: Int
    let twelvePMConditionId: Int
    let threePMConditionId: Int
    let sixPMConditionId: Int
    let ninePMConditionId: Int
    let sixAMTemperature: Double
    let nineAMTemperature: Double
    let twelvePMTemperature: Double
    let threePMTemperature: Double
    let sixPMTemperature: Double
    let ninePMTemperature: Double

    var formattedDate: String {
        if date == "" {
            return "****"
        } else {
            let dateArray = date.components(separatedBy: "-")
            return String(format: "%@/%@", dateArray[1], dateArray[2])
        }
    }
    
    func temperatureString(temp: Double) -> String {
        let temperatureInt = Int(round(temp))
        return String(temperatureInt)
    }
    
    func judgeConditionName(conditionId: Int) -> String {
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
