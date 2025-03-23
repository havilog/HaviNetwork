//
//  Header.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public struct Header: Hashable, Sendable {
  public let key: String
  public let value: String
  
  public init(key: String, value: String) {
    self.key = key
    self.value = value
  }
}    

extension Header {
  public var toDictionaryString: String {
    return "\(key): \(value)" 
  }
}

public extension Header {
  static func authorization(_ value: String) -> Self {
    return .init(key: "Authorization", value: value)
  }
  static func contentType(value: String) -> Self {
    return .init(key: "Content-Type", value: value)
  }
  static func userAgent(value: String) -> Self {
    return .init(key: "User-Agent", value: value)
  }
}

public extension [Header] {
  var dictionary: [String: String] {
    let namesAndValues = self.map { ($0.key, $0.value) }
    return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
  }
}

public extension URLRequest {
  mutating func setHeaders( _ headers: [Header]) {
    headers.forEach { self.setHeader($0) }
  }
  
  mutating func setHeader( _ header: Header) {
    self.setValue(header.value, forHTTPHeaderField: header.key)
  }
}
