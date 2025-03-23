//
//  URLRequestConfigurable.swift
//  HaviNetwork
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public protocol URLRequestConfigurable: Sendable {
  var url: any URLConvertible { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var parameters: Parameters? { get }
  var headers: [Header]? { get }
  var encoder: any ParameterEncodable { get }
  func asURLRequest() throws(Errors) -> URLRequest
}

extension URLRequestConfigurable {
  public func asURLRequest() throws(Errors) -> URLRequest {
    do {
      let convertedURL = try url.asURL()
      var request = URLRequest(url: convertedURL)
      if let path {
        request.url = request.url?.appendingPathComponent(path)
      }
      if let headers { 
        request.setHeaders(headers) 
      }
      request.httpMethod = method.rawValue
      request.allHTTPHeaderFields = headers?.dictionary
      return try encoder.encode(request: request, with: parameters)
    } catch let error as Errors.Configuration {
      throw .configuration(error)
    } catch let error as Errors.Encoding {
      throw .encoding(error)
    } catch {
      throw .unknown
    }
  }
}
