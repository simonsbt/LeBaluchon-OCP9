//
//  DetectFakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 18/09/2023.
//

import Foundation

class DetectFakeResponseData {
    
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
    
    class DetectError: Error {}
    static let error = DetectError()
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    static var correctData: Data? {
        let bundle = Bundle(for: DetectFakeResponseData.self)
        let url = bundle.url(forResource: "DetectLanguage", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
