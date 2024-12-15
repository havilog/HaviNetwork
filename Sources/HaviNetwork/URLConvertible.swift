//
//  URLConvertible.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol URLConvertible: Sendable {
  func asURL() throws(Errors.Configuration) -> URL
}

extension String: URLConvertible {
  public func asURL() throws(Errors.Configuration) -> URL {
    guard 
      let url = URL(string: self) 
    else { throw Errors.Configuration.invalidURL(self) }
    return url
  } 
}

extension URL: URLConvertible {
  public func asURL() throws(Errors.Configuration) -> URL { return self }
}
