//
//  ForecastViewController.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/03.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var firstConditionImageView: UIImageView!
    @IBOutlet weak var firstTemperatureLabel: UILabel!
    @IBOutlet weak var secondTimeLabel: UILabel!
    @IBOutlet weak var secondConditionImageView: UIImageView!
    @IBOutlet weak var secondTemperatureLabel: UILabel!
    @IBOutlet weak var thirdTimeLabel: UILabel!
    @IBOutlet weak var thirdConditionImageView: UIImageView!
    @IBOutlet weak var thirdTemperatureLabel: UILabel!
    @IBOutlet weak var fourthTimeLabel: UILabel!
    @IBOutlet weak var fourthConditionImageView: UIImageView!
    @IBOutlet weak var fourthTemperatureLabel: UILabel!
    @IBOutlet weak var fifthTimeLabel: UILabel!
    @IBOutlet weak var fifthConditionImageView: UIImageView!
    @IBOutlet weak var fifthTemperatureLabel: UILabel!
    @IBOutlet weak var sixthTimeLabel: UILabel!
    @IBOutlet weak var sixConditionImageView: UIImageView!
    @IBOutlet weak var sixthTemperatureLabel: UILabel!
    
    var forecastManager = ForecastManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        forecastManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

extension ForecastViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
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
            forecastManager.fetchForecast(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

extension ForecastViewController: ForecastManagerDelegate {
       
       func didUpdateForecast(weatherManager: ForecastManager, firstWeather: WeatherModel) {
           DispatchQueue.main.async {
               self.cityLabel.text = firstWeather.cityName
               self.dayLabel.text = firstWeather.formattedDate
               self.firstConditionImageView.image = UIImage(systemName: firstWeather.conditionName)
               self.firstTemperatureLabel.text = firstWeather.temperatureString
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
}

extension ForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            forecastManager.fetchForecast(latitude: lat, longtude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
