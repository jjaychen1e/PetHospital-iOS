//
//  WebViewController.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/29.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    private var webView = WKWebView()
    private var progressView = UIProgressView(progressViewStyle: .default)
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)

        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(progressView)
        progressView.trackTintColor = .white
        self.progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if progressView.progress == 1.0 {
                UIView.animate(withDuration: 0.3) {
                    self.progressView.alpha = 0.0
                }
            }
        }  else if keyPath == "title" {
            if let title = webView.title {
                self.title = title
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            // 第三方登录
            if url.host == "..../#/register" {
                if let queryParameter = url.queryParameters, let socialUserID = queryParameter["socialUsrId"] {
                    self.dismiss(animated: true) {
                        print(socialUserID)
                    }
                }
                decisionHandler(.cancel)
                return
            } else if url.host == "..../#/login" {
                if let queryParameter = url.queryParameters, let stuID = queryParameter["stuId"], let token = queryParameter["token"] {
                    self.dismiss(animated: true) {
                        print(stuID)
                        print(token)
                        if let nvc = (UIApplication.shared.delegate as? AppDelegate)?.rootNavigationController {
                            nvc.setNavigationBarHidden(true, animated: false)
                            nvc.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: true)
                        }
                    }
                }
            }
        }

        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(ac, animated: true)
        completionHandler()
    }
}
