//
//  TranslateResponse.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 27/07/2023.
//

import Foundation

struct TranslateResponse: Codable {
    let data: Translations
    
    init() {
        self.data = Translations()
    }
    
    func getTranslation() -> String {
        return data.translations[0].translatedText
    }
}

struct Translations: Codable {
    let translations: [Translation]
    
    init() {
        self.translations = [Translation()]
    }
}

struct Translation: Codable {
    let translatedText: String
    
    init() {
        self.translatedText = "Translation"
    }
}
