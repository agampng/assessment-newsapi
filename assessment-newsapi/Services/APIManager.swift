//
//  APIManager.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation
import Alamofire

enum APIError: Error {
    case networkError
    case unauthorized
    case decodingError
    case unknownError
}

class ApiManager {
    private static let session = Session()
}

extension ApiManager {
    func requestAsync<T: Codable>(_ endpoint: Endpoint, timeout: TimeInterval = 60) async throws -> T {
        return try await withUnsafeThrowingContinuation({ continuation in
            ApiManager.session.request(
                endpoint.urlString(),
                method: endpoint.method(),
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers,
                interceptor: nil,
                requestModifier: { $0.timeoutInterval = timeout })
            .responseData(
                queue: .main,
                dataPreprocessor: DataResponseSerializer.defaultDataPreprocessor,
                emptyResponseCodes: [200, 401],
                emptyRequestMethods: DataResponseSerializer.defaultEmptyRequestMethods) { response in
                    if let error = response.error {
                        continuation.resume(throwing: error)
                    } else {
                        guard let urlResponse = response.response else {
                            continuation.resume(throwing: APIError.unknownError)
                            return
                        }
                        switch urlResponse.statusCode {
                        case 401:
                            continuation.resume(throwing: APIError.unauthorized)
                        default:
                            if let data = response.data {
                                do {
                                    let decoded = try JSONDecoder().decode(T.self, from: data)
                                    continuation.resume(returning: decoded)
                                } catch {
                                    continuation.resume(throwing: error)
                                }
                            } else {
                                continuation.resume(throwing: APIError.unknownError)
                            }
                        }
                    }
                }
        })
    }
}
