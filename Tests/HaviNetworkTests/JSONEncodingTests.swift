//
//  JSONEncodingTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct JSONEncodingTests {
  private var sut: ParameterEncodable = JSONParameterEncoder()
  private let urlRequest: URLRequest = .init(
    url: .init(string: "https://www.naver.com")!
  )
  
  @Test func nil인_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters? = nil
    
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    #expect(result.httpBody == .none)
  }
  
  @Test func empty인_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters? = .init()
    
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    #expect(result.httpBody?.asString == "{}")
  }
  
  @Test func 단일_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters = ["key": "value"]
    
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    #expect(result.httpBody?.asString == "{\"key\":\"value\"}")
  }
  
  @Test func 다중_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters = [
      "key1": "value1",
      "key2": "value2",
    ]
    let expected: String = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
    
    let result = try sut.encode(request: urlRequest, with: parameter)
    
    if let httpBody = result.httpBody?.asString {
      #expect(expected == httpBody)
    } else {
      Issue.record()
    }
  }
  
  @Test func 복잡한_파라미터를_인코드_할_수_있다() throws {
    let parameters: [String: Any] = [
      "foo": "bar",
      "baz": ["a", 1, true],
      "qux": [
        "a": 1,
        "b": [2, 2],
        "c": [3, 3, 3]
      ]
    ]
    
    let request = try sut.encode(request: urlRequest, with: parameters)
    
    #expect(request.url?.query == .none)
    #expect(request.httpBody != .none)
    
    #expect(
      try request.httpBody?.asJSONObject() as? NSObject ==
      parameters as NSObject,
      "Decoded request body and parameters should be equal."
    )
  }
  
  @Test func invalid한_json은_인코드_할_수_없다() {
    let parameters: [String: Any] = [
        "validKey": "validValue",
        "invalidKey": Date() // JSON으로 변환 불가능한 타입
    ]

    do {
      _ = try sut.encode(request: urlRequest, with: parameters)
    }
    catch {
      #expect(error == .invalidJSON)
    }
  }
}
