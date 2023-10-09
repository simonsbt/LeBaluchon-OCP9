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
    
    let citiesLatLon = ["lat=50.43333&lon=2.8333", "lat=40.7127&lon=-74.0059", "lat=35.0210700&lon=135.7538500"]
    
    private let units = "units=metric"
    private let language = "lang=fr"
    
    private var weatherSession = URLSession(configuration: .default)
    
    /// Get the weather.
    /// - Parameter callback: escape the function with a bool representing the success, an object containing an optionnal WeatherResponse and a String containing an optionnal error message.
    func getWeather(cityLatLon: String, callback: @escaping (Bool, WeatherResponse?, String?) -> Void) {
        
        let weatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&\(cityLatLon)&\(units)&\(language)")!

        task = weatherSession.dataTask(with: weatherUrl) { (data, response, error) in

            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, "Impossible de récupérer les données, merci de vérifier votre connexion internet.")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    /// Try to decode the error received
                    guard let decodedErrorResponse = try? JSONDecoder().decode(WeatherError.self, from: data) else {
                        callback(false, nil, "Erreur inattendue.")
                        return
                    }
                    callback(false, nil, decodedErrorResponse.message)
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    callback(false, nil, "Erreur lors de la lecture de la réponse.")
                    return
                }
                let weatherResponse: WeatherResponse = decodedResponse
                callback(true, weatherResponse, nil)
            }
        }
        task?.resume()
    }
    
    /// Computed var returning the apiKey from config.plist.
    /// Used to secure apiKey from Git commits.
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

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    private init() {}
}
