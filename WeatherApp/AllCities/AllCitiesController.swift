//
//  AllCitiesController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class AllCitiesController: UITableViewController {
    
    var cities = [(title: "Moscow",emblem: #imageLiteral(resourceName: "Moscow")),
                  (title: "Saint-P",emblem: #imageLiteral(resourceName: "Saint-P")),
                  (title: "London",emblem: #imageLiteral(resourceName: "London")),
                  (title: "Paris",emblem: #imageLiteral(resourceName: "Paris"))]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! AllCitiesCell
        let city = cities[indexPath.row]
        
        cell.configure(city: city.title, emblem: city.emblem)

        return cell
    }
}
