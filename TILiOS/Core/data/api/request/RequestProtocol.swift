//
//  RequestProtocol.swift
//  Acronyms
//
//  Created by Eduard on 26.03.2023.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var addAuthorizationToken: Bool { get }
    var requestType: RequestType { get }
}

extension RequestProtocol {
    var host: String {
        APIConstants.host
    }
   
    var addAuthorizationToken: Bool {
        true
    }
    
    var params: [String: Any] {
        [:]
    }
    var urlParams: [String: String?] {
        [:]
    }
    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest(authToken: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = 8080
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if addAuthorizationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}

enum RequestType: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum APIConstants {
    static let host = "localhost"
    static let clientSecret = "secret"
}

public enum NetworkError: LocalizedError {
  case invalidServerResponse
  case invalidURL
    
  public var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "The server returned an invalid response."
    case .invalidURL:
      return "URL string is malformed."
    }
  }
}




enum ResourceRequestError: Error {
  case noData
  case decodingError
  case encodingError
}





import Combine

public enum HTTPError: Error {
    case nonHTTPResponse
    case requestFailed(Int)
    case serverError(Int)
    case networkError(Error)
    case decodingError(DecodingError)
    
    public var isRetriable: Bool {
        switch self {
        case .decodingError:
            return false
            
        case .requestFailed(let status):
            let timeoutStatus = 408
            let rateLimitStatus = 429
            return [timeoutStatus, rateLimitStatus].contains(status)
            
        case .serverError, .networkError, .nonHTTPResponse:
            return true
        }
    }
}

public extension Publisher where Output == (data: Data, response: URLResponse) {
    func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), HTTPError> {
        tryMap { (data: Data, response: URLResponse) in
            guard let http = response as? HTTPURLResponse else { throw HTTPError.nonHTTPResponse }
            return (data, http)
        }
        .mapError { error in
            if error is HTTPError {
                return error as! HTTPError
            } else {
                return HTTPError.networkError(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == (data: Data, response: HTTPURLResponse), Failure == HTTPError {
    func responseData() -> AnyPublisher<Data, HTTPError> {
        tryMap { (data: Data, response: HTTPURLResponse) -> Data in
            switch response.statusCode {
            case 200: return data
            case 400...499:
                throw HTTPError.requestFailed(response.statusCode)
            case 500...599:
                throw HTTPError.serverError(response.statusCode)
            default:
                fatalError("Unhandled HTTP Response Status code: \(response.statusCode)")
            }
        }
        .mapError { $0 as! HTTPError }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == Data, Failure == HTTPError {
    func decoding<Item, Coder>(type: Item.Type, decoder: Coder) -> AnyPublisher<Item, HTTPError>
    where Item: Decodable,
    Coder: TopLevelDecoder,
    Self.Output == Coder.Input {
        decode(type: Item.self, decoder: decoder)
            .mapError {
                if $0 is HTTPError {
                    return $0 as! HTTPError
                } else {
                    let decodingError = $0 as! DecodingError
                    return HTTPError.decodingError(decodingError)
                }
            }
            .eraseToAnyPublisher()
    }
}

