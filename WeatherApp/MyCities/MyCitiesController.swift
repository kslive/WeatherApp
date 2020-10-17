//
//  MyCitiesController.swift
//  WeatherApp
//
//  Created by Eugene Kiselev on 01.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyCitiesController: UITableViewController {
    
    private let ref = Database.database().reference(withPath: "cities")
    private var cities = [FirebaseCity]()
//    var cityes: Results<City>?
//    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pairTableAndRealm()
        
        ref.observe(.value) { [weak self] snapshot in
            
            var cities: [FirebaseCity] = []
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                   let city = FirebaseCity(snapshot: snapshot) {
                    cities.append(city)
                }
            }
            
            self?.cities = cities
            self?.tableView.reloadData()
        }
    }
    
//    func pairTableAndRealm() {
//
//        guard let realm = try? Realm() else { return }
//        cityes = realm.objects(City.self)
//
//        token = cityes?.observe { [weak self] (changes: RealmCollectionChange) in
//
//            guard let tableView = self?.tableView else { return }
//
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                tableView.endUpdates()
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCityCell", for: indexPath) as! MyCitiesCell
        let city = cities[indexPath.row]
        cell.myCityName.text = city.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let city = cities[indexPath.row]
            city.ref?.removeValue()
            
//            do {
//
//                let realm = try Realm()
//
//                realm.beginWrite()
//                realm.delete(city.weathers)
//                realm.delete(city)
//
//                try realm.commitWrite()
//            } catch {
//                print(error)
//            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController",
           let cell = sender as? UITableViewCell {
            
            let ctrl = segue.destination as! WeatherViewController
            
            if let indexPath = tableView.indexPath(for: cell) {
                
                ctrl.cityName = cities[indexPath.row].name
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {

        let alertVC = UIAlertController(title: "Enter a city name please", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            guard let textField = alertVC.textFields?.first,
                  let cityName = textField.text else { return }
            
            let city = FirebaseCity(name: cityName, zipcode: Int.random(in: 100000...999999))
            let cityRef = self?.ref.child(cityName.lowercased())
            
            cityRef?.setValue(city.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addTextField()
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
            dismiss(animated: true)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}
