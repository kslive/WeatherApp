//
//  AllCitiesCell.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class AllCitiesCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel! {
        didSet {
            self.cityName.textColor = .black
        }
    }
    @IBOutlet weak var cityEmblemView: UIImageView! {
        didSet {
            self.cityEmblemView.layer.borderColor = UIColor.white.cgColor
            self.cityEmblemView.layer.borderWidth = 2
            self.cityEmblemView.contentMode = .scaleAspectFill
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cityName.text = nil
        cityEmblemView.image = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        cityEmblemView.clipsToBounds = true
        cityEmblemView.layer.cornerRadius = cityEmblemView.frame.size.width / 2
    }
    
    func configure(city: String, emblem: UIImage) {
        
        cityName.text = city
        cityEmblemView.image = emblem
        
    }
}
