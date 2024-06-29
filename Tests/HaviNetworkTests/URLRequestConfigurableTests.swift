//
//  URLRequestConfigurableTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/12/24.
//

import XCTest
@testable import HaviNetwork

#if !os(macOS)
final class URLRequestConfigurableTests: XCTestCase {
  static let baseURLString: String = "https://www.naver.com"
  
  struct Endpoint: URLRequestConfigurable {
    var url: any HaviNetwork.URLConvertible
    var path: String?
    var method: HaviNetwork.HTTPMethod
    var parameters: HaviNetwork.Parameters?
    var headers: [HaviNetwork.Header]?
    var encoder: any HaviNetwork.ParameterEncodable
    
    init(
      url: any HaviNetwork.URLConvertible = URLRequestConfigurableTests.baseURLString,
      path: String? = nil,
      method: HaviNetwork.HTTPMethod = .get,
      parameters: HaviNetwork.Parameters? = nil,
      headers: [HaviNetwork.Header]? = nil,
      encoder: any HaviNetwork.ParameterEncodable = .url
    ) {
      self.url = url
      self.path = path
      self.method = method
      self.parameters = parameters
      self.headers = headers
      self.encoder = encoder
    }
  }
  
  func test_url만_있을때() throws {
    // given
    let endpoint: Endpoint = .init()
    
    // when
    let result = try endpoint.asURLRequest()
    
    // then
    XCTAssertEqual(result.url?.absoluteString, URLRequestConfigurableTests.baseURLString)
    XCTAssertEqual(result.httpMethod, "GET")
    XCTAssertNil(result.url?.query())
    XCTAssertEqual(result.allHTTPHeaderFields, .init())
    XCTAssertNil(result.httpBody)
  }
  
  func test_path를_추가했을때() throws {
    // given
    let endpoint: Endpoint = .init(path: "foo")
    
    // when
    let result = try endpoint.asURLRequest()
    
    // then
    XCTAssertEqual(result.url?.absoluteString, "\(URLRequestConfigurableTests.baseURLString)/foo")
    XCTAssertEqual(result.httpMethod, "GET")
    XCTAssertNil(result.url?.query())
    XCTAssertEqual(result.allHTTPHeaderFields, .init())
    XCTAssertNil(result.httpBody)
  }
  
  func test_json_parameters를_추가했을때() throws {
    // given
    let endpoint: Endpoint = .init(parameters: ["foo": "bar"], encoder: .json)
    
    // when
    let result = try endpoint.asURLRequest()
    
    // then
    XCTAssertEqual(result.url?.absoluteString, URLRequestConfigurableTests.baseURLString)
    XCTAssertEqual(result.httpMethod, "GET")
    XCTAssertNil(result.url?.query())
    XCTAssertEqual(result.allHTTPHeaderFields, .init())
    XCTAssertEqual(result.httpBody?.asString, "{\"foo\":\"bar\"}")
  }
  
  func test_url_parameters를_추가했을때() throws {
    // given
    let endpoint: Endpoint = .init(parameters: ["foo": "bar"])
    
    // when
    let result = try endpoint.asURLRequest()
    
    // then
    XCTAssertEqual(result.url?.absoluteString, "\(URLRequestConfigurableTests.baseURLString)?foo=bar")
    XCTAssertEqual(result.httpMethod, "GET")
    XCTAssertEqual(result.url?.query(), "foo=bar")
    XCTAssertEqual(result.allHTTPHeaderFields, .init())
    XCTAssertNil(result.httpBody)
  }
  
  func test_header를_추가했을때() throws {
    // given
    let endpoint: Endpoint = .init(headers: [.init(key: "foo", value: "bar")])
    
    // when
    let result = try endpoint.asURLRequest()
    
    // then
    XCTAssertEqual(result.url?.absoluteString, URLRequestConfigurableTests.baseURLString)
    XCTAssertEqual(result.httpMethod, "GET")
    XCTAssertNil(result.url?.query())
    XCTAssertEqual(result.allHTTPHeaderFields, ["foo": "bar"])
    XCTAssertNil(result.httpBody)
  }
}
#endif
