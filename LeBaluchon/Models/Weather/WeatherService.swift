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
    
    func performCurrenciesRequest(cityLatLon: String, completion: @escaping (Bool, WeatherResponse?) -> Void) {
        
        let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&\(cityLatLon)&\(units)&\(language)")!
        var request = URLRequest(url: weatherURL)
        request.httpMethod = "GET"
        
        APICallServices.shared.performRequest(request: request, cancelTask: false) { (result: Result<WeatherResponse, Error>) in
            switch(result) {
            case .success(let response):
                completion(true, response)
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
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
