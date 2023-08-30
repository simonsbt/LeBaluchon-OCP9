//
//  URLSessionsDataTaskFake.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 30/08/2023.
//

import Foundation

class URLSessionDataTaskFake: URLSessionDataTask {
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    override func cancel() {}
}
