//
//  DiscomfortIndexModel.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/29.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct DiscomfortIndexModel {
    let temperature: Double
    let humidity: Int
    
    var discomfortIndex: Double {
        get {
            let di = 0.81 * temperature + 0.01 * Double(humidity) * (0.99 * temperature - 14.3) + 46.3
            return di
        }
    }
    
    var discomfortIndexImage: String {
        switch discomfortIndex {
        case ..<55:
            return "worst"
        case 55..<60:
            return "not-comfort"
        case 60..<65:
            return "normal"
        case 65..<70:
            return "comfort"
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
    
    var discomfortIndexName: String {
        switch discomfortIndex {
        case ..<55:
            return "Cold!"
        case 55..<60:
            return "Chilly"
        case 60..<65:
            return "Normal"
        case 65..<70:
            return "Comfort!"
        case 70..<75:
            return "Normal"
        case 75..<80:
            return "A little hot"
        case 80..<85:
            return "Hot"
        case 85...:
            return "Boiling Hot!"
        default:
            return "Normal"
        }
    }
    
}
