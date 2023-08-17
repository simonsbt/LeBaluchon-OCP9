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
    let sourceLanguage = "fr"
    var expressionToTranslate = ""
    
    let languages = ["English", "Spanish", "Japanese"]
    
    func getTranslation(callback: @escaping (Bool, TranslateResponse?) -> Void) {
        
//        var translateUrl: URL
//        let stringUrl = "https://translation.googleapis.com/language/translate/v2/?" + apiKey + "&q=" + expressionToTranslate + "&source=" + sourceLanguage + "&target=" + targetLanguage + "&format=text"
//        let encodedStringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        if let url = URL(string: encodedStringUrl) {
//            translateUrl = url
//            print(encodedStringUrl)
//        } else {
//            print(encodedStringUrl)
//            return
//        }

        let translateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?")!
        var request = URLRequest(url: translateUrl)
        request.httpMethod = "POST"
        
        let body = "key=\(apiKey)&q=\(expressionToTranslate)&source=\(sourceLanguage)&target=\(targetLanguage)&format=text"
        request.httpBody = body.data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("a")
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("b")
                    callback(false, nil)
                    return
                }
                
                guard let decodedResponse = try? JSONDecoder().decode(TranslateResponse.self, from: data) else {
                    print("c")
                    callback(false, nil)
                    return
                }
                
                let translateResponse: TranslateResponse = decodedResponse
                
                callback(true, translateResponse)
            }
        }
        
        task?.resume()
    }
    
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
    
    private init() {}
    
}
