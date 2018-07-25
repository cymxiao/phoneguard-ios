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
 
 
//    @IBAction func pwdInputFinished(_ sender: UITextField) {
//                print (sender.text ?? "")
//                if(sender.text == UserDefaults.standard.value(forKey: "pwd") as? String){
//                    rootViewCtrl?.pwdReceived(data:  sender.text!)
//                    navigationController?.popViewController(animated:true)
//                }
//    }
    @IBAction func pwdUpdated(_ sender: UITextField) {
        if(sender.text == UserDefaults.standard.value(forKey: "pwd") as? String){
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
        pwdInput.delegate = self
        //self.navigationController?.setNavigationBarHidden(false,animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Number pad don't have return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text == UserDefaults.standard.value(forKey: "pwd") as? String){
            rootViewCtrl?.pwdReceived(data:  textField.text!)
            //收起键盘
            //textField.resignFirstResponder()
            navigationController?.popViewController(animated:true)
        } else {
            textField.text = "";
        }
        return true
    }
    
}
