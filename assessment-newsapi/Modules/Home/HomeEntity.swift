//
//  HomeEntity.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation

// MARK: - NewsEntity
struct NewsEntity: Codable {
    let status: String?
    let code: String?
    let message: String?
    let totalResults: Int?
    let articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case status, totalResults, articles, code, message
    }
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

// MARK: - Categories
enum Category: String, CaseIterable {
    case all
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    var text: String {
        return rawValue.capitalized
    }
    
    var searchParam: String? {
        return self == .all ? nil : self.text
    }
}

