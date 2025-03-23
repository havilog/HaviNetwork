//
//  DataRequestTests.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
import Foundation
@testable import HaviNetwork

struct DataRequestTests {
  private let testData = "test data".data(using: .utf8)!
  private let testSuccessResponse = HTTPURLResponse(
    url: URL(string: "https://www.test.com")!,
    statusCode: 200,
    httpVersion: nil,
    headerFields: nil
  )!
  private let testErrorResponse = HTTPURLResponse(
    url: URL(string: "https://www.test.com")!,
    statusCode: 500,
    httpVersion: nil,
    headerFields: nil
  )!
  
  // MARK: makeURLRequest
  
  @Test func URL이_유효하지않아_실패한경우() async throws {
    let mockNetwork: NetworkSession = MockNetworkSession { urlRequest in
      return (testData, testSuccessResponse)
    }
    let invalidURLString: String = ""
    let sut: DataRequest = .init(
      session: mockNetwork,
      endpoint: MockEndpoint(url: invalidURLString),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      Issue.record("this test should throw")
    }
    catch {
      guard 
        case let .configuration(configurationError) = error,
        case let .invalidURL(urlConvertible) = configurationError,
        let urlString = urlConvertible as? String
      else { Issue.record();return }
      
      #expect(urlString == invalidURLString)
    }
  }
  
  @Test func data를_가져올때_에러를_맞을_경우() async throws {
    let mockNetwork = MockNetworkSession { _ in 
      throw NSError(domain: "123", code: 123)
    }
    
    let sut: DataRequest = .init(
      session: mockNetwork,
      endpoint: MockEndpoint(),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      Issue.record("this test should throw")
    }
    catch {
      #expect(error == .session(.dataRequestFailed))
    }
  }
  
  // MARK: Decode
  
  @Test func DecodingError를_맞아서_실패할경우() async throws {
    let response = testSuccessResponse
    let mockNetwork: NetworkSession = MockNetworkSession { urlRequest in
      let data = "some invalid format of data".data(using: .utf8)!
      return (data, response)
    }
    let sut: DataRequest = .init(
      session: mockNetwork, 
      endpoint: MockEndpoint(),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      Issue.record("this test should throw")
    }
    catch {
      guard 
        case let .decoding(decodingError) = error,
        case let .failedToDecode(decodingError) = decodingError,
        case .dataCorrupted = decodingError
      else { Issue.record();return }
      #expect(true)
    }
  }
  
  // MARK: Validate
  
  @Test func statusCode가_유효하지_않은경우() async throws  {
    let data = testData
    let response = testErrorResponse
    let mockNetwork = MockNetworkSession(dataHandler: { _ in (data, response) })
    let sut: DataRequest = .init(
      session: mockNetwork,
      endpoint: MockEndpoint(),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      Issue.record("this test should throw")
    }
    catch {
      guard 
        case let .response(responseError) = error,
        case let .invalidStatusCode(statusCode) = responseError
      else { Issue.record(); return }
      
      #expect(statusCode == testErrorResponse.statusCode) 
    }
  }
  
  @Test func response가_유효하지_않은경우() async throws  {
    let data = testData
    let response = URLResponse()
    let mockNetwork = MockNetworkSession(dataHandler: { _ in (data, response) })
    let sut: DataRequest = .init(
      session: mockNetwork,
      endpoint: MockEndpoint(),
      interceptors: []
    )
    
    do {
      let _: MockResponse = try await sut.response()
      Issue.record("this test should throw")
    }
    catch {
      #expect(error == .response(.invalidResponse))
    }
  }
}
