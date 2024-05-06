//
//  DataRequest.swift
//  HaviNetwork
//
//  Created by 한상진 on 5/6/24.
//

import Foundation

public final class DataRequest {
  public let session: NetworkSession
  public let endpoint: URLRequestConfigurable
  public let interceptors: [Interceptor]
  
  public init(
    session: NetworkSession,
    endpoint: URLRequestConfigurable,
    interceptors: [Interceptor]
  ) {
    self.session = session
    self.endpoint = endpoint
    self.interceptors = interceptors
  }
  
  @MainActor
  public func response<Model: Decodable>(with decoder: JSONDecoder = .init()) async throws -> Model {
    let response: Response = try await fetchResponse()
    try validate(response)
    let result: Model = try decode(response, with: decoder)
    return result
  }
  
  private func fetchResponse() async throws -> Response {
    var urlRequest: URLRequest = try endpoint.asURLRequest()
#if DEBUG
    print("👉 Send Request:", urlRequest)
#endif
    for interceptor in interceptors {
      urlRequest = try await interceptor.adapt(urlRequest: urlRequest)
    }
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
    
#if DEBUG
    print("👈 Recieve Response: \n", "\(String(data: response.data, encoding: .utf8) ?? "")", "\n")
#endif
    
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
