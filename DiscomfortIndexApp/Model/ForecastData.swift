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
    let day: Day
   
}

struct Day: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let avghumidity: Double
    let condition: ConditionForForcast
}

struct ConditionForForcast: Decodable {
    let code: Int
}
