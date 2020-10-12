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
    var weathers: List<Weather>!
    var token: NotificationToken?
    var cityName = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var weekdayPickerView: WeekdayPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.loadWeatherData(city: cityName)
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        
        guard let realm = try? Realm(),
              let city = realm.object(ofType: City.self, forPrimaryKey: cityName) else { return }
        
        weathers = city.weathers
        
        token = weathers.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                collectionView.performBatchUpdates ({
                    collectionView.insertItems(at: insertions.map({
                        IndexPath(row: $0, section: 0)
                    }))
                    collectionView.deleteItems(at: deletions.map({
                        IndexPath(row: $0, section: 0)
                    }))
                    collectionView.reloadItems(at: modifications.map({
                        IndexPath(row: $0, section: 0)
                    }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}


