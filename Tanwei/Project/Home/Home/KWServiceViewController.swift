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

class KWServiceViewController: UIViewController {
    
    lazy var tipsView : UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT*0.5-NavHeight, width: SCREEN_WIDTH, height: 100))
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    
    //进度条
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView.init(frame: CGRect(x: 0, y: StatusBarHeight , width: UIScreen.main.bounds.width, height: 2))
        progressView.progressTintColor = APPSubjectColor
        progressView.trackTintColor = .white
        
        return progressView
    }()
    
    lazy var webView: WKCookieWebView = {
        let webView: WKCookieWebView = WKCookieWebView(frame: CGRect(x: 0, y: StatusBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-StatusBarHeight-TabHeight))
//        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.wkNavigationDelegate = self
        return webView
    }()
    
    public var url : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = SetBackBarButtonItem(target: self, action: #selector(back), imageName: "back")
        WKCookieWebViewloadRequest()
    }
    
    @objc private func back() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func WKCookieWebViewloadRequest() {
        if !url.contains("http") && !url.contains("https") {
            url = "http://"+url
        }
        
        let request = URLRequest(url: URL(string: url)!)
        self.setupWebView()
        self.webView.load(request)
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        view.addSubview(progressView)
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.1
        }
        
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
extension KWServiceViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail.error : \(error)")
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.05
            self.progressView.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation.error : \(error)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        /// 获取网页的progress
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = Float(webView.estimatedProgress)*2
        KWPrint("didStartProvisionalNavigation--\(Float(webView.estimatedProgress))")
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIView.animate(withDuration: 1.0) {
        self.progressView.progress = Float(webView.estimatedProgress)*2
        KWPrint("didCommit--\(Float(webView.estimatedProgress))")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 1.0, animations: {
            self.progressView.progress = 0.9
        }) { (finish) in
            self.progressView.isHidden = true
        }
    }
}
