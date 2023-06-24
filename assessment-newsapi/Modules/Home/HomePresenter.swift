//
//  HomePresenter.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import Foundation

class HomePresenter {
    private let interactor: HomeInteractor
    private let router: HomeRouter
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter {
    func getHeadlineNews(category: Category, page: Int) async -> Result<NewsEntity, Error> {
        do {
            let entity = try await interactor.headlineNews(category: category, page: page)
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }
}
