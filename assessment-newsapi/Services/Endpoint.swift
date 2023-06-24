//
//  Endpoint.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation
import Alamofire

// MARK: - Endpoint
enum Endpoint {
    case headlines(category: String, page: String)
}

// MARK: - Path
extension Endpoint {
    func path() -> String {
        switch self {
        case .headlines:
            return "/top-headlines"
        }
    }
}

// MARK: - HTTP Method
extension Endpoint {
    func method() -> HTTPMethod {
        return .get
    }
}

// MARK: - Parameters
extension Endpoint {
    var parameters: [String: Any]? {
        switch self {
        case .headlines(let category, let page):
            let params: [String: Any] = [
                "category": category,
                "page": page,
                "pageSize": "10",
                "language": "en"
            ]
            return params
        default:
            return [:]
        }
    }
}

// MARK: - Headers
extension Endpoint {
    var headers: HTTPHeaders {
        return ["Authorization": Constants.apiKey]
    }
}

// MARK: - Parameter Endcoding
extension Endpoint {
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}

// MARK: - URL String
extension Endpoint {
    func urlString() -> String {
        return Constants.baseURL + path()
    }
}
