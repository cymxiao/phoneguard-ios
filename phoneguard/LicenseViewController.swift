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
    
    @IBOutlet weak var licenseView: UITextView!
    
    @IBAction func agreeButtonClick(_ sender: Any) {
        UserDefaults.standard.set("true", forKey: "agreeLicense")
         UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated:true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        let leftBarBtn = UIBarButtonItem(title: "同意条款并返回", style: .plain, target: self,
//                                         action: #selector(backToPrevious))
//        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:135, height:30)
        button.setImage(UIImage(named:"back"), for: .normal)
        button.setTitle("同意条款并返回", for: .normal)
        button.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
        
        let leftBarBtn = UIBarButtonItem(customView: button)
        
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -10;
        
        self.navigationItem.leftBarButtonItems = [spacer,leftBarBtn]
        
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        UserDefaults.standard.set("true", forKey: "agreeLicense")
        UserDefaults.standard.synchronize()
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.licenseView.scrollRangeToVisible(NSMakeRange(0, 0))
//        let item = UIBarButtonItem(title: "同意条款并返回", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = item
//        self.navigationItem.title = ""
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = item
//    }
    
}

