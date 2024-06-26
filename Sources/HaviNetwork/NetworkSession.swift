//
//  NetworkSession.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

#if !os(macOS)
public protocol NetworkSession {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession { }
#endif
