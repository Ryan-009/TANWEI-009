//
//  KWWebViewController.swift
//  KIWI
//
//  Created by li zhou on 2019/12/9.
//  Copyright © 2019 li zhou. All rights reserved.
//

import UIKit
import WebKit
import WKCookieWebView

class KWWebViewController: UIViewController {

    enum loadLocalHtmlType {
        case ssPrivate
        case ssService
    }
    
    private lazy var webView: WKCookieWebView = {
        let webView: WKCookieWebView = WKCookieWebView(frame: self.view.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.wkNavigationDelegate = self
        return webView
    }()

    public var resId : String = ""{
        didSet{
            loadResIdRequest()
        }
    }
    
    public var localType : loadLocalHtmlType = .ssPrivate{
        didSet{
            loadPrivate(localType)
        }
    }
    
    public var link : String = "" {
        didSet{
            if UnNil(link) {
                loadNormalURL()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(back), imageName: "back.png")
    }
    
    private func loadNormalURL() {
        if let urlF = URL.init(string: link) {
            let request = URLRequest(url: urlF)
            self.setupWebView()
            self.webView.load(request)
        }
    }
    
    private func loadResIdRequest() {
        self.title = "详情"
        let path = Bundle.main.path(forResource: "imgDetail", ofType: "html")
        let localUrl = URL(fileURLWithPath: path!)
        let urlPin = localUrl.absoluteString+"?resId="+resId
        guard let urlF = URL(string: urlPin) else { return  }
        let request = URLRequest(url: urlF)
        self.setupWebView()
        self.webView.load(request)
    }
    
    public func loadPrivate(_ type:loadLocalHtmlType) {
        let path = Bundle.main.path(forResource: type == .ssPrivate ? "private":"service", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        let request = URLRequest(url: url)
        self.setupWebView()
        self.webView.load(request)
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private
    private func setupWebView() {
        view.addSubview(webView)
        
        let views: [String: Any] = ["webView": webView]
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[webView]-0-|",
            options: [],
            metrics: nil,
            views: views))
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[webView]-0-|",
            options: [],
            metrics: nil,
            views: views))
        
        webView.onDecidePolicyForNavigationAction = { (webView, navigationAction, decisionHandler) in
            decisionHandler(.allow)
        }
        
        webView.onDecidePolicyForNavigationResponse = { (webView, navigationResponse, decisionHandler) in
            decisionHandler(.allow)
        }
        
        webView.onUpdateCookieStorage = { [weak self] (webView) in
            self?.printCookie()
        }
    }
    
    private func printCookie() {
        print("=====================Cookies=====================")
        HTTPCookieStorage.shared.cookies?.forEach {
            print($0)
        }
        print("=================================================")
    }

}
extension KWWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail.error : \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation.error : \(error)")
    }
    
}
