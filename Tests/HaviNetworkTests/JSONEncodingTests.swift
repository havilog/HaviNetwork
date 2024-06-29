//
//  JSONEncodingTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

final class JSONEncodingTests: XCTestCase {
  private var sut: ParameterEncodable!
  private let urlRequest: URLRequest = .init(
    url: .init(string: "https://www.naver.com")!
  )
  
  override func setUp() async throws {
    try await super.setUp()
    sut = JSONParameterEncoder()
  }
  
  override func tearDown() async throws {
    try await super.tearDown()
    sut = .none
  }
  
  func test_nil() throws {
    // given
    let parameter: Parameters? = nil
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertNil(result.httpBody)
  }
  
  func test_empty() throws {
    // given
    let parameter: Parameters? = .init()
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertEqual(result.httpBody?.asString, "{}")
  }
  
  func test_단일_파라미터() throws {
    // given
    let parameter: Parameters = ["key": "value"]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertEqual(result.httpBody?.asString, "{\"key\":\"value\"}")
  }
  
  func test_다중_파라미터() throws {
    // given
    let parameter: Parameters = [
      "key1": "value1",
      "key2": "value2",
    ]
    let expected: String = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    if let httpBody = result.httpBody?.asString {
      XCTAssertEqual(expected, httpBody)
    } else {
      XCTFail()
    }
  }
  
  func test_복잡한_파라미터() throws {
    // given
    let parameters: [String: Any] = [
      "foo": "bar",
      "baz": ["a", 1, true],
      "qux": [
        "a": 1,
        "b": [2, 2],
        "c": [3, 3, 3]
      ]
    ]
    
    // when
    let request = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertNil(request.url?.query)
    XCTAssertNotNil(request.httpBody)
    
    XCTAssertEqual(try request.httpBody?.asJSONObject() as? NSObject,
                   parameters as NSObject,
                   "Decoded request body and parameters should be equal.")
  }
}
