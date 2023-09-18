//
//  DetectionServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 18/09/2023.
//

import XCTest
@testable import LeBaluchon

final class DetectionServiceTestCase: XCTestCase {

    func testDetectLanguageShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: nil, response: nil, error: DetectFakeResponseData.error), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.detectLanguage(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testDetectLanguageShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: nil, response: nil, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.detectLanguage(callback: { success, _, _ in
        
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testDetectLanguageShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseKO, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.detectLanguage(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testDetectLanguageShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.incorrectData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.detectLanguage(callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }

    
    func testDetectLanguageShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(detectSession: URLSessionFake(data: DetectFakeResponseData.correctData, response: DetectFakeResponseData.responseOK, error: nil), translateSession: URLSessionFake(data: TranslateFakeResponseData.correctData, response: TranslateFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.detectLanguage(callback: { success, _, _ in
            
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.01)
    }

}
