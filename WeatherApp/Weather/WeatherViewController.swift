//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.loadWeatherData(city: "Moscow")
    }
    
    @IBOutlet weak var weekdayPickerView: WeekdayPicker!
}


