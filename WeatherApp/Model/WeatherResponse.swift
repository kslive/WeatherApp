//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 30.09.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation

class WeatherResponse: Decodable {
    
    let list: [Weather]
}
