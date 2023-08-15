//
//  CurrenciesService.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import Foundation

class CurrenciesService {
    
    let currencies = ["USD", "GBP", "JPY", "CAD"]
    private static let baseCurrency = "base=EUR"
    private static let targetCurrencies = "symbols=USD,GBP,JPY,CAD" /* https://fr.wikipedia.org/wiki/ISO_4217#Liste_triée_par_nom_d’unité_monétaire */
    private static let apikey = "apikey=xxxxxxxxxx"
    private let currenciesUrl = URL(string: "https://api.apilayer.com/fixer/latest?" + apikey + "&" + baseCurrency + "&" + targetCurrencies)!
    private var currenciesResponse = CurrenciesResponse()
    
    func getCurrenciesRates() {
        print("enter in the getCurrenciesRates func")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: currenciesUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(CurrenciesResponse.self, from: data) {
                print("Response decoded successfully")
                self.currenciesResponse = decodedResponse
                self.currenciesResponse.saveCurrenciesRates()
            }
        }
        task.resume()
    }
}
