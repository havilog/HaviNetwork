//
//  MockNetworkSession.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import Foundation
@testable import HaviNetwork

struct MockNetworkSession: NetworkSession {
  var dataHandler: (URLRequest) async throws -> (Data, URLResponse)
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    try await dataHandler(request)
  }
} 

struct MockResponse: Decodable {
  let response: String
}

struct MockEndpoint: URLRequestConfigurable {
  var url: URLConvertible = "https://www.naver.com"
  var path: String? = nil
  var method: HTTPMethod = .get
  var parameters: Parameters? = nil
  var headers: [Header]? = nil
  var encoder: ParameterEncodable = URLParameterEncoder()
}

struct MockInterceptor: Interceptor {
  var adaptHandler: (URLRequest) async throws -> URLRequest = { urlRequest in return urlRequest }
  var retryHandler: (URLRequest, URLResponse?, Data?, any Error) async -> (URLRequest, RetryResult) = { urlRequest, _, _, error in return (urlRequest, .doNotRetry(with: error)) }
  
  func adapt(urlRequest: URLRequest) async throws -> URLRequest {
    return try await adaptHandler(urlRequest)
  }
  
  func retry(
    urlRequest: URLRequest,
    response: URLResponse?,
    data: Data?,
    with error: any Error
  ) async -> (URLRequest, RetryResult) {
    return await retryHandler(urlRequest, response, data, error)
  }
}
