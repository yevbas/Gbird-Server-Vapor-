//
//  Request.swift
//  TemplatesApp
//
//  Created by Jackson  on 04.05.2022.
//

import Foundation

enum URLs {
    static let stagingURL = ""
}

// MARK: - Request

protocol Request {
    var request: URLRequest { get }
    var isNeededToken: Bool { get }
}

extension Request where Self: RequestDetails {
    var request: URLRequest {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}

// MARK: - RequestDetails

protocol RequestDetails {
    var httpMethod: HTTPMethod { get }
    var urlComponent: URLComponents { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    var path: String { get }
    var url: String { get }
}

extension RequestDetails {
    var headers: [String : String] {
        var headers: [String: String] = [:]
        headers.updateValue(HeaderValue.contentType.rawValue, forKey: HeaderKey.contentType.rawValue)
        return headers
    }

    var urlComponent: URLComponents {
        return URLComponents(string: url + path)!
    }
}
