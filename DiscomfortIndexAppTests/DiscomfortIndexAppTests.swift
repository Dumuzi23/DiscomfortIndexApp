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

    func testTemperatureString() {
        let weatherModel1 = WeatherModel(conditionId: 1000, cityName: "sapporo", currentTemperature: 12.3, humidity: 10)
        let weatherModel2 = WeatherModel(conditionId: 1003, cityName: "sapporo", currentTemperature: 12.6, humidity: 10)

        XCTContext.runActivity(named: "temperatureStringのテスト") { _ in
            XCTAssertEqual(weatherModel1.temperatureString, "12", "気温が小数点第一位で四捨五入され、String型になっていること")
            XCTAssertEqual(weatherModel2.temperatureString, "13", "気温が小数点第一位で四捨五入され、String型になっていること")
        }

        XCTContext.runActivity(named: "temperatureStringのテスト") { _ in
            XCTAssertEqual(weatherModel1.humidityString, "10")
        }

        XCTContext.runActivity(named: "conditionNameのテスト") { _ in
            XCTAssertEqual(weatherModel1.conditionName, "sun.max")
            XCTAssertEqual(weatherModel2.conditionName, "cloud.sun")
        }
    }
}

class ForecastModelTests: XCTestCase {

    let forecastModel = ForecastModel(cityName: "sapporo", date: "2020-06-11", sixAMConditionId: 1000, nineAMConditionId: 1003, twelvePMConditionId: 1006, threePMConditionId: 1150, sixPMConditionId: 1114, ninePMConditionId: 1168, sixAMTemperature: 12.3, nineAMTemperature: 12.6, twelvePMTemperature: 0.0, threePMTemperature: 0.0, sixPMTemperature: 0.0, ninePMTemperature: 0.0)

    func testFormattedDate() {
        XCTContext.runActivity(named: "formattedDateのテスト") { _ in
            XCTAssertEqual(forecastModel.formattedDate, "06/11")
        }
    }

    func testTemperatureString() {

        let floorTemperatureString = forecastModel.temperatureString(temp: forecastModel.sixAMTemperature)
        let ceilTemperatureString = forecastModel.temperatureString(temp: forecastModel.nineAMTemperature)

        XCTContext.runActivity(named: "temperatureStringのテスト") { _ in
            XCTAssertEqual(floorTemperatureString, "12", "気温が小数点第一位で四捨五入され、String型になっていること")
            XCTAssertEqual(ceilTemperatureString, "13", "気温が小数点第一位で四捨五入され、String型になっていること")
        }
    }

}
