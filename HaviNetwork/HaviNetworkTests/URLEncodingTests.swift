//
//  ParameterEncodingTests-.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

final class URLEncodingTests: XCTestCase {
  private var sut: ParameterEncodable!
  private let urlRequest: URLRequest = .init(
    url: .init(string: "https://www.naver.com")!
  )
  
  override func setUp() async throws {
    try await super.setUp()
    sut = URLParameterEncoder()
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
      XCTAssertNil(result.url?.query)
    }
    catch {
      XCTFail()
    }
  }
  
  func test_empty() {
    // given
    let parameter: HaviNetwork.Parameters = .init()
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: parameter)
      
      // then
      XCTAssertEqual(result.url?.query, "")
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
      XCTAssertEqual(
        result.url?.query(),
        "key=value"
      )
    }
    catch {
      XCTFail()
    }
  }
  
  func test_기존_파라미터에_단일_파라미터_추가() {
    // given
    var mutableURLRequest = urlRequest
    var urlComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)!
    urlComponents.query = "existingKey=existingValue"
    mutableURLRequest.url = urlComponents.url
    
    let paramter: HaviNetwork.Parameters = ["newKey": "newValue"]
    
    do {
      // when
      let result = try sut.encode(request: mutableURLRequest, with: paramter)
      
      // then
      XCTAssertEqual(
        result.url?.query(),
        "existingKey=existingValue&newKey=newValue"
      )
    }
    catch {
      XCTFail()
    }
  }
  
  func test_여러개의_파라미터가_잘_인코딩되는지() {
    // given
    let paramter: HaviNetwork.Parameters = [
      "key1": "value1",
      "key2": "value2",
      "key3": "value3",
    ]
    
    do {
      // when
      let result = try sut.encode(request: urlRequest, with: paramter)
      
      // then
      let separatedResult = Set<String>((result.url?.query()?.split(separator: "&").map(String.init))!)
      XCTAssertEqual(
        separatedResult,
        Set<String>([
          "key1=value1",
          "key2=value2",
          "key3=value3"
        ])
      )
    }
    catch {
      XCTFail()
    }
  }
} 
