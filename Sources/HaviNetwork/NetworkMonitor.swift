//
//  NetworkMonitor.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public protocol NetworkMonitorable: Sendable {
  func willRequest(_ request: URLRequest)
  func didReceive(data: Data, response: URLResponse)
  func didReceive(error: Error)
}

public struct NetworkMonitor: NetworkMonitorable {
  public static let shared: Self = .init()
  
  public func willRequest(_ request: URLRequest) {
    let requestURLString = request.url?.absoluteString ?? "" 
    #if DEBUG
    print(payload(message: "👉 \(requestURLString)"))
    #endif
  }
  
  public func didReceive(data: Data, response: URLResponse) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
      let message = String(
        decoding: jsonData, 
        as: UTF8.self
      ).replacingOccurrences(of: "\\/", with: "/")
      #if DEBUG
      print(payload(message: "👈 \(message)"))
      #endif
    }
  }
  
  public func didReceive(error: Error) {
    #if DEBUG
    print(payload(message: "receive error: \(error)"))
    #endif
  }
  
  private func payload(
    file: String = #file,
    function: String = #function,
    message: String
  ) -> String {
    let fileName = URL(string: file)?.lastPathComponent ?? file
    return "\n[\(currentTime())]\n\(fileName)-\(function)\n\(message)\n"
  }
  
  private func currentTime(
    formatter: DateFormatter = .init(),
    dateFormat: String = "yy.MM.dd HH:mm:ss.SSS"
  ) -> String {
    formatter.dateFormat = dateFormat
    return formatter.string(from: .now)
  }
}
