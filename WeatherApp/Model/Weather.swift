//
//  Weather.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 30.09.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseFirestore

class Weather: Object, Decodable {
    
    var url: String {
        return "http://openweathermap.org/img/w/\(weatherIcon).png"
    }
    
    @objc dynamic var date = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var pressure = 0.0
    @objc dynamic var humidity = 0
    @objc dynamic var weatherName = ""
    @objc dynamic var weatherIcon = ""
    @objc dynamic var windSpeed = 0.0
    @objc dynamic var windDegrees = 0.0
    @objc dynamic var city = ""
    
    enum CodingKeys: String, CodingKey {
        
        case date = "dt"
        case main
        case weather
        case wind
    }
    
    enum MainKeys: String, CodingKey {
        
        case temp
        case pressure
        case humidity
    }
    
    enum WeatherKeys: String, CodingKey {
        
        case main
        case icon
    }
    
    enum WindKeys: String, CodingKey {
        
        case speed
        case deg
    }
    
    func toFirestore() -> [String: Any ] {
        return [
            String(format: "$0.f", date) : temp
        ]
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let value = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try value.decode(Double.self, forKey: .date)
        
        let mainValues = try value.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temp = try mainValues.decode(Double.self, forKey: .temp)
        self.pressure = try mainValues.decode(Double.self, forKey: .pressure)
        self.humidity = try mainValues.decode(Int.self, forKey: .humidity)
        
        var weatherValues = try value.nestedUnkeyedContainer(forKey: .weather)
        let firstWeatherValues = try weatherValues.nestedContainer(keyedBy: WeatherKeys.self)
        self.weatherName = try firstWeatherValues.decode(String.self, forKey: .main)
        self.weatherIcon = try firstWeatherValues.decode(String.self, forKey: .icon)
        
        let windValue = try value.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        self.windSpeed = try windValue.decode(Double.self, forKey: .speed)
        self.windDegrees = try windValue.decode(Double.self, forKey: .deg)
        
        self.city = city
    }
}
