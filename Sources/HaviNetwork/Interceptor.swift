//
//  Interceptor.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public enum RetryResult {
  case retry
  case doNotRetry(with: any Error)
}

public protocol Interceptor: Sendable {
  func adapt(urlRequest: URLRequest) async throws(any Error) -> URLRequest
  func retry(
    urlRequest: URLRequest, 
    response: URLResponse?,
    data: Data?, 
    with error: any Error
  ) async -> (URLRequest, RetryResult)
}
