//
//  Response.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

struct Response {
  let data: Data?
  let response: URLResponse?
  let error: (any Error)?
  
  init(data: Data?, response: URLResponse?, error: (any Error)?) {
    self.data = data
    self.response = response
    self.error = error
  }
}
