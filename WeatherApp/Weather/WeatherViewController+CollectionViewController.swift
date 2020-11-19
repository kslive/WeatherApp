//
//  WeatherViewController+CollectionViewController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 20.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let weather = weathers[indexPath.row]
    
        cell.icon.image = photoService?.photo(atIndexpath: indexPath, byUrl: weather.url)
        
        cell.configure(withWeather: weather)
        
        return cell
    }
}
