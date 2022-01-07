//
//  WeatherManagerDelegate.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didUpdateWeatherTable(_ weatherManager: WeatherManager, weather: [WeatherTableModel])
    
    func didFailWithError(error: Error)
    
    func didFetchPersistedData(_ weatherManager: WeatherManager, weather: WeatherModel)
}
