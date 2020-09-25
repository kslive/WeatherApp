//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 25.09.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    
    let baseUrl = "http://api.openweathermap.org"
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    func loadWeatherData(city: String) {
        
        let path = "/data/2.5/forecast"
        let parameters: Parameters = [
            "q" : city,
            "units" : "metric",
            "appid" : apiKey
        ]
        
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value ?? "ERROR")
        }
    }
}

