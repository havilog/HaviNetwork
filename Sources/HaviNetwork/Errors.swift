//
//  Error.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public enum Errors: Swift.Error, Sendable {
  case encoding(Encoding)
  case configuration(Configuration)
  case decoding(Decoding)
  case session(Session)
  case response(Response)
  case unknown
  
  public enum Encoding: Swift.Error, Sendable {
    case missingURL
    case invalidJSON
    case jsonEncodingFailed
  }

  public enum Configuration: Swift.Error, Sendable {
    case invalidURL(URLConvertible)
  }

  public enum Decoding: Swift.Error, Sendable {
    case failedToDecode(Swift.DecodingError)
    case unknown
  }
  
  public enum Session: Swift.Error, Sendable {
    case dataRequestFailed
  }

  public enum Response: Swift.Error, Sendable {
    case invalidResponse
    case invalidStatusCode(Int)
  }
}
