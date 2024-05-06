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
  
  func test_nil() {
    // given
    let parameter: HaviNetwork.Parameters? = nil
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: parameter)
      
      // then
      XCTAssertNil(result.httpBody)
    }
    catch {
      XCTFail()
    }
  }
  
  func test_empty() {
    // given
    let parameter: HaviNetwork.Parameters? = .init()
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: parameter)
      
      // then
      XCTAssertEqual(result.httpBody?.asString, "{}")
    }
    catch {
      XCTFail()
    }
  }
  
  func test_단일_파라미터() {
    // given
    let parameter: HaviNetwork.Parameters = ["key": "value"]
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: parameter)
      
      // then
      XCTAssertEqual(result.httpBody?.asString, "{\"key\":\"value\"}")
    }
    catch {
      XCTFail()
    }
  }
  
  func test_다중_파라미터() {
    // given
    let parameter: HaviNetwork.Parameters = [
      "key1": "value1",
      "key2": "value2",
    ]
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: parameter)
      
      let candidate1: String = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
      let candidate2: String = "{\"key2\":\"value2\",\"key1\":\"value1\"}"
      let candidates: [String] = [candidate1, candidate2]
      
      // then
      if let httpBody = result.httpBody?.asString {
        XCTAssertTrue(candidates.contains(httpBody))
      } else {
        XCTFail()
      }
    }
    catch {
      XCTFail()
    }
  }
}
