//
//  HomeInteractor.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation

class HomeInteractor {
    func headlineNews(category: Category, page: Int) async throws -> NewsEntity {
        return try await ApiManager().requestAsync(.headlines(category: category.searchParam, page: "\(page)"))
    }
}
