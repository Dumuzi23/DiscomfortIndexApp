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

    func didUpdateForecast(forecastManager: ForecastManager, forecast: [ForecastModel], discomfortIndex: [DiscomfortIndexModel]) {
        DispatchQueue.main.async {
            self.cityLabel.text = forecast[0].cityName
            self.dayLabel.text = forecast[0].formattedDate
            self.sixAMConditionImageView.image = UIImage(systemName: forecast[0].conditionName)
            self.sixAMDIimageView.image = UIImage(named: discomfortIndex[0].discomfortIndexImage)
            self.sixAMDIlabel.text = discomfortIndex[0].discomfortIndexName
            self.sixAMTemperatureLabel.text = forecast[0].temperatureString
            self.nineAMConditionImageView.image = UIImage(systemName: forecast[1].conditionName)
            self.nineAMDIimageView.image = UIImage(named: discomfortIndex[1].discomfortIndexImage)
            self.nineAMDIlabel.text = discomfortIndex[1].discomfortIndexName
            self.nineAMTemperatureLabel.text = forecast[1].temperatureString
            self.twelvePMConditionImageView.image = UIImage(systemName: forecast[2].conditionName)
            self.twelvePMDIimageView.image = UIImage(named: discomfortIndex[2].discomfortIndexImage)
            self.twelvePMDIlabel.text = discomfortIndex[2].discomfortIndexName
            self.twelvePMTemperatureLabel.text = forecast[2].temperatureString
            self.threePMConditionImageView.image = UIImage(systemName: forecast[3].conditionName)
            self.threePMDIimageView.image = UIImage(named: discomfortIndex[3].discomfortIndexImage)
            self.threePMDIlabel.text = discomfortIndex[3].discomfortIndexName
            self.threePMTemperatureLabel.text = forecast[3].temperatureString
            self.sixPMConditionImageView.image = UIImage(systemName: forecast[4].conditionName)
            self.sixPMDIimageView.image = UIImage(named: discomfortIndex[4].discomfortIndexImage)
            self.sixPMDIlabel.text = discomfortIndex[4].discomfortIndexName
            self.sixPMTemperatureLabel.text = forecast[4].temperatureString
            self.ninePMConditionImageView.image = UIImage(systemName: forecast[5].conditionName)
            self.ninePMDIimageView.image = UIImage(named: discomfortIndex[5].discomfortIndexImage)
            self.ninePMDIlabel.text = discomfortIndex[5].discomfortIndexName
            self.ninePMTemperatureLabel.text = forecast[5].temperatureString
        }
    }

    func didUpdateFailResult() {
        cityLabel.text = "Error"
        dayLabel.text = "*****"
        sixAMDIlabel.text = "Error"
        sixAMTemperatureLabel.text = "*"
        nineAMDIlabel.text = "Error"
        nineAMTemperatureLabel.text = "*"
        twelvePMDIlabel.text = "Error"
        twelvePMTemperatureLabel.text = "*"
        threePMDIlabel.text = "Error"
        threePMTemperatureLabel.text = "*"
        sixPMDIlabel.text = "Error"
        sixPMTemperatureLabel.text = "*"
        ninePMDIlabel.text = "Error"
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
