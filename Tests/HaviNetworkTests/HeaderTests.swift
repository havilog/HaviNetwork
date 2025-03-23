//
//  HeaderTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct HeaderTests {
  
  @Test func Dictionary로_잘_변환되는지() {
    let sut: [Header] = [.init(key: "key", value: "value")]
    let expected: [String: String] = ["key": "value"]
    
    #expect(expected == sut.dictionary)
  }
  
  @Test func DictionaryString으로_잘_변환되는지() {
    let sut: Header = .init(key: "key", value: "value")
    let expected: String = "key: value"
    #expect(expected == sut.toDictionaryString)
  }
  
  @Test func 하나의_header가_잘_set_되는지() {
    let header: Header = .init(key: "key", value: "value")
    
    let url: URL = .init(string: "https://www.naver.com")!
    var urlRequest: URLRequest = .init(url: url)
    
    let expected: [String: String] = ["key": "value"]
    
    urlRequest.setHeader(header)
    
    #expect(urlRequest.allHTTPHeaderFields == expected)
    #expect(urlRequest.value(forHTTPHeaderField: "key") == "value")
    #expect(urlRequest.allHTTPHeaderFields?.count == 1)
  }
  
  @Test func 여러개의_Headers가_잘_set_되는지() {
    let header1: Header = .init(key: "key1", value: "value1")
    let header2: Header = .init(key: "key2", value: "value2")
    
    let headers: [Header] = [header1, header2]
    
    let url: URL = .init(string: "https://www.naver.com")!
    var urlRequest: URLRequest = .init(url: url)
    
    urlRequest.setHeaders(headers)
    
    let expected: [String: String] = [
      "key1": "value1",
      "key2": "value2",
    ]
    
    #expect(urlRequest.allHTTPHeaderFields == expected)
  }
}
