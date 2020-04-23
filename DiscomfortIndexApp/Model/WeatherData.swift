//
//  WeatherData.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/22.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

struct Weather: Decodable {
    let description: String
}
