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
    
    private static let baseCurrency = "base=EUR"
    private static let targetCurrencies = "symbols=USD,GBP,JPY,CAD" /* https://fr.wikipedia.org/wiki/ISO_4217#Liste_triée_par_nom_d’unité_monétaire */
    private static let apikey = "apikey=xxxxxxxxxx"
    
    func getCurrenciesRates() {
        
        let currenciesUrl = URL(string: "https://api.apilayer.com/fixer/latest?\(apikey)&\(baseCurrency)&\(targetCurrencies)")!
        
        let session = URLSession(configuration: .default)
        
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
                currenciesResponse.saveCurrenciesRates()
            }
        }
        task.resume()!
    }
}
