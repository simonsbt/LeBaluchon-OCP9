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
    
    let citiesLatLon = ["lat=50.43333&lon=2.8333", "lat=40.7127&lon=-74.0059", "lat=35.0210700&lon=135.7538500"]

    private let latLonLens = "lat=50.43333&lon=2.8333"
    private let latLonNY = "lat=40.7127&lon=-74.0059"
    private let latLonKyoto = "lat=35.0210700&lon=135.7538500"
    
    private let units = "units=metric"
    private let language = "lang=fr"
    
    func getWeather(cityLatLon: String, callback: @escaping (Bool, WeatherResponse?) -> Void) {
        
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&\(cityLatLon)&\(units)&\(language)")!
        
        let session = URLSession(configuration: .default)

        //task?.cancel()
        task = session.dataTask(with: weatherUrl) { (data, response, error) in

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
