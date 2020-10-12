//
//  City.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 12.10.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import RealmSwift

class City: Object {
    @objc dynamic var name = ""
    
    let weathers = List<Weather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
