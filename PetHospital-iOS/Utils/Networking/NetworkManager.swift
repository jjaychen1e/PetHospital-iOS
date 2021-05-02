//
//  NetworkManager.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/18.
//

import Foundation
import Alamofire

/// This class in an encapsulation of Alamofire.DataRequest.

class DataRequest {
    private var request: Alamofire.DataRequest
    
    init(request: Alamofire.DataRequest) {
        self.request = request
    }
    
    func cancel() {
        self.request.cancel()
    }
}

enum NetworkManagerError: Error {
    case emptyData
}

/// This class is an encapsulation of Alamofire for decoupling. We define our classes, enums, and structs like
/// `NetworkManager` and `HTTPMethod`, and use them in all other places in our code, instead of using
/// Alamofire directly. So one day, if we want to replace Alamofire with another framework, the only thing we
/// need to do is to modify this file.

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {
        
    }
    
    /// We should provide a non-generic version if parameter is `nil`. And this method can only support GET.
    @discardableResult
    func fetch<T: Decodable>(endPoint: Endpoint, method: HTTPMethod = .GET, completionHandler: @escaping (Result<T, Error>) -> ()) -> DataRequest {
        fetch(fullURL: BaseAddress + endPoint.rawValue, method: method, completionHandler: completionHandler)
    }
    
    @discardableResult
    func fetch<T: Decodable, P: Encodable>(endPoint: Endpoint, method: HTTPMethod = .GET, parameters: P? = nil, completionHandler: @escaping (Result<T, Error>) -> ()) -> DataRequest {
        fetch(fullURL: BaseAddress + endPoint.rawValue,
              method: method,
              parameters: parameters, completionHandler: completionHandler)
    }
    
    /// We should provide a non-generic version if parameter is `nil`. And this method can only support GET.
    @discardableResult
    func fetch<T: Decodable>(fullURL: String, method: HTTPMethod = .GET, completionHandler: @escaping (Result<T, Error>) -> ()) -> DataRequest {
        // TODO: Do we need json encoder?
        let request = AF.request(fullURL,
                                 method: method.convertToAlamofireHTTPMethod())
            .response { (request) in
                if let error = request.error {
                    print(error)
                    completionHandler(.failure(error))
                    return
                }
                
                if let data = request.data {
                    do {
                        let decodeResult = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(decodeResult))
                    } catch {
                        print("Error encoutered when decode:\n - \(error).\n - URL: \(request.request?.url?.absoluteString ?? "nil")\n - Decoded string from data: \(String(data: data, encoding: .utf8) ?? "nil")")
                        completionHandler(.failure(error))
                        return
                    }
                } else {
                    completionHandler(.failure(NetworkManagerError.emptyData))
                    return
                }
            }
        return DataRequest(request: request)
    }
    
    @discardableResult
    func fetch<T: Decodable, P: Encodable>(fullURL: String, method: HTTPMethod = .GET, parameters: P? = nil, completionHandler: @escaping (Result<T, Error>) -> ()) -> DataRequest {
        let request = AF.request(fullURL,
                                 method: method.convertToAlamofireHTTPMethod(),
                                 parameters: parameters,
                                 encoder: method == .POST ? JSONParameterEncoder.default : URLEncodedFormParameterEncoder.default)
            .response { (request) in
                if let error = request.error {
                    print(error)
                    completionHandler(.failure(error))
                    return
                }
                
                if let data = request.data {
                    
                    #if DEBUG
                        print("Network data parsed:\n - URL: \(request.request?.url?.absoluteString ?? "nil")\n - Decoded string from data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    #endif
                    
                    do {
                        let decodeResult = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(decodeResult))
                        return
                    } catch {
                        print("Error encoutered when decode:\n - \(error).\n - URL: \(request.request?.url?.absoluteString ?? "nil")\n - Decoded string from data: \(String(data: data, encoding: .utf8) ?? "nil")")
                        completionHandler(.failure(error))
                        return
                    }
                } else {
                    completionHandler(.failure(NetworkManagerError.emptyData))
                    return
                }
            }
        return DataRequest(request: request)
    }
}

enum HTTPMethod: String {
    case GET  = "GET"
    case POST = "POST"
    
    fileprivate func convertToAlamofireHTTPMethod() -> Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod(rawValue: self.rawValue.uppercased())
    }
}
