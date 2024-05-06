//
//  URLConvertibleTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

final class URLConvertibleTests: XCTestCase {
  
  func test_string을_url로_변경할_수_있다() {
    let testURLString = "https://www.example.com"
    
    do {
      let url = try testURLString.asURL()
      XCTAssertEqual(url.absoluteString, testURLString)
    }
    catch {
      XCTFail()
    }
  }
  
  func test_url을_url로_변경할_수_있다() {
    let testURLString = "https://www.example.com"
    let testURL: URL = URL(string: testURLString)!
    do {
      let url = try testURL.asURL()
      XCTAssertEqual(url, testURL)
    }
    catch {
      XCTFail()
    }
  } 
  
  func test_잘못된_urlString을_넣을경우_에러() {
    let invalidURLString = ""
    do {
      _ = try invalidURLString.asURL()
      XCTFail()
    }
    catch {
      guard 
        let configurationError = error as? ConfigurationError,
        case let .invalidURL(urlConvertible) = configurationError,
        let urlString = urlConvertible as? String
      else { XCTFail(); return }
      
      XCTAssertEqual(urlString, invalidURLString)
    }
  }
}
