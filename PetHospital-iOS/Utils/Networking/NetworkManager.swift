//
//  NetworkManager.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/18.
//

import Foundation
import Alamofire

/// This class is an encapsulation of Alamofire for decoupling. We define our classes, enums, and structs like
/// `NetworkManager` and `HTTPMethod`, and use them in all other places in our code, instead of using
/// Alamofire directly. So one day, if we want to replace Alamofire with another framework, the only thing we
/// need to do is to modify this file.

class DataRequest {
    private var request: Alamofire.DataRequest
    
    init(request: Alamofire.DataRequest) {
        self.request = request
    }
    
    func cancel() {
        self.request.cancel()
    }
}


class NetworkManager {
    
    /// We should provide a non-generic version if parameter is `nil`. And this method can only support GET.
    static func fetch<T: Decodable>(endPoint: EndPoint, completionHandler: @escaping (T?) -> ()) -> DataRequest {
        let request = AF.request(BaseAddress + endPoint.rawValue,
                                 method: .get,
                                 headers: nil)
            .response { (data) in
                guard data.error != nil else {
                    print(data.error!)
                    completionHandler(nil)
                    return
                }
                
                if let data = data.data {
                    do {
                        let decodeResult = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(decodeResult)
                    } catch {
                        print("Error encoutered when decode. \(error)")
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            }
        return DataRequest(request: request)
    }
    
    static func fetch<T: Decodable, P: Encodable>(endPoint: EndPoint, method: HTTPMethod = .GET, parameters: P? = nil, completionHandler: @escaping (T?) -> ()) -> DataRequest {
        let request = AF.request(BaseAddress + endPoint.rawValue,
                                 method: method.convertToAlamofireHTTPMethod(),
                                 parameters: parameters,
                                 encoder: URLEncodedFormParameterEncoder.default,
                                 headers: nil)
            .response { (data) in
                guard data.error != nil else {
                    print(data.error!)
                    completionHandler(nil)
                    return
                }
                
                if let data = data.data {
                    do {
                        let decodeResult = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(decodeResult)
                    } catch {
                        print("Error encoutered when decode. \(error)")
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            }
        return DataRequest(request: request)
    }
}

public enum HTTPMethod: String {
    case GET  = "GET"
    case POST = "POST"
    
    func convertToAlamofireHTTPMethod() -> Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod(rawValue: self.rawValue.uppercased())
    }
}
