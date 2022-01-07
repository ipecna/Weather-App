//
//  WeatherDataSource.swift
//  Weather App
//
//  Created by Semyon Chulkov on 17.12.2021.
//

import UIKit
 
class WeatherTableDataSource: NSObject, UITableViewDataSource {
    
    var weather: [WeatherTableModel]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.dayLabel.text = weather?[indexPath.row].dayString
        cell.tempLabel.text = weather?[indexPath.row].temperatureString
        return cell
    }
}

