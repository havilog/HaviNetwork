//
//  InterceptorTetsts.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct InterceptorTests {
  let urlRequest: URLRequest = .init(url: .init(string: "https://www.naver.com")!)
  
  @Test func interceptor에서_한개의_헤더를_잘_추가할_수_있다() async throws {
    let mockInterceptor: MockInterceptor = .init(
      adaptHandler: { urlRequest in
        var newRequest = urlRequest
        newRequest.setHeader(.contentType(value: "application/json"))
        return newRequest
      } 
    )
    
    let newURLRequest = try await mockInterceptor.adapt(urlRequest: urlRequest)
    #expect(newURLRequest.allHTTPHeaderFields == ["Content-Type": "application/json"])
  }
  
  @Test func interceptor에서_여러개의_헤더를_잘_추가할_수_있다() async throws {
    let mockInterceptor: MockInterceptor = .init(
      adaptHandler: { urlRequest in
        var newRequest = urlRequest
        newRequest.setHeaders([
          .contentType(value: "application/json"),
          .authorization("authorization"),
          .userAgent(value: "userAgent"),
          .init(key: "havi", value: "zzang"),
        ])
        return newRequest
      } 
    )
    
    let newURLRequest = try await mockInterceptor.adapt(urlRequest: urlRequest)
    #expect(
      newURLRequest.allHTTPHeaderFields == 
      [
        "Content-Type": "application/json",
        "Authorization": "authorization",
        "User-Agent": "userAgent",
        "havi": "zzang",
      ]
    )
  }
  
  @Test func ineterceptor에서_throw한_에러를_처리할_수_있다() async  {
    let throwingInterceptor: MockInterceptor = .init(adaptHandler:{ urlRequest in
      throw NSError(domain: "test", code: 111)
    })
    do {
      _ = try await throwingInterceptor.adapt(urlRequest: urlRequest)
      Issue.record("this test must fail")
    }
    catch {
      #expect((error as NSError).domain == "test")
      #expect((error as NSError).code == 111)
    }
  }
}
