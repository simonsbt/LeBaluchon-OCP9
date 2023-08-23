//
//  CurrenciesService.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import Foundation

class CurrenciesService {

    private var task: URLSessionDataTask?

    static var shared = CurrenciesService()
    
    let currencies = ["USD", "GBP", "JPY", "CAD"]
    
    private let baseCurrency = "base=EUR"
    private let targetCurrencies = "symbols=USD,GBP,JPY,CAD" /* https://fr.wikipedia.org/wiki/ISO_4217#Liste_triée_par_nom_d’unité_monétaire */
    
    func getCurrenciesRates(callback: @escaping (Bool, CurrenciesResponse?) -> Void) {
        
        let currenciesUrl = URL(string: "https://api.apilayer.com/fixer/latest?apikey=\(apiKey)&\(baseCurrency)&\(targetCurrencies)")!
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: currenciesUrl) { (data, response, error) in

            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let decodedResponse = try? JSONDecoder().decode(CurrenciesResponse.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                let currenciesResponse: CurrenciesResponse = decodedResponse
                callback(true, currenciesResponse)
            }
        }
        task?.resume()
    }

    func callAPI(callback: @escaping (Bool) -> Void) {
        if let lastAPICallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date {
            if Calendar.current.isDateInToday(lastAPICallDate) {
                self.refreshLastCallDate()
                self.showActivityIndicator(show: false)
                callback(true)
            }
        }
        self.getCurrenciesRates { (success, currencies) in
            if success, let currencies = currencies {
                currencies.saveCurrenciesRates()
                UserDefaults.standard.set(Date(), forKey: "lastAPICallDate")
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    private var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
          fatalError("Couldn't find file 'config.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "currenciesApiKey") as? String else {
          fatalError("Couldn't find key 'currenciesApiKey' in 'config.plist'.")
        }
        return value
      }
    }

    private init() {}
}
