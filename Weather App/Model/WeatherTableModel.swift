//
//  WeatherTableModel.swift
//  Weather App
//
//  Created by Semyon Chulkov on 01.01.2022.
//

import Foundation

struct WeatherTableModel {
    
    let temperature: Double
    let day: String
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var dayString: String {
        let date = day.toDate()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date!)
        let newDate = Calendar.current.date(from: components)?.toString()
        return newDate!
    }
    
    
}
