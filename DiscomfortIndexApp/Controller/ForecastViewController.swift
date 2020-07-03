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
    @IBOutlet weak var sixAMConditionImageView: UIImageView!
    @IBOutlet weak var sixAMDIimageView: UIImageView!
    @IBOutlet weak var sixAMDIlabel: UILabel!
    @IBOutlet weak var sixAMTemperatureLabel: UILabel!
    @IBOutlet weak var nineAMConditionImageView: UIImageView!
    @IBOutlet weak var nineAMDIimageView: UIImageView!
    @IBOutlet weak var nineAMDIlabel: UILabel!
    @IBOutlet weak var nineAMTemperatureLabel: UILabel!
    @IBOutlet weak var twelvePMConditionImageView: UIImageView!
    @IBOutlet weak var twelvePMDIimageView: UIImageView!
    @IBOutlet weak var twelvePMDIlabel: UILabel!
    @IBOutlet weak var twelvePMTemperatureLabel: UILabel!
    @IBOutlet weak var threePMConditionImageView: UIImageView!
    @IBOutlet weak var threePMDIimageView: UIImageView!
    @IBOutlet weak var threePMDIlabel: UILabel!
    @IBOutlet weak var threePMTemperatureLabel: UILabel!
    @IBOutlet weak var sixPMConditionImageView: UIImageView!
    @IBOutlet weak var sixPMDIimageView: UIImageView!
    @IBOutlet weak var sixPMDIlabel: UILabel!
    @IBOutlet weak var sixPMTemperatureLabel: UILabel!
    @IBOutlet weak var ninePMConditionImageView: UIImageView!
    @IBOutlet weak var ninePMDIimageView: UIImageView!
    @IBOutlet weak var ninePMDIlabel: UILabel!
    @IBOutlet weak var ninePMTemperatureLabel: UILabel!

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
            self.sixAMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.sixAMConditionId))
            self.sixAMTemperatureLabel.text = forecast.temperatureString(temp: forecast.sixAMTemperature)
            self.nineAMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.nineAMConditionId))
            self.nineAMTemperatureLabel.text = forecast.temperatureString(temp: forecast.nineAMTemperature)
            self.twelvePMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.twelvePMConditionId))
            self.twelvePMTemperatureLabel.text = forecast.temperatureString(temp: forecast.twelvePMTemperature)
            self.threePMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.threePMConditionId))
            self.threePMTemperatureLabel.text = forecast.temperatureString(temp: forecast.threePMTemperature)
            self.sixPMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.sixPMConditionId))
            self.sixPMTemperatureLabel.text = forecast.temperatureString(temp: forecast.sixPMTemperature)
            self.ninePMConditionImageView.image = UIImage(systemName: forecast.judgeConditionName(conditionId: forecast.ninePMConditionId))
            self.ninePMTemperatureLabel.text = forecast.temperatureString(temp: forecast.ninePMTemperature)
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
