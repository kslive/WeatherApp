//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 0.75
            self.shadowView.layer.shadowRadius = 6
            self.shadowView.layer.shadowColor = UIColor.systemBlue.cgColor
            self.shadowView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadowView.layer.shadowPath = UIBezierPath(ovalIn: self.shadowView.bounds).cgPath
        self.containerView.layer.cornerRadius = containerView.frame.size.width / 2
    }
    
    func configure(withWeather weather: Weather) {
        
        let date = Date(timeIntervalSince1970: weather.date)
        let stringDate = WeatherCell.dateFormatter.string(from: date)
        
        self.weather.text = String(weather.temp)
        time.text = stringDate
        icon.image = UIImage(named: weather.weatherIcon)
    }
}
