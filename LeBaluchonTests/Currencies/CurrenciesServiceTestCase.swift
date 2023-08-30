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
        let currenciesService = CurrenciesService(session: URLSessionFake(data: nil, response: nil, error: CurrenciesFakeResponseData.error))
        
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
        let currenciesService = CurrenciesService(session: URLSessionFake(data: CurrenciesFakeResponseData.correctData, response: CurrenciesFakeResponseData.responseKO, error: nil))
        
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
        let currenciesService = CurrenciesService(session: URLSessionFake(data: CurrenciesFakeResponseData.incorrectData, response: CurrenciesFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    
    func testGetCurrenciesRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let currenciesService = CurrenciesService(session: URLSessionFake(data: CurrenciesFakeResponseData.correctData, response: CurrenciesFakeResponseData.responseOK, error: nil))
        
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        currenciesService.getCurrenciesRates { success in
            
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertCurrenciesShouldReturnMulipliedStringValue() {
        // Given
        let currenciesService = CurrenciesService.shared
        currenciesService.rate = 1.08
        let rate = currenciesService.rate
        let value = 100.0
        let roundedValue = Double(round(100 * (value * rate)) / 100)
        
        // When
        let convertedValue = currenciesService.convertValue(value: value, senderTag: 1)
        
        // Then
        XCTAssertEqual(convertedValue, String(roundedValue))
    }
    
    func testConvertCurrenciesShouldReturnDividedStringValue() {
        // Given
        let currenciesService = CurrenciesService.shared
        currenciesService.rate = 1.08
        let rate = currenciesService.rate
        let value = 100.0
        let roundedValue = Double(round(100 * (value / rate)) / 100)
        
        // When
        let convertedValue = currenciesService.convertValue(value: value, senderTag: 2)
        
        // Then
        XCTAssertEqual(convertedValue, String(roundedValue))
    }
    
    func testConvertCurrenciesShouldNotReturnMulipliedStringValue() {
        // Given
        let currenciesService = CurrenciesService.shared
        currenciesService.rate = 1.08
        let rate = currenciesService.rate
        let value = 100.0
        let roundedValue = Double(round(100 * (value * rate)) / 100)
        
        // When
        let convertedValue = currenciesService.convertValue(value: value, senderTag: 2)
        
        // Then
        XCTAssertNotEqual(convertedValue, String(roundedValue))
    }
    
    func testConvertCurrenciesShouldNotReturnDividedStringValue() {
        // Given
        let currenciesService = CurrenciesService.shared
        currenciesService.rate = 1.08
        let rate = currenciesService.rate
        let value = 100.0
        let roundedValue = Double(round(100 * (value / rate)) / 100)
        
        // When
        let convertedValue = currenciesService.convertValue(value: value, senderTag: 1)
        
        // Then
        XCTAssertNotEqual(convertedValue, String(roundedValue))
    }
    
}

