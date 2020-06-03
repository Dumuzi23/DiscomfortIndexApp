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
    
    func didUpdateForecast(forecastManager: ForecastManager, forecast: ForecastModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = forecast.cityName
            self.dayLabel.text = forecast.formattedDate
            self.firstConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.sixAMConditionId))
            self.firstTemperatureLabel.text = forecast.temperatureString(temp: forecast.sixAMTemperature)
            self.secondConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.nineAMConditionId))
            self.secondTemperatureLabel.text = forecast.temperatureString(temp: forecast.nineAMTemperature)
            self.thirdConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.twelvePMConditionId))
            self.thirdTemperatureLabel.text = forecast.temperatureString(temp: forecast.twelvePMTemperature)
            self.fourthConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.threePMConditionId))
            self.fourthTemperatureLabel.text = forecast.temperatureString(temp: forecast.threePMTemperature)
            self.fifthConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.sixPMConditionId))
            self.fifthTemperatureLabel.text = forecast.temperatureString(temp: forecast.sixPMTemperature)
            self.sixConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.ninePMConditionId))
            self.sixthTemperatureLabel.text = forecast.temperatureString(temp: forecast.ninePMTemperature)
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
