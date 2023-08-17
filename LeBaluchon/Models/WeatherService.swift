//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 17/08/2023.
//

import Foundation

class WeatherService {

    private var task: URLSessionDataTask?

    static var shared = WeatherService()
    
    let currencies = ["USD", "GBP", "JPY", "CAD"]

    private let lat = "lat=50.73"
    private let lon = "lon=3.1"
    private let units = "units=metric"
    private let language = "lang=fr"
    
    func getWeather(callback: @escaping (Bool, WeatherResponse?) -> Void) {
        
        let weathersUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&\(lat)&\(lon)&\(units)&\(language)")!
        
        print(weathersUrl)
        let session = URLSession(configuration: .default)

        task?.cancel()
        task = session.dataTask(with: weathersUrl) { (data, response, error) in

            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    print("1")
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print(response ?? "kdfoskfosd")
                    callback(false, nil)
                    print("2")
                    return
                }

                guard let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    callback(false, nil)
                    print("3")
                    return
                }

                let weatherResponse: WeatherResponse = decodedResponse

                callback(true, weatherResponse)
            }
        }
        task?.resume()
    }
    
    private var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
          fatalError("Couldn't find file 'config.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "weatherApiKey") as? String else {
          fatalError("Couldn't find key 'weatherApiKey' in 'config.plist'.")
        }
        return value
      }
    }

    private init() {}
}
