//
//  ForecastData.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/04.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct ForecastData: Decodable {
    let city: City
    let list: [List]
}

struct City: Decodable {
    let name: String
}

struct List: Decodable {
    let dt: Int
    let temp: Temp
    let humidity: Int
    let weather: [Weather2]
}

struct Temp: Decodable {
    let max: Double
    let min: Double
    let day: Double
}

struct Weather2: Decodable {
    let id: Int
}
