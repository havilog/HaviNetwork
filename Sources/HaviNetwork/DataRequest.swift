//
//  DataRequest.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

#if !os(macOS)
public final class DataRequest {
  private let session: any NetworkSession
  private let monitor: (any NetworkMonitorable)?
  private let endpoint: any URLRequestConfigurable
  private let interceptors: [Interceptor]
  
  public init(
    session: any NetworkSession,
    monitor: (any NetworkMonitorable)? = NetworkMonitor.shared,
    endpoint: any URLRequestConfigurable,
    interceptors: [Interceptor]
  ) {
    self.session = session
    self.monitor = monitor
    self.endpoint = endpoint
    self.interceptors = interceptors
  }
  
  @MainActor
  public func response<Model: Decodable>(with decoder: JSONDecoder = .init()) async throws -> Model {
    do {
      let urlRequest: URLRequest = try await makeURLRequest()
      monitor?.willRequest(urlRequest)
      let response: Response = try await fetchResponse(with: urlRequest)
      monitor?.didReceive(data: response.data, response: response.response)
      try validate(response)
      let result: Model = try decode(response, with: decoder)
      return result
    }
    catch {
      monitor?.didReceive(error: error)
      throw error
    }
  }
  
  private func makeURLRequest() async throws -> URLRequest {
    var urlRequest: URLRequest = try endpoint.asURLRequest()
    for interceptor in interceptors {
      urlRequest = try await interceptor.adapt(urlRequest: urlRequest)
    }
    return urlRequest
  }
  
  private func fetchResponse(with urlRequest: URLRequest) async throws -> Response {
    let (data, urlResponse) = try await session.data(for: urlRequest)
    let response: Response = Response(data: data, response: urlResponse)
    return response
  }
  
  private func validate(_ response: Response) throws {
    guard let httpResponse = response.response as? HTTPURLResponse else {
      throw ResponseError.invalidResponse
    }
    
    guard httpResponse.statusCode.isValid else {
      throw ResponseError.invalidStatusCode(httpResponse.statusCode)
    }
  }
  
  private func decode<Model: Decodable>(
    _ response: Response,
    with decoder: JSONDecoder
  ) throws -> Model {
    do {
      let model = try decoder.decode(Model.self, from: response.data)
      return model
    }
    catch {
      throw DecodingError.failedToDecode(error)
    }
  }
}

fileprivate extension Int {
  var isValid: Bool { return (200..<300).contains(self) }
}
#endif
