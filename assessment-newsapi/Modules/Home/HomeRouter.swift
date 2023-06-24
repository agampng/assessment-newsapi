//
//  HomeRouter.swift
//  assessment-newsapi
//
//  Created by Agam on 23/06/23.
//

import UIKit

class HomeRouter {
    static func createModule() -> HomeView {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        let storyboardId = String(describing: HomeView.self)
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: storyboardId) as? HomeView else {
            fatalError("Error loading Storyboard")
        }
        view.presenter = presenter
        return view
    }
}
