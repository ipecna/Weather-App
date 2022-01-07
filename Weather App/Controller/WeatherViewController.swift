//
//  ViewController.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: ViewController<WeatherView> {
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var currentWeather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        customView.delegate = self
        weatherManager.delegate = self
        
        navigationItem.titleView = customView.searchBar
    }
}

extension WeatherViewController: WeatherViewDelegate {
    
    func prepareDetail() {
        let vc = DetailWeatherViewController()
        vc.currentWeather = currentWeather
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchTapped(searchString: String) {
        weatherManager.fetchWeather(cityName: searchString)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension WeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeatherTable(_ weatherManager: WeatherManager, weather: [WeatherTableModel]) {
        customView.dataSource.weather = weather
        customView.tableView.reloadData()
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        customView.updateWeather(with: weather)
        currentWeather = weather
    }
    
    func didFailWithError(error: Error) {
        let ac = UIAlertController(title: "Ooops", message: "Try again?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.weatherManager.fetchPersistedWeather()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    func didFetchPersistedData(_ weatherManager: WeatherManager, weather: WeatherModel) {
        customView.updateWeather(with: weather)
        currentWeather = weather
    }
}
