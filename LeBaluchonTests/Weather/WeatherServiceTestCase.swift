//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Simon Sabatier on 18/09/2023.
//

import XCTest
@testable import LeBaluchon

final class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: nil, response: nil, error: WeatherFakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityLatLon: "test", callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityLatLon: "", callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.2)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: WeatherFakeResponseData.correctData, response: WeatherFakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityLatLon: "", callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: WeatherFakeResponseData.incorrectData, response: WeatherFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityLatLon: "", callback: { success, _, _ in
            
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.2)
    }

    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: WeatherFakeResponseData.correctData, response: WeatherFakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(cityLatLon: "", callback: { success, weather, message in
            
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.2)
    }

}
