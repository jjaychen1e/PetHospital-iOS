//
//  URL+Extension.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/29.
//
import Foundation

// Source: https://stackoverflow.com/questions/41421686/get-the-value-of-url-parameters
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
