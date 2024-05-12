//
//  URLRequestConfigurable.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol URLRequestConfigurable {
  var url: any URLConvertible { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var parameters: Parameters? { get }
  var headers: [Header]? { get }
  var encoder: any ParameterEncodable { get }
  func asURLRequest() throws -> URLRequest
}

extension URLRequestConfigurable {
  public func asURLRequest() throws -> URLRequest {
    var request = try URLRequest(url: url.asURL())
    if let path { request.url?.append(path: path) }
    if let headers { request.setHeaders(headers) }
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers?.dictionary
    return try encoder.encode(request: request, with: parameters)
  }
}
