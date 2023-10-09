//
//  Currencies.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import Foundation

struct CurrenciesResponse: Codable {
    let success: Bool
    let base: String
    let rates: [String: Double]
    
    init() {
        self.success = true
        self.base = ""
        self.rates = ["": 1]
    }
    
    func saveCurrenciesRates() {
        let currenciesRatesKey = ["USD", "GBP", "JPY", "CAD"]
        
        for (currency, rate) in rates {
            print("currency : \(currency) = \(rate)")
            for key in currenciesRatesKey {
                if key.contains(currency) {
                    UserDefaults.standard.set(rate, forKey: key)
                    print("\(rate) for the key \(key)")
                }
            }
        }
    }
}
