//
//  NetworkMonitor.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol NetworkMonitorable {
  func willRequest(_ request: URLRequest)
  func didReceive(data: Data, response: URLResponse)
  func didReceive(error: Error)
}

public struct NetworkMonitor: NetworkMonitorable {
  public static let shared: Self = .init()
  
  public func willRequest(_ request: URLRequest) {
#if DEBUG
    print(payload(message: request.url?.absoluteString ?? ""))
#endif
  }
  
  public func didReceive(data: Data, response: URLResponse) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
#if DEBUG
      print(payload(message: String(decoding: jsonData, as: UTF8.self)))
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
