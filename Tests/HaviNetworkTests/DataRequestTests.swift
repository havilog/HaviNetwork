//
//  DataRequestTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 5/6/24.
//

import XCTest
@testable import HaviNetwork

#if !os(macOS)
final class DataRequestTests: XCTestCase {
  private var sut: DataRequest!
  
  private var testURLString = "https://www.test.com"
  private lazy var testURL = URL(string: testURLString)!
  private var testData = "test data".data(using: .utf8)!
  private lazy var testSuccessResponse = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
  private lazy var testErrorResponse = HTTPURLResponse(url: testURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
  
  override func setUp() async throws {
    try await super.setUp()
  }
  
  override func tearDown() async throws {
    try await super.tearDown()
    sut = .none
  }
  
  // MARK: makeURLRequest
  
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
        case let .configuration(configurationError) = error,
        case let .invalidURL(urlConvertible) = configurationError,
        let urlString = urlConvertible as? String
      else { XCTFail();return }
      
      XCTAssertEqual(urlString, invalidURLString)
    }
  }
  
  func test_data를_가져올때_에러를_맞을_경우() async throws {
    let mockNetwork = MockNetworkSession { _ in 
      throw NSError(domain: "123", code: 123)
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
        case let .session(sessionError) = error,
        case .dataRequestFailed = sessionError
      else { 
        XCTFail(); return
      }
    }
  }
  
  // MARK: Decode
  
  func test_DecodingError를_맞아서_실패할경우() async throws {
    let response = testSuccessResponse
    let mockNetwork: NetworkSession = MockNetworkSession { urlRequest in
      let data = "some invalid format of data".data(using: .utf8)!
      return (data, response)
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
        case let .decoding(decodingError) = error,
        case let .failedToDecode(decodingError) = decodingError,
        case .dataCorrupted = decodingError
      else { XCTFail();return }
    }
  }
  
  // MARK: Validate
  
  func test_statusCode가_유효하지_않은경우() async throws  {
    let data = testData
    let response = testErrorResponse
    let mockNetwork = MockNetworkSession(dataHandler: { _ in (data, response) })
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
        case let .response(responseError) = error,
        case let .invalidStatusCode(statusCode) = responseError
      else { XCTFail(); return }
      
      XCTAssertEqual(statusCode, testErrorResponse.statusCode) 
    }
  }
  
  func test_response가_유효하지_않은경우() async throws  {
    let data = testData
    let response = URLResponse()
    let mockNetwork = MockNetworkSession(dataHandler: { _ in (data, response) })
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
        case let .response(responseError) = error,
        case .invalidResponse = responseError
      else { XCTFail();return }
    }
  }
}
#endif
