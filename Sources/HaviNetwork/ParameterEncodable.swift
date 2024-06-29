//
//  ParameterEncodable.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public protocol ParameterEncodable {
  func encode(
    request: URLRequest,
    with parameters: Parameters?
  ) throws -> URLRequest
}

extension ParameterEncodable where Self == URLParameterEncoder {
  public static var url: URLParameterEncoder { return .init() }
}

extension ParameterEncodable where Self == JSONParameterEncoder {
  public static var json: JSONParameterEncoder { return .init() }
}

public struct URLParameterEncoder: ParameterEncodable {
  public init() { }
  public func encode(
    request: URLRequest,
    with parameters: Parameters?
  ) throws -> URLRequest {
    guard let parameters else { return request }
    var request = request
    guard 
      let url = request.url 
    else { throw EncodingError.missingURL }
    guard 
      var urlComponents = URLComponents(
        url: url,
        resolvingAgainstBaseURL: false
      ) 
    else { return request }
    
    let queryItems = parameters
      .map { key, value in
        let stringValue: String = "\(value)"
        let percentEncodedKey: String = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
        let percentEncodedValue: String = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? stringValue
        return (percentEncodedKey, percentEncodedValue)
      }
      .compactMap(URLQueryItem.init)
    
    if urlComponents.percentEncodedQueryItems == nil {
      urlComponents.percentEncodedQueryItems = queryItems
    } else {
      urlComponents.percentEncodedQueryItems?.append(contentsOf: queryItems)
    } 
    
    request.url = urlComponents.url
    
    return request
  }
}

public struct JSONParameterEncoder: ParameterEncodable {
  public init() { }
  public func encode(
    request: URLRequest,
    with parameters: Parameters?
  ) throws -> URLRequest {
    guard let parameters else { return request }
    var request = request
    guard 
      JSONSerialization.isValidJSONObject(parameters) 
    else { throw EncodingError.invalidJSON }
    
    do {
      let data: Data = try JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
      request.httpBody = data
    }
    catch {
      throw EncodingError.jsonEncodingFailed
    }
    return request
  }
}
