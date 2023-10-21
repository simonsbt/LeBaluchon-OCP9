//
//  APICallServices.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 20/10/2023.
//

import Foundation

class APICallServices {
    
    private var task: URLSessionDataTask?
    static var shared = APICallServices()

    func performRequest<T: Codable>(request: URLRequest, cancelTask: Bool, completion: @escaping (Result<T, Error>) -> Void
    ) {

        if cancelTask {
            task?.cancel()
        }
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(NSError(domain: "HTTP Error", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil)))
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Data Error", code: 0, userInfo: nil)))
                }
            }
        }

        task?.resume()
    }
    
    private init() {}
}
