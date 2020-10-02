//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let dateFormatter = DateFormatter()
    let weatherService = WeatherService()
    var weathers = [Weather]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.loadWeatherData(city: "Moscow") { [weak self] weathers in
            
            self?.weathers = weathers
            self?.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var weekdayPickerView: WeekdayPicker!
}


