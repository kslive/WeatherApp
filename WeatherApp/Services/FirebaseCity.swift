//
//  FirebaseCity.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 17.10.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCity {
    
    let name: String
    let zipcode: Int
    let ref: DatabaseReference?
    
    init(name: String, zipcode: Int) {
        
        self.ref = nil
        self.name = name
        self.zipcode = zipcode
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let zipcode = value["zipcode"] as? Int,
              let name = value["name"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.zipcode = zipcode
    }
    
    func toAnyObject() -> [String: Any] {
        
        return [
            "name": name,
            "zipcode": zipcode
        ]
    }
}
