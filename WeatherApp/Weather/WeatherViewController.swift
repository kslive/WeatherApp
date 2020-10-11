//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    let dateFormatter = DateFormatter()
    let weatherService = WeatherService()
    var weathers = [Weather]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekdayPickerView: WeekdayPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.loadWeatherData(city: "Moscow") { [weak self] weathers in
            
            self?.loadData()
            
            self?.collectionView.reloadData()
        }
    }
    
    func loadData() {
        
        do {
            let realm = try Realm()
            let weathers = realm.objects(Weather.self).filter("city == %@", "Moscow")
            
            self.weathers = Array(weathers)
        } catch {
            
            print(error)
        }
    }
    
}


