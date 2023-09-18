//
//  WeatherFakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 18/09/2023.
//

import Foundation

class WeatherFakeResponseData {
    
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
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    static var correctData: Data? {
        let bundle = Bundle(for: WeatherFakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
