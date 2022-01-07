//
//  WeatherModel.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import UIKit
// api key: 8e05c03e6b279457f114b23b0c3b3ccb

struct WeatherModel {
    
    let temperature: Double
    let cityName: String
    let conditionID: Int
    let sunrise: Int
    let sunset: Int
    let feelsLike: Double
    let wind: Double
    let humidity: Int
    let population: Int
    
    var temperatureString: String {
        return String(format: "%.0fCº", temperature)
    }

    
    var feelsLikeString: String {
        return String(format: "%.0fCº", feelsLike)
    }
    
    var windString: String {
        return String(format: "%.0f meters/sec", wind)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
    
    var temperatureColor: String {
        switch temperature {
        case ...(-11.0) :
            return "Freezing"
        case (-10.9)...(-4.0) :
            return "Cold"
        case (-3.9)...(3.9):
            return "Zero"
        case 4.0...10.9 :
            return "Warm"
        case 11.0...20.9 :
            return "Hot"
        case 21.0... :
            return "Boiling"
        default :
            return "Zero"
        }
    }
    
    var sunsetString: String {
        let date = NSDate(timeIntervalSince1970: Double(sunset))
        let components = Calendar.current.dateComponents([.hour, .minute], from: date as Date)
        let newDate = Calendar.current.date(from: components)?.toString(withFormat: "HH:mm")
        return newDate!
    }
    var sunriseString: String {
        let date = NSDate(timeIntervalSince1970: Double(sunrise))
        let components = Calendar.current.dateComponents([.hour, .minute], from: date as Date)
        let newDate = Calendar.current.date(from: components)?.toString(withFormat: "HH:mm")
        return newDate!
    }
}
