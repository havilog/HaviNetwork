//
//  NetworkSession.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public protocol NetworkSession: Sendable {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession { }
