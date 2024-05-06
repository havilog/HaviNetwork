//
//  URLConvertible.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol URLConvertible {
  func asURL() throws -> URL
}

extension String: URLConvertible {
  public func asURL() throws -> URL {
    guard 
      let url = URL(string: self) 
    else { throw ConfigurationError.invalidURL(self) }
    return url
  } 
}

extension URL: URLConvertible {
  public func asURL() throws -> URL { return self }
}
