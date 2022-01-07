//
//  WeatherData.swift
//  Weather App
//
//  Created by Semyon Chulkov on 14.12.2021.
//

import Foundation

struct WeatherData: Codable {
//    let cod: String
//    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    //let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let snow: Snow?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, snow, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    //let main: MainEnum
    //let weatherDescription: Description
    //let icon: Icon

    enum CodingKeys: String, CodingKey {
        case id
        //case weatherDescription = "description"
        //case icon
    }
}

enum MainEnum: String, Codable {
    case clouds = "Clouds"
    case snow = "Snow"
    case clear = "Clear"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

