//
//  InterceptorTetsts.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/7/24.
//

import XCTest
@testable import HaviNetwork

#if !os(macOS)
final class InterceptorTests: XCTestCase {
  func test_interceptor에서_한개의_헤더를_잘_추가할_수_있다() async throws {
    let mockInterceptor: MockInterceptor = .init(
      adaptHandler: { urlRequest in
        var newRequest = urlRequest
        newRequest.setHeader(.contentType(value: "application/json"))
        return newRequest
      } 
    )
    
    let urlRequest: URLRequest = .init(url: .init(string: "https://www.naver.com")!)
    
    let newURLRequest = try await mockInterceptor.adapt(urlRequest: urlRequest)
    XCTAssertEqual(newURLRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
  }
  
  func test_interceptor에서_여러개의_헤더를_잘_추가할_수_있다() async throws {
    let mockInterceptor: MockInterceptor = .init(
      adaptHandler: { urlRequest in
        var newRequest = urlRequest
        newRequest.setHeaders([
          .contentType(value: "application/json"),
          .init(key: "havi", value: "zzang")
        ])
        return newRequest
      } 
    )
    
    let urlRequest: URLRequest = .init(url: .init(string: "https://www.naver.com")!)
    
    let newURLRequest = try await mockInterceptor.adapt(urlRequest: urlRequest)
    XCTAssertEqual(
      newURLRequest.allHTTPHeaderFields, 
      [
        "Content-Type": "application/json",
        "havi": "zzang"
      ]
    )
  }
}
#endif
