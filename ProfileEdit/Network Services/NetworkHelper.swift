//
//  NetworkHelper.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit

public enum AppError: Error, CustomStringConvertible {
    case badURL(String) // associated value
    case noResponse
    case networkClientError(Error) // no internet connection
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case badStatusCode(Int) // 404, 500
    case badMimeType(String) // image/jpg
    
    public var description: String {
        switch self {
        case .decodingError(let error):
            return "\(error)"
        case .badStatusCode(let code):
            return "Bad status code of \(code) returned from web api"
        case .encodingError(let error):
            return "encoding error: \(error)"
        case .networkClientError(let error):
            return "network error: \(error)"
        case .badURL(let url):
            return "\(url) is a bad url"
        case .noData:
            return "no data returned from web api"
        case .noResponse:
            return "no response returned from web api"
        case .badMimeType(let mimeType):
            return "Verify your mime type found a \(mimeType) mime type"
        }
    }
}

class NetworkHelper {
    
    private let urlSession: URLSession
    public static let shared = NetworkHelper()
    
    private init() {
        urlSession = URLSession(configuration: .default)
    }
    
    public func performDataTask(with request: URLRequest, completion: @escaping (Result<Data, AppError>) ->()) {
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            switch urlResponse.statusCode {
            case 200...299:
                break
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
