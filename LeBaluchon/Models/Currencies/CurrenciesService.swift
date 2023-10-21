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
    
    let baseCurrency = "&base=EUR"
    let targetCurrencies = "&symbols=USD,GBP,JPY,CAD" // https://fr.wikipedia.org/wiki/ISO_4217#Liste_triée_par_nom_d’unité_monétaire
    let baseURL = "https://api.apilayer.com/fixer/latest?apikey="
    
    private var session = URLSession(configuration: .default)
    
    func performCurrenciesRequest(completion: @escaping (Bool) -> Void) {
        
        // Define the URL for API1
        let currenciesURL = URL(string: "https://api.apilayer.com/fixer/latest?apikey=\(apiKey)&\(baseCurrency)&\(targetCurrencies)")!
        var request = URLRequest(url: currenciesURL)
        request.httpMethod = "GET"
        
        APICallServices.shared.performRequest(request: request, cancelTask: true) { (result: Result<CurrenciesResponse, Error>) in
            switch(result) {
            case .success(let response):
                response.saveCurrenciesRates()
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
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
        self.performCurrenciesRequest { success in
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
