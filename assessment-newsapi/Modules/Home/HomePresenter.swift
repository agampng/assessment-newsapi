//
//  HomePresenter.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import UIKit

class HomePresenter {
    private let interactor: HomeInteractor
    private let router: HomeRouter
    
    init(interactor: HomeInteractor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - Interactor
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

//MARK: - Router
extension HomePresenter {
    func showSafari(url: URL, on navigation: UINavigationController) {
        router.showSafari(url: url, on: navigation)
    }
}
