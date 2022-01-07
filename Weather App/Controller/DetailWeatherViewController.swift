//
//  DetailWeatherViewController.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit

class DetailWeatherViewController: ViewController<DetailWeatherView> {
    
    var currentWeather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.updateWeather(with: currentWeather!)
    }
    
}
