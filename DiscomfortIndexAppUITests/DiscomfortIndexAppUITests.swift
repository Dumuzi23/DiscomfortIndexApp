//
//  DiscomfortIndexAppUITests.swift
//  DiscomfortIndexAppUITests
//
//  Created by Tatsuya Amida on 2020/05/14.
//  Copyright © 2020 T.A. All rights reserved.
//

import XCTest

class DiscomfortIndexAppUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testWeather() {
        let app = XCUIApplication()
        let searchTextField = app.textFields["weather_textfield"]
        let searchButton = app.buttons["weather_search_button"]
        let cityLabel = app.staticTexts["weather_city_label"]

        XCTAssert(searchTextField.exists)
        XCTAssert(searchButton.exists)
        XCTAssert(cityLabel.exists)

        searchTextField.tap()
        searchTextField.typeText("sapporo")
        searchButton.tap()

        // 都市名ラベルが更新されるまでの待機時間として２秒を設定
        sleep(2)
        XCTAssertEqual(cityLabel.label, "Sapporo")
    }

    func testForecast() {
        let app = XCUIApplication()
        let searchTextField = app.textFields["forecast_textfield"]
        let searchButton = app.buttons["forecast_search_button"]
        let cityLabel = app.staticTexts["forecast_city_label"]

        // スワイプして予報ページに移動
        app.otherElements["weather_view"].swipeLeft()

        XCTAssert(searchTextField.exists)
        XCTAssert(searchButton.exists)
        XCTAssert(cityLabel.exists)

        searchTextField.tap()
        searchTextField.typeText("sapporo")
        searchButton.tap()

        // 都市名ラベルが更新されるまでの待機時間として２秒を設定
        sleep(2)
        XCTAssertEqual(cityLabel.label, "Sapporo")
    }

}
