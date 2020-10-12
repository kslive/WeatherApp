//
//  MyCitiesController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import RealmSwift

class MyCitiesController: UITableViewController {
    
    var cities = [String]()
    var cityes: Results<City>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        
        guard let realm = try? Realm() else { return }
        cityes = realm.objects(City.self)
        
        token = cityes?.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func showAddCityForm() {
        
        let alert = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        
        alert.addTextField {_ in }
        
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
            
            guard let name = alert.textFields?[0].text else { return }
            self?.addCity(name: name)
        }
        
        alert.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func addCity(name: String) {
        
        let newCity = City()
        
        newCity.name = name
        
        do {
            let realm = try Realm()
            
            realm.beginWrite()
            realm.add(newCity, update: .all)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityes!.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCityCell", for: indexPath) as! MyCitiesCell
        let city = cityes![indexPath.row]
        cell.myCityName.text = city.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let city = cityes![indexPath.row]
        
        if editingStyle == .delete {
            do {
                
                let realm = try Realm()
                
                realm.beginWrite()
                realm.delete(city.weathers)
                realm.delete(city)
                
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController",
           let cell = sender as? UITableViewCell {
            
            let ctrl = segue.destination as! WeatherViewController
            
            if let indexPath = tableView.indexPath(for: cell) {
                
                ctrl.cityName = cityes![indexPath.row].name
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        showAddCityForm()
    }
}
