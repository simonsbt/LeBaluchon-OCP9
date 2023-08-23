//
//  DetectLanguageResponse.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 23/08/2023.
//

import Foundation

struct DetectLanguageResponse: Codable {
    let data: DetectionData
    
    func getDetectedLanguage() -> String {
        return data.detections[0][0].language
    }
}

struct DetectionData: Codable {
    let detections: [[Detection]]
}

struct Detection: Codable {
    let language: String
}
