//
//  TranslateFakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 05/09/2023.
//

import Foundation

class TranslateFakeResponseData {
    
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
    
    class TranslateError: Error {}
    static let error = TranslateError()
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    static var correctData: Data? {
        let bundle = Bundle(for: TranslateFakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
