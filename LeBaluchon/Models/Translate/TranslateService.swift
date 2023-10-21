//
//  TranslateService.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 27/07/2023.
//

import Foundation

class TranslateService {
    
    private var task: URLSessionDataTask?
    
    static var shared = TranslateService()
    
    var targetLanguage = "en"
    var sourceLanguage = "fr"
    var expressionToTranslate = ""
    
    let languages = ["Français", "Spanish", "Japanese", "English"]
    
    private var translateSession = URLSession(configuration: .default)
    private var detectSession = URLSession(configuration: .default)
    
    func performDetectLanguageRequest(completion: @escaping (Bool, String?) -> Void) {
        
        let detectUrl = URL(string: "https://translation.googleapis.com/language/translate/v2/detect/?")!
        var request = URLRequest(url: detectUrl)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&q=\(expressionToTranslate)"//
        request.httpBody = body.data(using: .utf8)
        
        APICallServices.shared.performRequest(request: request, cancelTask: true) { (result: Result<DetectLanguageResponse, Error>) in
            switch(result) {
            case .success(let response):
                let detectedLanguage = response.getDetectedLanguage()
                completion(true, detectedLanguage)
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func performTranslateRequest(completion: @escaping (Bool, String?) -> Void) {

        let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?")!
        var request = URLRequest(url: translateUrl)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&q=\(expressionToTranslate)&source=\(sourceLanguage)&target=\(targetLanguage)&format=text"
        request.httpBody = body.data(using: .utf8)
        
        APICallServices.shared.performRequest(request: request, cancelTask: true) { (result: Result<TranslateResponse, Error>) in
            switch(result) {
            case .success(let response):
                let translation = response.getTranslation()
                completion(true, translation)
            case .failure(let error):
                print(error)
                completion(false, nil)
                
            }
        }
    }
    
    /// Computed var returning the apiKey from config.plist.
    /// Used to secure apiKey from Git commits.
    private var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
          fatalError("Couldn't find file 'config.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "translateApiKey") as? String else {
          fatalError("Couldn't find key 'translateApiKey' in 'config.plist'.")
        }
        return value
      }
    }
    
    init(detectSession: URLSession, translateSession: URLSession) {
        self.detectSession = detectSession
        self.translateSession = translateSession
    }
    
    private init() {}
    
}
