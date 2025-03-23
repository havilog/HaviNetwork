//
//  ParameterEncodingTests-.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct URLEncodingTests {
  private var sut: ParameterEncodable = URLParameterEncoder()
  private let urlRequest: URLRequest = .init(
    url: .init(string: "https://www.naver.com")!
  )
  
  @Test func nil인_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters? = nil
    let result = try sut.encode(request: urlRequest, with: parameter)
    #expect(result.url?.query == .none)
  }
  
  @Test func empty인_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters = .init()
    let result = try sut.encode(request: urlRequest, with: parameter)
    #expect(result.url?.query == nil)
  }
  
  @Test func 단일_파라미터를_인코드_할_수_있다() throws {
    let parameter: Parameters = ["key": "value"]
    let result = try sut.encode(request: urlRequest, with: parameter)
    #expect(result.url?.query == "key=value")
  }
  
  @Test func 기존_파라미터에_단일_파라미터_추가() throws {
    var mutableURLRequest = urlRequest
    var urlComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)!
    urlComponents.query = "existingKey=existingValue"
    mutableURLRequest.url = urlComponents.url
    
    let paramter: Parameters = ["newKey": "newValue"]
    let result = try sut.encode(request: mutableURLRequest, with: paramter)
    
    #expect(result.url?.query == "existingKey=existingValue&newKey=newValue")
  }
  
  @Test func 여러개의_파라미터가_잘_인코딩되는지() throws {
    let parameters: Parameters = [
      "key1": "value1",
      "key2": "value2",
      "key3": "value3"
    ]
    let result = try sut.encode(request: urlRequest, with: parameters)
    guard 
      let url = result.url,
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    else { Issue.record(); return }
    let encodedItems = queryItems.map { "\($0.name)=\($0.value!)" }
    
    let expectedItems = ["key1=value1", "key2=value2", "key3=value3"]
    #expect(encodedItems.count == expectedItems.count)
    for expectedItem in expectedItems {
      #expect(encodedItems.contains(expectedItem) == true)
    }
  }
  
  @Test func 이미_url에_더하기가_있는경우() throws {
    let parameters = ["foo+": "bar+"]
    let givenURL: URL = .init(string: "https://www.naver.com?existingFoo+=bar")!
    let urlRequest: URLRequest = .init(url: givenURL)
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.absoluteString == "https://www.naver.com?existingFoo+=bar&foo+=bar+")
  }
  
  @Test func 이미_url에_띄어쓰기가_있는경우() throws {
    let parameters = ["foo ": "bar "]
    let givenURL: URL = .init(string: "https://www.naver.com?existingFoo+=bar")!
    let urlRequest: URLRequest = .init(url: givenURL)
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.absoluteString == "https://www.naver.com?existingFoo+=bar&foo%20=bar%20")
  }
  
  @Test func 물음표가_들어간_경우() throws {
    let parameters = ["?foo?": "?bar?"]
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.query == "?foo?=?bar?")
  }
  
  @Test func 띄워쓰기가_들어간_경우() throws {
    let parameters = [" foo ": " bar "]
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.query == "%20foo%20=%20bar%20")
  }
  
  @Test func 허용된_캐릭터셋이_들어간_경우() throws {
    let parameters = ["allowed": "?/"]
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.query == "allowed=?/")
  }
  
  @Test func 허용되지_않은_캐릭터셋이_들어갈_경우() throws {
    let parameters = ["illegal": " \"#%<>[]\\^`{}|"]
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.query == "illegal=%20%22%23%25%3C%3E%5B%5D%5C%5E%60%7B%7D%7C")
  }
  
  @Test func 특수문자와_알파벳이_섞이는_경우() throws {
    let parameters = ["foo": "/bar/baz/qux"]
    let result = try sut.encode(request: urlRequest, with: parameters)
    #expect(result.url?.query == "foo=/bar/baz/qux")
  }
  
  @Test func url이_비어있는경우_실패한다() {
    do {
      var request = urlRequest
      request.url = nil
      _ = try sut.encode(request: request, with: nil)
    }
    catch {
      #expect(error == .missingURL)
    }
  }
  @Test func url이_유효하지않으면_실패한다() {
    let invalidURLString = "http://"
    do {
      let request = URLRequest(url: URL(string: invalidURLString)!)
      _ = try sut.encode(request: request, with: nil)
    }
    catch {
      #expect(error == .invalidURL(invalidURLString))
    }
  }
} 
