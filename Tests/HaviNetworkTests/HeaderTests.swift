//
//  HeaderTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

final class HeaderTests: XCTestCase {
  
  override func setUpWithError() throws {
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
  
  func test_Dictionary로_잘_변환되는지() {
    let sut: [Header] = [.init(key: "key", value: "value")]
    let expected: [String: String] = ["key": "value"]
    
    XCTAssertEqual(expected, sut.dictionary)
  }
  
  func test_DictionaryString으로_잘_변환되는지() {
    let sut: Header = .init(key: "key", value: "value")
    let expected: String = "key: value"
    XCTAssertEqual(expected, sut.toDictionaryString)
  }
  
  func test_하나의_header가_잘_set_되는지() {
    let header: Header = .init(key: "key", value: "value")
    
    let url: URL = .init(string: "https://www.naver.com")!
    var urlRequest: URLRequest = .init(url: url)
    
    let expected: [String: String] = ["key": "value"]
    
    urlRequest.setHeader(header)
    
    XCTAssertEqual(urlRequest.allHTTPHeaderFields, expected)
    XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "key"), "value")
    XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, 1)
  }
  
  func test_여러개의_Headers가_잘_set_되는지() {
    let header1: Header = .init(key: "key1", value: "value1")
    let header2: Header = .init(key: "key2", value: "value2")
    
    let headers: [Header] = [header1, header2]
    
    let url: URL = .init(string: "https://www.naver.com")!
    var urlRequest: URLRequest = .init(url: url)
    
    urlRequest.setHeaders(headers)
    
    let expected: [String: String] = [
      "key1": "value1",
      "key2": "value2",
    ]
    
    XCTAssertEqual(urlRequest.allHTTPHeaderFields, expected)
  }
}
