//
//  Response.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public struct Response {
  public let data: Data
  public let response: URLResponse
  
  public init(data: Data, response: URLResponse) {
    self.data = data
    self.response = response
  }
}
