//
//  HomeView.swift
//  WebViewTest
//
//  Created sopra on 16/11/20.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

final class HomeView: UIViewController {
    var presenter: HomePresenterProtocol!

    private var wkWebView: WKWebView!

    private let navBarTitleBase: String = "Introduce datos"

    // MARK: - Variables de clase
    private var local: Bool = false
    private var name: String = ""
    private var years: Int = 0

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupWKWebview()
        self.loadPage()
        self.setupNavBar()
        self.addNavButton()
    }

    // MARK: - Navigation bar methods
    private func setupNavBar() {
        self.navigationItem.title = self.navBarTitleBase
    }

    private func updateNavBar() {
        self.navigationItem.title = self.name + ", " + String(describing: self.years)
    }

    fileprivate func addNavButton() {
        let cleanButton = UIBarButtonItem(title: "Clean", style: .plain, target: self, action: #selector(self.cleanTapped))
        let backGroundButton = UIBarButtonItem(title: "BG Color", style: .plain, target: self, action: #selector(self.backGroundTapped))
        let renameButton = UIBarButtonItem(title: "Rename", style: .plain, target: self, action: #selector(self.renameTapped))
        self.navigationItem.leftBarButtonItem = backGroundButton
        self.navigationItem.rightBarButtonItems = [renameButton, cleanButton]
    }

    @objc func cleanTapped() {
        self.wkWebView.evaluateJavaScript("reset()", completionHandler: nil)
    }

    @objc func backGroundTapped() {
        self.wkWebView.evaluateJavaScript("changeBackgroundColor('\(WebViewTestUtils.getRandomColor())')", completionHandler: nil)
        self.setupNavBar()
    }

    @objc func renameTapped() {
        self.wkWebView.evaluateJavaScript("rename()", completionHandler: nil)
        self.setupNavBar()
    }

    // MARK: - WebView methods
    private func setupWKWebview() {
        self.wkWebView = WKWebView(frame: self.view.bounds, configuration: self.getWKWebViewConfiguration())
        self.wkWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        self.wkWebView.uiDelegate = self
        self.view.addSubview(self.wkWebView)
    }

    private func loadPage() {
        if self.local {
            if let htmlFile = Bundle.main.path(forResource: "index", ofType: "html") {
                if let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) {
                    self.wkWebView.loadHTMLString(html, baseURL: nil)
                }
            }
        } else {
            if let url = URL(string: self.getURL()) {
                self.wkWebView.load(URLRequest(url: url))
            }
        }
    }

    private func getWKWebViewConfiguration() -> WKWebViewConfiguration {
        let userController = WKUserContentController()
        userController.add(self, name: "observer")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userController

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences

        return configuration
    }

    fileprivate func getURL() -> String {
        guard let filePath = Bundle.main.path(forResource: "MathisPaturleInfo", ofType: "plist") else {
            fatalError("Couldn't find file 'MathisPaturleInfo.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let urlBase = plist?.object(forKey: "Heisenberg_Sopra_Web") as? String else {
            fatalError("Couldn't find key 'Heisenberg_Sopra_Web' in 'MathisPaturleInfo.plist'.")
        }
        guard let params = plist?.object(forKey: "Token_Session") as? String else {
            fatalError("Couldn't find key 'Token_Session' in 'MathisPaturleInfo.plist'.")
        }

        return urlBase + params
    }
}

extension HomeView: HomeViewProtocol {}

extension HomeView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: AnyObject] {
            self.name = data["name"] as? String ?? ""
            self.years = Int(data["years"] as? String ?? "") ?? -1

            self.updateNavBar()
        }
    }
}

extension HomeView: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "OJO", message: "NO hay token de sesión!!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
