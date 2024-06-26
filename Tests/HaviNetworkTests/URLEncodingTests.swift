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
  
  func test_nil() throws {
    // given
    let parameter: Parameters? = nil
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertNil(result.url?.query)
  }
  
  func test_empty() throws {
    // given
    let parameter: Parameters = .init()
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertEqual(result.url?.query, "")
  }
  
  func test_단일_파라미터() throws {
    // given
    let parameter: Parameters = ["key": "value"]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "key=value"
    )
  }
  
  func test_기존_파라미터에_단일_파라미터_추가() throws {
    // given
    var mutableURLRequest = urlRequest
    var urlComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)!
    urlComponents.query = "existingKey=existingValue"
    mutableURLRequest.url = urlComponents.url
    
    let paramter: Parameters = ["newKey": "newValue"]
    
    // when
    let result = try sut.encode(request: mutableURLRequest, with: paramter)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "existingKey=existingValue&newKey=newValue"
    )
  }
  
  func test_여러개의_파라미터가_잘_인코딩되는지() throws {
    // given
    let parameters: Parameters = [
      "key1": "value1",
      "key2": "value2",
      "key3": "value3"
    ]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    guard 
      let url = result.url,
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    else { XCTFail(); return }
    let encodedItems = queryItems.map { "\($0.name)=\($0.value!)" }
    
    let expectedItems = ["key1=value1", "key2=value2", "key3=value3"]
    XCTAssertEqual(encodedItems.count, expectedItems.count)
    
    // Assert each key-value pair individually
    for expectedItem in expectedItems {
      XCTAssertTrue(encodedItems.contains(expectedItem))
    }
  }
  
  func test_이미_url에_더하기가_있는경우() throws {
    // given
    let parameters = ["foo+": "bar+"]
    let givenURL: URL = .init(string: "https://www.naver.com?existingFoo+=bar")!
    let urlRequest: URLRequest = .init(url: givenURL)
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.absoluteString,
      "https://www.naver.com?existingFoo+=bar&foo+=bar+"
    )
  }
  
  func test_이미_url에_띄어쓰기가_있는경우() throws {
    // given
    let parameters = ["foo ": "bar "]
    let givenURL: URL = .init(string: "https://www.naver.com?existingFoo+=bar")!
    let urlRequest: URLRequest = .init(url: givenURL)
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.absoluteString,
      "https://www.naver.com?existingFoo+=bar&foo%20=bar%20"
    )
  }
  
  func test_물음표가_들어간_경우() throws {
    // given
    let parameters = ["?foo?": "?bar?"]
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "?foo?=?bar?"
    )
  }
  
  func test_띄워쓰기가_들어간_경우() throws {
    // given
    let parameters = [" foo ": " bar "]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "%20foo%20=%20bar%20"
    )
  }
  
  func test_허용된_캐릭터셋이_들어간_경우() throws {
    // given
    let parameters = ["allowed": "?/"]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "allowed=?/"
    )
  }
  
  func test_허용되지_않은_캐릭터셋이_들어갈_경우() throws {
    // given
    let parameters = ["illegal": " \"#%<>[]\\^`{}|"]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "illegal=%20%22%23%25%3C%3E%5B%5D%5C%5E%60%7B%7D%7C"
    )
  }
  
  func test_특수문자와_알파벳이_섞이는_경우() throws {
    // given
    let parameters = ["foo": "/bar/baz/qux"]
    
    // when
    let result = try sut.encode(request: urlRequest, with: parameters)
    
    // then
    XCTAssertEqual(
      result.url?.query(),
      "foo=/bar/baz/qux"
    )
  }
} 
