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
    
    /// Detect the language of an expression..
    /// - Parameter callback: escape the function with a bool representing the success, a String containing an optionnal language and a String containing an optionnal error message.
    func detectLanguage(callback: @escaping (Bool, String?, String?) -> Void) {
        
        let detectUrl = URL(string: "https://translation.googleapis.com/language/translate/v2/detect/?")!
        var request = URLRequest(url: detectUrl)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&q=\(expressionToTranslate)"//
        request.httpBody = body.data(using: .utf8)
        
        task?.cancel()
        task = detectSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, "Traduction impossible, merci de vérifier votre connexion internet.")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    /// Try to decode the error received
                    guard let decodedErrorResponse = try? JSONDecoder().decode(TranslateError.self, from: data) else {
                        callback(false, nil, "Erreur inattendue.")
                        return
                    }
                    callback(false, nil, decodedErrorResponse.error.message)
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(DetectLanguageResponse.self, from: data) else {
                    callback(false, nil, "Erreur lors de la lecture de la réponse.")
                    return
                }
                let detectResponse: DetectLanguageResponse = decodedResponse
                let detectedLanguage = detectResponse.getDetectedLanguage()
                callback(true, detectedLanguage, nil)
            }
        }
        task?.resume()
    }
    
    /// Get the translation.
    /// - Parameter callback: escape the function with a bool representing the success, a String containing an optionnal translation and a String containing an optionnal error message.
    func getTranslation(callback: @escaping (Bool, String?, String?) -> Void) {

        let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?")!
        var request = URLRequest(url: translateUrl)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&q=\(expressionToTranslate)&source=\(sourceLanguage)&target=\(targetLanguage)&format=text"
        request.httpBody = body.data(using: .utf8)
        
        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, "Traduction impossible, merci de vérifier votre connexion internet.")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    /// Try to decode the error received
                    guard let decodedErrorResponse = try? JSONDecoder().decode(TranslateError.self, from: data) else {
                        callback(false, nil, "Erreur inattendue.")
                        return
                    }
                    callback(false, nil, decodedErrorResponse.error.message)
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(TranslateResponse.self, from: data) else {
                    callback(false, nil, "Erreur lors de la lecture de la réponse.")
                    return
                }
                let translateResponse: TranslateResponse = decodedResponse
                let translation = translateResponse.getTranslation()
                callback(true, translation, nil)
            }
        }
        task?.resume()
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
