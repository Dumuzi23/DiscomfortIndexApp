//
//  DiscomfortIndexManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/29.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation

struct DiscomfortIndexManager {
    let temperature: Double
    let humidity: Int
    
    func culculateDiscomfortIndex(temperature: Double, humidity: Double) -> Double {
        let di = 0.81 * temperature + 0.01 * Double(humidity) * (0.99 * temperature - 14.3) + 46.3
        return di
    }
    
    func judgeDiscomfortIndexName(discomfortIndex: Double) -> String {
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
}
