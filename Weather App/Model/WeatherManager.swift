//
//  WeatherManager.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import CoreLocation
import CoreData
import UIKit

class WeatherManager {
    
    let weatherFiveDaysURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=8e05c03e6b279457f114b23b0c3b3ccb&units=metric"
    
    var delegate: WeatherManagerDelegate?
    var persistedWeather: NSManagedObject?
    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherFiveDaysURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let lat = String(format: "%.2f", latitude)
        let lon = String(format: "%.2f", longitude)
        let urlString = "\(weatherFiveDaysURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            DispatchQueue.main.async {
                                self.delegate?.didUpdateWeather(self, weather: weather)
                            }
                        }
                        if let weather5Days = self.parseJSONFor5Days(safeData) {
                            DispatchQueue.main.async {
                                self.delegate?.didUpdateWeatherTable(self, weather: weather5Days)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didFailWithError(error: error!)
                    }
                    return
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let city = decodedData.city.name
            let temp = decodedData.list[0].main.temp
            let cond = decodedData.list[0].weather[0].id
            let sunrise = decodedData.city.sunrise
            let sunset = decodedData.city.sunset
            let population = decodedData.city.population
            let wind = decodedData.list[0].wind.speed
            let feelsLike = decodedData.list[0].main.feelsLike
            let humidity = decodedData.list[0].main.humidity
            
            let weather = WeatherModel(temperature: temp, cityName: city, conditionID: cond, sunrise: sunrise, sunset: sunset, feelsLike: feelsLike, wind: wind, humidity: humidity, population: population)
            save(weather: weather)
            
            return weather
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFailWithError(error: error)
            }
            return nil
        }
    }
    
    func parseJSONFor5Days(_ weatherData: Data) -> [WeatherTableModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            var weather5Days = [WeatherTableModel]()
            
            var currentDate = Date()
            let calendar = Calendar(identifier: .gregorian)
            
            for i in decodedData.list {
                if !(calendar.isDate(i.dtTxt.toDate()!, inSameDayAs: currentDate)) {
                    let temp = i.main.temp
                    let day = i.dtTxt
                    let weather = WeatherTableModel(temperature: temp, day: day)
                    print(weather)
                    weather5Days.append(weather)
                    currentDate = i.dtTxt.toDate()!
                }
            }
            
            return weather5Days
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFailWithError(error: error)
            }
            print(error)
            return nil
        }
    }
    
    func fetchPersistedWeather() {
        let context = container.viewContext
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistedWeatherModel")
        
        do {
            persistedWeather = try context.fetch(fetchData)[0] as? NSManagedObject
        } catch {
            print("Unable to fetch data")
        }
        
        guard let persistedWeather = persistedWeather else {
            fatalError("There is no persisted weather")
        }
        
        let temperature = persistedWeather.value(forKey: "temperature")
        let cityName = persistedWeather.value(forKey: "cityName")
        let conditionID = persistedWeather.value(forKey: "conditionID")
        let sunrise = persistedWeather.value(forKey: "sunrise")
        let sunset = persistedWeather.value(forKey: "sunset")
        let feelsLike = persistedWeather.value(forKey: "feelsLike")
        let wind = persistedWeather.value(forKey: "wind")
        let humidity = persistedWeather.value(forKey: "humidity")
        let population = persistedWeather.value(forKey: "population")
        
        let weather = WeatherModel(temperature: temperature as! Double, cityName: cityName as! String, conditionID: conditionID as! Int, sunrise: sunrise as! Int, sunset: sunset as! Int, feelsLike: feelsLike as! Double, wind: wind as! Double, humidity: humidity as! Int, population: population as! Int)
        print(weather)
        
        delegate?.didFetchPersistedData(self, weather: weather)
    }
    
    
    func save(weather: WeatherModel) {
    
        let managedContext = container.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PersistedWeatherModel",
                                   in: managedContext)!
        
        // delete previously saved entity
        
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistedWeatherModel")
        do {
            if let item = try managedContext.fetch(fetchData)[0] as? NSManagedObject {
                managedContext.delete(item)
                try managedContext.save()
                print("Deleted data")
            }
        } catch {
            print("Unable to fetch data")
        }
    
        let object = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        object.setValue(Int64(weather.humidity), forKeyPath: "humidity")
        object.setValue(Int64(weather.sunset), forKeyPath: "sunset")
        object.setValue(Int64(weather.sunrise), forKeyPath: "sunrise")
        object.setValue(Int64(weather.population), forKeyPath: "population")
        object.setValue(weather.cityName, forKeyPath: "cityName")
        object.setValue(weather.wind, forKeyPath: "wind")
        object.setValue(weather.feelsLike, forKeyPath: "feelsLike")
        object.setValue(Int64(weather.conditionID), forKeyPath: "conditionID")
        object.setValue(weather.temperature, forKeyPath: "temperature")
        
        
        
        // append new entity
        do {
            try managedContext.save()
            persistedWeather = object
            //print(persistedWeather)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}

