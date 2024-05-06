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
    with parameters: HaviNetwork.Parameters?
  ) throws -> URLRequest
}

public struct URLEncoding: ParameterEncodable {
  public init() { }
  public func encode(
    request: URLRequest,
    with parameters: HaviNetwork.Parameters?
  ) throws -> URLRequest {
    guard let parameters else { return request }
    var request = request
    guard 
      let url = request.url 
    else { throw HaviNetwork.EncodingError.missingURL }
    guard 
      var urlComponents = URLComponents(
        url: url,
        resolvingAgainstBaseURL: false
      ) 
    else { return request }
    
    let queryItems = parameters
      .mapValues { "\($0)" }
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

public struct JSONEncoding: ParameterEncodable {
  public init() { }
  public func encode(
    request: URLRequest,
    with parameters: HaviNetwork.Parameters?
  ) throws -> URLRequest {
    guard let parameters else { return request }
    var request = request
    guard 
      JSONSerialization.isValidJSONObject(parameters) 
    else { throw HaviNetwork.EncodingError.invalidJSON }
    
    do {
      let data: Data = try JSONSerialization.data(withJSONObject: parameters)
      request.httpBody = data
    }
    catch {
      throw HaviNetwork.EncodingError.jsonEncodingFailed
    }
    return request
  }
}
