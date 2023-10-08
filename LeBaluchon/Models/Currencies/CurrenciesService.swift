//
//  CurrenciesService.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import Foundation

class CurrenciesService {

    private var task: URLSessionDataTask?

    static var shared = CurrenciesService() // Creation of the Singleton pattern.
    
    let currencies = ["USD", "GBP", "JPY", "CAD"]
    var rate: Double = 1.00
    
    private let baseCurrency = "base=EUR"
    private let targetCurrencies = "symbols=USD,GBP,JPY,CAD" /* https://fr.wikipedia.org/wiki/ISO_4217#Liste_triée_par_nom_d’unité_monétaire */
    
    private var session = URLSession(configuration: .default)
    
    /// Fetch the currencies rates.
    /// - Parameter callback: escape the function with a bool representing the success.
    func getCurrenciesRates(callback: @escaping (Bool) -> Void) {
        
        let currenciesUrl = URL(string: "https://api.apilayer.com/fixer/latest?apikey=\(apiKey)&\(baseCurrency)&\(targetCurrencies)")!
        
        task?.cancel()
        task = session.dataTask(with: currenciesUrl) { (data, response, error) in

            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false)
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(CurrenciesResponse.self, from: data) else {
                    callback(false)
                    return
                }
                let currenciesResponse: CurrenciesResponse = decodedResponse
                currenciesResponse.saveCurrenciesRates()
                callback(true)
            }
        }
        task?.resume()
    }

    /// Checks if the API has already been called during the day.
    /// If not, calls the API and saves the rates.
    /// - Parameter callback: escape the function with a bool representing the success.
    func callAPI(callback: @escaping (Bool) -> Void) {
        if let lastAPICallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date {
            if Calendar.current.isDateInToday(lastAPICallDate) {
                callback(true)
                return
            }
        }
        self.getCurrenciesRates { (success) in
            if success {
                UserDefaults.standard.set(Date(), forKey: "lastAPICallDate") // Save the date of the call.
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func convertValue(value: Double, senderTag: Int) -> String {
        if senderTag == 1 {
            let convertedValue = value * rate
            let roundedValue = Double(round(100 * convertedValue) / 100)
            return String(roundedValue)
        } else {
            let convertedValue = value / rate
            let roundedValue = Double(round(100 * convertedValue) / 100)
            return String(roundedValue)
        }
    }
    
    /// Computed var returning the apiKey from config.plist.
    /// Used to secure apiKey from Git commits.
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
                fatalError("Couldn't find file 'config.plist'.")
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "currenciesApiKey") as? String else {
                fatalError("Couldn't find key 'currenciesApiKey' in 'config.plist'.")
            }
            return value
        }
    }
    
    init(session: URLSession) {
        self.session = session
    }

    private init() {}
}
