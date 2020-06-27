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
        let cityLabel = app.staticTexts["weather_city_label"].label

        searchTextField.tap()
        searchTextField.typeText("sapporo")
        searchButton.tap()

        XCTAssertEqual(cityLabel, "Sapporo")
    }

}
