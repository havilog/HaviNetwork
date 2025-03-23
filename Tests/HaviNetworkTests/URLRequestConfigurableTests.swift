//
//  URLRequestConfigurableTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
@testable @preconcurrency import HaviNetwork

fileprivate struct Endpoint: URLRequestConfigurable, @unchecked Sendable {
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

struct URLRequestConfigurableTests {
  static let baseURLString: String = "https://www.naver.com"
  
  @Test func url만_있을때() throws {
    let endpoint: Endpoint = .init()
    
    let result = try endpoint.asURLRequest()
    
    #expect(result.url?.absoluteString == URLRequestConfigurableTests.baseURLString)
    #expect(result.httpMethod == "GET")
    #expect(result.url?.query == .none)
    #expect(result.allHTTPHeaderFields == .init())
    #expect(result.httpBody == .none)
  }
  
  @Test func path를_추가했을때() throws {
    let endpoint: Endpoint = .init(path: "foo")
    
    let result = try endpoint.asURLRequest()
    
    #expect(result.url?.absoluteString == "\(URLRequestConfigurableTests.baseURLString)/foo")
    #expect(result.httpMethod == "GET")
    #expect(result.url?.query == .none)
    #expect(result.allHTTPHeaderFields == .init())
    #expect(result.httpBody == .none)
  }
  
  @Test func json_parameters를_추가했을때() throws {
    let endpoint: Endpoint = .init(parameters: ["foo": "bar"], encoder: .json)
    
    let result = try endpoint.asURLRequest()
    
    #expect(result.url?.absoluteString == URLRequestConfigurableTests.baseURLString)
    #expect(result.httpMethod == "GET")
    #expect(result.url?.query == .none)
    #expect(result.allHTTPHeaderFields == .init())
    #expect(result.httpBody?.asString == "{\"foo\":\"bar\"}")
  }
  
  @Test func url_parameters를_추가했을때() throws {
    let endpoint: Endpoint = .init(parameters: ["foo": "bar"])
    
    let result = try endpoint.asURLRequest()
    
    #expect(result.url?.absoluteString == "\(URLRequestConfigurableTests.baseURLString)?foo=bar")
    #expect(result.httpMethod == "GET")
    #expect(result.url?.query == "foo=bar")
    #expect(result.allHTTPHeaderFields == .init())
    #expect(result.httpBody == .none)
  }
  
  @Test func header를_추가했을때() throws {
    let endpoint: Endpoint = .init(headers: [.init(key: "foo", value: "bar")])
    
    let result = try endpoint.asURLRequest()
    
    #expect(result.url?.absoluteString == URLRequestConfigurableTests.baseURLString)
    #expect(result.httpMethod == "GET")
    #expect(result.url?.query == .none)
    #expect(result.allHTTPHeaderFields == ["foo": "bar"])
    #expect(result.httpBody == .none)
  }
}
