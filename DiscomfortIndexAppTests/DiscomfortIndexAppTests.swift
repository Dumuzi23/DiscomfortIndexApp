//
//  DiscomfortIndexAppTests.swift
//  DiscomfortIndexAppTests
//
//  Created by Tatsuya Amida on 2020/05/14.
//  Copyright © 2020 T.A. All rights reserved.
//

import XCTest
@testable import DiscomfortIndexApp

class WeatherModelTests: XCTestCase {

    let weatherModel1 = WeatherModel(conditionId: 1000, cityName: "sapporo", currentTemperature: 12.3, humidity: 10)
    let weatherModel2 = WeatherModel(conditionId: 1003, cityName: "sapporo", currentTemperature: 12.6, humidity: 10)

    func testTemperatureString() {
        XCTContext.runActivity(named: "temperatureStringのテスト") { _ in
            XCTAssertEqual(weatherModel1.temperatureString, "12", "気温が小数点第一位で四捨五入され、String型になっていること")
            XCTAssertEqual(weatherModel2.temperatureString, "13", "気温が小数点第一位で四捨五入され、String型になっていること")
        }
    }

    func testHumidityString() {
        XCTContext.runActivity(named: "humidityStringのテスト") { _ in
            XCTAssertEqual(weatherModel1.humidityString, "10")
        }
    }

    func testConditionName() {
        XCTContext.runActivity(named: "conditionNameのテスト") { _ in
            XCTAssertEqual(weatherModel1.conditionName, "sun.max")
            XCTAssertEqual(weatherModel2.conditionName, "cloud.sun")
        }
    }
}

class ForecastModelTests: XCTestCase {

    let forecastModel = ForecastModel(cityName: "sapporo", date: "2020-06-11", conditionId: 1003, temperature: 12.3, humidity: 50)

    func testFormattedDate() {
        XCTContext.runActivity(named: "formattedDateのテスト") { _ in
            XCTAssertEqual(forecastModel.formattedDate, "06/11")
        }
    }

    func testTemperatureString() {
        XCTContext.runActivity(named: "temperatureStringのテスト") { _ in
            XCTAssertEqual(forecastModel.temperatureString, "12", "気温が小数点第一位で四捨五入され、String型になっていること")
        }
    }

}
