//
//  HomeView.swift
//  WebViewTest
//
//  Created sopra on 16/11/20.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    var presenter: HomePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeView: HomeViewProtocol {}
