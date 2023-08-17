//
//  WeatherResponse.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 17/08/2023.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Double?
    let wind: Wind?
//    let rain: Rain?
//    let snow: Snow?
    let clouds: Clouds?
    let dt: Double?
    let sys: Sys?
    let timezone: Double?
    let id: Double?
    let name: String?
    let cod: Double?
}

struct Coord: Codable {
    let lat: Double?
    let lon: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Double?
    let sea_level: Double?
    let grnd_level: Double?
}

struct Sys: Codable {
    let type: Double?
    let id: Double?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}

struct Clouds: Codable {
    let all: Double?
}

//struct Rain: Codable {
//    let one_hour: Double?
//    let three_hours: Double?
//
//    private enum CodingKeys: String, CodingKey { case one_hour = "1h", three_hours = "3h"}
//}
//
//struct Snow: Codable {
//    let one_hour: Double?
//    let three_hours: Double?
//
//    private enum CodingKeys: String, CodingKey { case one_hour = "1h", three_hours = "3h"}
//}

struct Wind: Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}
