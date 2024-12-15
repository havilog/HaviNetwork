//
//  Interceptor.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public enum RetryResult {
  case retry
  case doNotRetry(with: Error)
}

public protocol Interceptor {
  func adapt(urlRequest: URLRequest) async throws(Errors) -> URLRequest
  func retry(
    urlRequest: URLRequest, 
    response: URLResponse?,
    data: Data?, 
    with error: any Error
  ) async -> (URLRequest, RetryResult)
}
