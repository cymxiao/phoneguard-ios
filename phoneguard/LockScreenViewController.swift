//
//  LockScreenViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var pwdInput: UITextField!
    var rootViewCtrl:ViewController?
 
    @IBAction func pwdInputFinished(_ sender: UITextField) {
        print (sender.text ?? "")
        if(sender.text == "1234"){
            rootViewCtrl?.pwdReceived(data:  sender.text!)
            navigationController?.popViewController(animated:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //self.navigationItem.res
        pwdInput.isSecureTextEntry = true
        pwdInput.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        print(textField.text ?? "")
        return true
    }
    
}
