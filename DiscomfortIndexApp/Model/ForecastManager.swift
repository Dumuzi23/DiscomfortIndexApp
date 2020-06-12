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

protocol ForecastManagerDelegate {
    func didUpdateForecast(forecastManager: ForecastManager, forecast: ForecastModel)
    func didFailWithError(error: Error)
}

struct ForecastManager {
    let weatherURL = "https://api.weatherapi.com/v1/forecast.json?days=2&"
    let apiKey = APIKey()

    var delegate: ForecastManagerDelegate?
    
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
            if let safeData = response.data {
                if let forecast = self.parseJSONforForecast(forecastData: safeData) {
                    self.delegate?.didUpdateForecast(forecastManager: self, forecast: forecast)
                }
            } else {
                print("error")
            }
        }
    }
    
    func parseJSONforForecast(forecastData: Data) -> ForecastModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            let name = decodedData.location.name
            let date = decodedData.forecast.forecastday[1].date
            let sixAMWeatherId = decodedData.forecast.forecastday[1].hour[6].condition.code
            let sixAMTemperature = decodedData.forecast.forecastday[1].hour[6].temp_c
            let nineAMWeatherId = decodedData.forecast.forecastday[1].hour[9].condition.code
            let nineAMTemperature = decodedData.forecast.forecastday[1].hour[9].temp_c
            let twelvePMWeatherId = decodedData.forecast.forecastday[1].hour[12].condition.code
            let twelvePMTemperature = decodedData.forecast.forecastday[1].hour[12].temp_c
            let threePMWeatherId = decodedData.forecast.forecastday[1].hour[15].condition.code
            let threePMTemperature = decodedData.forecast.forecastday[1].hour[15].temp_c
            let sixPMWeatherId = decodedData.forecast.forecastday[1].hour[18].condition.code
            let sixPMTemperature = decodedData.forecast.forecastday[1].hour[18].temp_c
            let ninePMWeatherId = decodedData.forecast.forecastday[1].hour[21].condition.code
            let ninePMTemperature = decodedData.forecast.forecastday[1].hour[21].temp_c
            
            let forecast = ForecastModel(cityName: name, date: date, sixAMConditionId: sixAMWeatherId, nineAMConditionId: nineAMWeatherId, twelvePMConditionId: twelvePMWeatherId, threePMConditionId: threePMWeatherId, sixPMConditionId: sixPMWeatherId, ninePMConditionId: ninePMWeatherId, sixAMTemperature: sixAMTemperature, nineAMTemperature: nineAMTemperature, twelvePMTemperature: twelvePMTemperature, threePMTemperature: threePMTemperature, sixPMTemperature: sixPMTemperature, ninePMTemperature: ninePMTemperature)
            
            return forecast
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
