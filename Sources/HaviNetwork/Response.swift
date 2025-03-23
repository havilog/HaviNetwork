//
//  Response.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public struct Response: Sendable {
  public let data: Data
  public let response: URLResponse
  
  public init(data: Data, response: URLResponse) {
    self.data = data
    self.response = response
  }
}
