//
//  HomePresenter.swift
//  WebViewTest
//
//  Created sopra on 16/11/20.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

final class HomePresenter {
    var view: HomeViewProtocol!
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol

    init(withView view: HomeViewProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {}
