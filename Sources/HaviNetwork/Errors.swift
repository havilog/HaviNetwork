//
//  Error.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public enum Errors: Swift.Error, Sendable, Equatable {
  case encoding(Encoding)
  case configuration(Configuration)
  case decoding(Decoding)
  case session(Session)
  case response(Response)
  case intercept(any Error)
  case unknown
}
extension Errors {
  public static func == (lhs: Errors, rhs: Errors) -> Bool {
    switch (lhs, rhs) {
    case let (.encoding(left), .encoding(right)): 
      return left == right
    case let (.configuration(left), .configuration(right)): 
      return left == right
    case let (.decoding(left), .decoding(right)): 
      return left == right
    case let (.session(left), .session(right)): 
      return left == right
    case let (.response(left), .response(right)): 
      return left == right
    case let (.intercept(left), .intercept(right)): 
      return left.localizedDescription == right.localizedDescription
    case (.unknown, .unknown): 
      return true
    default:
      return false
    }
  }
}

extension Errors {
  public enum Encoding: Swift.Error, Sendable, Equatable {
    case missingURL
    case invalidURL(any URLConvertible)
    case invalidJSON
    case jsonEncodingFailed
  }
}
extension Errors.Encoding {
  public static func == (lhs: Errors.Encoding, rhs: Errors.Encoding) -> Bool {
    switch (lhs, rhs) {
    case (.missingURL, .missingURL):
      return true
    case let (.invalidURL(leftURLConvertible), .invalidURL(rightURLConvertible)):
      let left = try? leftURLConvertible.asURL()
      let right = try? rightURLConvertible.asURL()
      return left == right
    case (.invalidJSON, .invalidJSON):
      return true
    case (.jsonEncodingFailed, .jsonEncodingFailed):
      return true
    default:
      return false
    }
  }
}

extension Errors {
  public enum Configuration: Swift.Error, Sendable, Equatable {
    case invalidURL(any URLConvertible)
  }
}
extension Errors.Configuration {
  public static func == (lhs: Errors.Configuration, rhs: Errors.Configuration) -> Bool {
    switch (lhs, rhs) {
    case let (.invalidURL(leftURLConvertible), .invalidURL(rightURLConvertible)):
      let left = try? leftURLConvertible.asURL()
      let right = try? rightURLConvertible.asURL()
      return left == right
    }
  }
}

extension Errors {
  public enum Decoding: Swift.Error, Sendable, Equatable {
    case failedToDecode(Swift.DecodingError)
    case unknown
  }
}
extension Errors.Decoding {
  public static func == (lhs: Errors.Decoding, rhs: Errors.Decoding) -> Bool {
    switch (lhs, rhs) {
    case let (.failedToDecode(leftDecodingError), .failedToDecode(rightDecodingError)):
      return leftDecodingError.failureReason == rightDecodingError.failureReason
    case (.unknown, .unknown):
      return true
    default:
      return false
    }
  }
}

extension Errors {
  public enum Session: Swift.Error, Sendable, Equatable {
    case dataRequestFailed
  }
}

extension Errors {
  public enum Response: Swift.Error, Sendable, Equatable {
    case invalidResponse
    case invalidStatusCode(Int)
  }
}
