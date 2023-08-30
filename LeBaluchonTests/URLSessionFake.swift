//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 30/08/2023.
//

import Foundation

class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}
