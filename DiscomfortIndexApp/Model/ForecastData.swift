//
//  ForecastData.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/04.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct ForecastData: Decodable {
    let location: LocationForForecast
    let forecast: Forecast
}

struct LocationForForecast: Decodable {
    let name: String
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct Forecastday: Decodable {
    let date: String
    let hour: [Hour]
}

struct Hour: Decodable {
    let time: String
    let temp_c: Double
    let condition: ConditionForForcast
    let humidity: Int
}

struct ConditionForForcast: Decodable {
    let code: Int
}
