//
//  HomeInteractor.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation

class HomeInteractor {
    func headlineNews(page: Int, category: Category, q: String?) async throws -> NewsEntity {
        return try await ApiManager().requestAsync(.headlines( page: "\(page)", category: category.searchParam, q: q))
    }
}
