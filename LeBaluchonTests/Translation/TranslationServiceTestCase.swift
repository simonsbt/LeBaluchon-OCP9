//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 18/09/2023.
//

import XCTest
@testable import LeBaluchon

final class TranslationServiceTestCase: XCTestCase {

    func testGetTranslationShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: nil, response: nil, error: TranslateFakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.incorrectData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }

    
    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.getTranslation(callback: { success, _, _ in
            
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }

}
