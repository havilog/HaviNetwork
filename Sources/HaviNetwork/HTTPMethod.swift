//
//  HTTPMethod.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

@frozen
public enum HTTPMethod: String {
  case get = "GET"
  case head = "HEAD"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}
