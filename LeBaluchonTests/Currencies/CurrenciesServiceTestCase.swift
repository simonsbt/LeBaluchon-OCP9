//
//  CurrenciesServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 30/08/2023.
//

import XCTest
@testable import LeBaluchon

final class CurrenciesServiceTestCase: XCTestCase {
    
    func testGetCurrenciesRatesShouldPostFailedCallbackIfError() {
        // Given
        let currenciesService = CurrenciesService(session: URLSessionFake(data: nil, response: nil, error: FakeCurrenciesResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldPostFailedCallbackIfNoData() {
        // Given
        let currenciesService = CurrenciesService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let currenciesService = CurrenciesService(session: URLSessionFake(data: FakeCurrenciesResponseData.correctData, response: FakeCurrenciesResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let currenciesService = CurrenciesService(session: URLSessionFake(data: FakeCurrenciesResponseData.incorrectData, response: FakeCurrenciesResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    
}

