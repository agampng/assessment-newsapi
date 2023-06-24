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
    case headlines(page: String, category: String?, q: String?)
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
        case .headlines(let page, let category, let q):
            var params: [String: Any] = [
                "page": page,
                "pageSize": "10",
                "language": "en"
            ]
            
            if let q, !q.isEmpty {
                params["q"] = q
            }
            
            if let category {
                params["category"] = category
            }
            
            return params
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
