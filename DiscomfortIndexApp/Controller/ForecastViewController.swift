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
    @IBOutlet weak var sixAMDIImageView: UIImageView!
    @IBOutlet weak var sixAMDILabel: UILabel!
    @IBOutlet weak var sixAMTemperatureLabel: UILabel!
    @IBOutlet weak var nineAMConditionImageView: UIImageView!
    @IBOutlet weak var nineAMDIImageView: UIImageView!
    @IBOutlet weak var nineAMDILabel: UILabel!
    @IBOutlet weak var nineAMTemperatureLabel: UILabel!
    @IBOutlet weak var twelvePMConditionImageView: UIImageView!
    @IBOutlet weak var twelvePMDIImageView: UIImageView!
    @IBOutlet weak var twelvePMDILabel: UILabel!
    @IBOutlet weak var twelvePMTemperatureLabel: UILabel!
    @IBOutlet weak var threePMConditionImageView: UIImageView!
    @IBOutlet weak var threePMDIImageView: UIImageView!
    @IBOutlet weak var threePMDILabel: UILabel!
    @IBOutlet weak var threePMTemperatureLabel: UILabel!
    @IBOutlet weak var sixPMConditionImageView: UIImageView!
    @IBOutlet weak var sixPMDIImageView: UIImageView!
    @IBOutlet weak var sixPMDILabel: UILabel!
    @IBOutlet weak var sixPMTemperatureLabel: UILabel!
    @IBOutlet weak var ninePMConditionImageView: UIImageView!
    @IBOutlet weak var ninePMDIImageView: UIImageView!
    @IBOutlet weak var ninePMDILabel: UILabel!
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

    func didUpdateForecast(forecastManager: ForecastManager, forecast: [ForecastModel], discomfortIndex: [DiscomfortIndexModel]) {
        DispatchQueue.main.async {
            self.cityLabel.text = forecast[0].cityName
            self.dayLabel.text = forecast[0].formattedDate
            self.sixAMConditionImageView.image = UIImage(systemName: forecast[0].conditionName)
            self.sixAMDIImageView.image = UIImage(named: discomfortIndex[0].discomfortIndexImage)
            self.sixAMDILabel.text = discomfortIndex[0].discomfortIndexName
            self.sixAMTemperatureLabel.text = forecast[0].temperatureString
            self.nineAMConditionImageView.image = UIImage(systemName: forecast[1].conditionName)
            self.nineAMDIImageView.image = UIImage(named: discomfortIndex[1].discomfortIndexImage)
            self.nineAMDILabel.text = discomfortIndex[1].discomfortIndexName
            self.nineAMTemperatureLabel.text = forecast[1].temperatureString
            self.twelvePMConditionImageView.image = UIImage(systemName: forecast[2].conditionName)
            self.twelvePMDIImageView.image = UIImage(named: discomfortIndex[2].discomfortIndexImage)
            self.twelvePMDILabel.text = discomfortIndex[2].discomfortIndexName
            self.twelvePMTemperatureLabel.text = forecast[2].temperatureString
            self.threePMConditionImageView.image = UIImage(systemName: forecast[3].conditionName)
            self.threePMDIImageView.image = UIImage(named: discomfortIndex[3].discomfortIndexImage)
            self.threePMDILabel.text = discomfortIndex[3].discomfortIndexName
            self.threePMTemperatureLabel.text = forecast[3].temperatureString
            self.sixPMConditionImageView.image = UIImage(systemName: forecast[4].conditionName)
            self.sixPMDIImageView.image = UIImage(named: discomfortIndex[4].discomfortIndexImage)
            self.sixPMDILabel.text = discomfortIndex[4].discomfortIndexName
            self.sixPMTemperatureLabel.text = forecast[4].temperatureString
            self.ninePMConditionImageView.image = UIImage(systemName: forecast[5].conditionName)
            self.ninePMDIImageView.image = UIImage(named: discomfortIndex[5].discomfortIndexImage)
            self.ninePMDILabel.text = discomfortIndex[5].discomfortIndexName
            self.ninePMTemperatureLabel.text = forecast[5].temperatureString
        }
    }

    func didUpdateFailResult() {
        cityLabel.text = "Error"
        dayLabel.text = "*****"
        sixAMDILabel.text = "Error"
        sixAMTemperatureLabel.text = "*"
        nineAMDILabel.text = "Error"
        nineAMTemperatureLabel.text = "*"
        twelvePMDILabel.text = "Error"
        twelvePMTemperatureLabel.text = "*"
        threePMDILabel.text = "Error"
        threePMTemperatureLabel.text = "*"
        sixPMDILabel.text = "Error"
        sixPMTemperatureLabel.text = "*"
        ninePMDILabel.text = "Error"
        ninePMTemperatureLabel.text = "*"
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
