//
//  WeatherResponse.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 17/08/2023.
//

import Foundation
import UIKit

struct WeatherResponse: Codable {

    let coord: Coord
    let weather: [Weather]
    let main: Main
    let timezone: Int
    let name: String?
    
    func getLocalTime() -> String {
        if let timeZone = TimeZone(secondsFromGMT: timezone ?? 0) {

            let dateFormatter = DateFormatter()

            dateFormatter.timeZone = timeZone
            dateFormatter.dateFormat = "HH:mm"

            return dateFormatter.string(from: Date())
        }
        return "N/A"
    }
    
    func getViewColor() -> UIColor {
        switch(weather?[0].main) {
        case "Rain", "Drizzle", "Thunderstorm":
            return UIColor(named: "rain")!
        case "Snow", "Atmosphere", "Clouds":
            return UIColor(named: "cloud")!
        default:
            return UIColor(named: "clear")!
        }
    }
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    private enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case id, main, icon
    }
}

struct Main: Codable {
    let temp: Double
}
