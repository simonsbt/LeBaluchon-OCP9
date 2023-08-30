//
//  FakeCurrenciesResponseData.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 30/08/2023.
//

import Foundation

class FakeCurrenciesResponseData {
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: [:]
    )!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: [:]
    )!
    
    class CurrenciesRatesError: Error {}
    static let error = CurrenciesRatesError()
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeCurrenciesResponseData.self)
        let url = bundle.url(forResource: "CurrenciesRates", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
