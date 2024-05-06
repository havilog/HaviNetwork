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
