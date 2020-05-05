//
//  WeatherData.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/04/22.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let location: Location
    let current: Current
}

struct Location: Decodable {
    let name: String
}

struct Current: Decodable {
    let temp_c: Double
    let humidity: Int
    let condition: Condition
}

struct Condition: Decodable {
    let code: Int
}
