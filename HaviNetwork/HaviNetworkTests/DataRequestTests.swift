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
}
