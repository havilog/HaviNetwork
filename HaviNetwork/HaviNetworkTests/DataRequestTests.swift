//
//  DataRequestTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

final class DataRequestTests: XCTestCase {
  private var sut: DataRequest!
  
  private var testURLString = "https://www.test.com"
  private lazy var testURL = URL(string: testURLString)!
  private var testData = "test data".data(using: .utf8)!
  private lazy var testSuccessResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
  private lazy var testErrorResponse = HTTPURLResponse(url: testURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
  
  override func setUp() async throws {
    try await super.setUp()
//    sut = .init(
//      session: <#T##URLSession#>,
//      endpoint: <#T##URLRequestConfigurable#>,
//      interceptors: <#T##[Interceptor]#>
//    )
  }
  
  override func tearDown() async throws {
    try await super.tearDown()
    sut = .none
  }
  
  func test_DecodingError를_맞아서_실패할경우() async throws {
    let mockNetwork: NetworkSession = MockNetworkSession { urlRequest in
      throw DecodingError.failedToDecode(NSError(domain: "123", code: 123))
    }
    sut = .init(
      session: mockNetwork, 
      endpoint: MockEndpoint(),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      XCTFail("this test should throw")
    }
    catch {
      guard 
        let decodingError = error as? DecodingError,
        case let .failedToDecode(anyError) = decodingError
      else { XCTFail();return }
      let nsError = anyError as NSError
      XCTAssertEqual(nsError.domain, "123")
      XCTAssertEqual(nsError.code, 123)
    }
  }
  
  func test_URL이_유효하지않아_실패한경우() async throws {
    let data = testData
    let response = testSuccessResponse
    let mockNetwork: NetworkSession = MockNetworkSession { urlRequest in
      return (data, response)
    }
    let invalidURLString: String = ""
    sut = .init(
      session: mockNetwork,
      endpoint: MockEndpoint(url: invalidURLString),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      XCTFail("this test should throw")
    }
    catch {
      guard 
        let configurationError = error as? ConfigurationError,
        case let .invalidURL(urlConvertible) = configurationError,
        let urlString = urlConvertible as? String
      else { XCTFail();return }
      
      XCTAssertEqual(urlString, invalidURLString)
    }
  }
}
