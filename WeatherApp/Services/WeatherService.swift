//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 25.09.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherService: Object {
    
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
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let data = response.value else { return }
            
            let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
            
            weather.forEach { $0.city = city }
            
            self?.saveWeatherData(weather, city: city)
        }
    }
    
    
    func saveWeatherData(_ weathers: [Weather], city: String) {
        
        do {
            
            let realm = try Realm()
            
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            let oldWeathers = city.weathers
            
            realm.beginWrite()
            realm.delete(oldWeathers)
            
            city.weathers.append(objectsIn: weathers)
            
            try realm.commitWrite()
        } catch {
            
            print(error)
        }
    }
}

