//
//  ForecastViewController.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/03.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!

    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.isCurrentWeather = false
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather.cityName)
        print(weather.maxTemperature)
        print(weather.minTemperature)
        print(weather.avgTemperature)
        print(weather.conditionId)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
