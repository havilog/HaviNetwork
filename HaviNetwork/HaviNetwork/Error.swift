//
//  Error.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol NetworkError: Error { }

public enum EncodingError: NetworkError {
  case missingURL
  case invalidJSON
  case jsonEncodingFailed
}

public enum ConfigurationError: NetworkError {
  case invalidURL(URLConvertible)
}

public enum DecodingError: NetworkError {
  case failedToDecode(any Error)
  case noData
}

public enum ResponseError: NetworkError {
  case unhandled(error: (any Error)?)
  case invalidStatusCode(Int)
}
