//
//  ForecastManager.swift
//  DiscomfortIndexApp
//
//  Created by Tatsuya Amida on 2020/05/08.
//  Copyright © 2020 T.A. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

protocol ForecastManagerDelegate: class {
    func didUpdateForecast(forecastManager: ForecastManager, forecast: [ForecastModel], discomfortIndex: [DiscomfortIndexModel])
    func didFailWithError(error: Error)
}

class ForecastManager {
    let weatherURL = "https://api.weatherapi.com/v1/forecast.json?days=2&"
    let apiKey = APIKey()

    weak var delegate: ForecastManagerDelegate?

    func fetchForecast(cityName: String) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(cityName)"

        performRequest(with: urlString)
    }

    func fetchForecast(latitude: CLLocationDegrees, longtude: CLLocationDegrees) {
        let urlString = "\(weatherURL)key=\(apiKey.key)&q=\(latitude),\(longtude)"

        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        AF.request(urlString, method: .get).responseJSON { response in
            switch response.result {
            case .success:
                if let safeData = response.data {
                    if let forecast = self.parseJSONforForecast(forecastData: safeData) {
                        self.delegate?.didUpdateForecast(forecastManager: self, forecast: forecast.0, discomfortIndex: forecast.1)
                    }
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func parseJSONforForecast(forecastData: Data) -> ([ForecastModel], [DiscomfortIndexModel])? {
        do {
            let json = try JSON(data: forecastData)
            let name = json["location"]["name"].stringValue
            let date = json["forecast"]["forecastday"][1]["date"].stringValue
            let sixAMWeatherId = json["forecast"]["forecastday"][1]["hour"][6]["condition"]["code"].intValue
            let sixAMTemperature = json["forecast"]["forecastday"][1]["hour"][6]["temp_c"].doubleValue
            let sixAMHumidity = json["forecast"]["forecastday"][1]["hour"][6]["humidity"].intValue
            let nineAMWeatherId = json["forecast"]["forecastday"][1]["hour"][9]["condition"]["code"].intValue
            let nineAMTemperature = json["forecast"]["forecastday"][1]["hour"][9]["temp_c"].doubleValue
            let nineAMHumidity = json["forecast"]["forecastday"][1]["hour"][9]["humidity"].intValue
            let twelvePMWeatherId = json["forecast"]["forecastday"][1]["hour"][12]["condition"]["code"].intValue
            let twelvePMTemperature = json["forecast"]["forecastday"][1]["hour"][12]["temp_c"].doubleValue
            let twelvePMHumidity = json["forecast"]["forecastday"][1]["hour"][12]["humidity"].intValue
            let threePMWeatherId = json["forecast"]["forecastday"][1]["hour"][15]["condition"]["code"].intValue
            let threePMTemperature = json["forecast"]["forecastday"][1]["hour"][15]["temp_c"].doubleValue
            let threePMHumidity = json["forecast"]["forecastday"][1]["hour"][15]["humidity"].intValue
            let sixPMWeatherId = json["forecast"]["forecastday"][1]["hour"][18]["condition"]["code"].intValue
            let sixPMTemperature = json["forecast"]["forecastday"][1]["hour"][18]["temp_c"].doubleValue
            let sixPMHumidity = json["forecast"]["forecastday"][1]["hour"][18]["humidity"].intValue
            let ninePMWeatherId = json["forecast"]["forecastday"][1]["hour"][21]["condition"]["code"].intValue
            let ninePMTemperature = json["forecast"]["forecastday"][1]["hour"][21]["temp_c"].doubleValue
            let ninePMHumidity = json["forecast"]["forecastday"][1]["hour"][21]["humidity"].intValue

            let forecastList = [ForecastModel(cityName: name, date: date, conditionId: sixAMWeatherId, temperature: sixAMTemperature, humidity: sixAMHumidity)]
            let discomfortIndexList = [DiscomfortIndexModel(temperature: sixAMTemperature, humidity: sixAMHumidity)]

            return (forecastList, discomfortIndexList)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
