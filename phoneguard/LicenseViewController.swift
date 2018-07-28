//
//  LicenseViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/26.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
//import WebKit

class LicenseViewController: UIViewController {//}, WKUIDelegate {
    
    //var webView: WKWebView!
   
 
    
    //@IBOutlet weak var scrollview: UIScrollView!
 
    //@IBOutlet weak var webView: WKWebView!
    
    @IBAction func agreeButtonClick(_ sender: Any) {
        UserDefaults.standard.set("true", forKey: "agreeLicense")
         UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated:true)
    }
    //    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        //webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50), configuration: webConfiguration)
//        //let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.webViewContainer.frame.size.width, height: self.webViewContainer.frame.size.height-50))
//        //webView = WKWebView (frame: customFrame , configuration: webConfiguration)
//        //let myURL = URL(string: "http://203.195.174.95/phone-guard-privacy.htm")
//        //webView.load(<#T##data: Data##Data#>, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: myURL)
//
//        webView.uiDelegate = self
//
//        view = webView
//        //scrollview.addSubview(webView)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myURL = URL(string: "http://203.195.174.95/phone-guard-privacy.htm")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
    }
    
}

