//
//  LockScreenViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockScreenViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet weak var pwdInput: UITextField!
    var rootViewCtrl:ViewController?
    //var navCtrl : UINavigationController
 
 
//    @IBAction func pwdInputFinished(_ sender: UITextField) {
//                print (sender.text ?? "")
//                if(sender.text == UserDefaults.standard.value(forKey: "pwd") as? String){
//                    rootViewCtrl?.pwdReceived(data:  sender.text!)
//                    navigationController?.popViewController(animated:true)
//                }
//    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //self.navigationItem.res
        pwdInput.isSecureTextEntry = true
        pwdInput.becomeFirstResponder()
        pwdInput.delegate = self
        
        //navCtrl = navigationController!
        //self.navigationController?.setNavigationBarHidden(false,animated: true) 
        //readTouchID()
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
    
    
    func readTouchID(){
        //1.初始化TouchID句柄
        let authentication = LAContext() 
        var error: NSError?
        var passedAuth : Bool
        
        //2.检查Touch ID是否可用
        let isAvailable = authentication.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                           error: &error)
        
        //3.处理结果
        if isAvailable
        {
            //NSLog("Touch ID is available")
            //这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
            //--> 指纹生物识别方式
            authentication.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "这里需要您的指纹来进行识别验证", reply: {
                //当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
                (success, error) -> Void in
                if success
                {
                    //NSLog("您通过了Touch ID指纹验证！")
                    let pwd = UserDefaults.standard.value(forKey: "pwd") as? String
                    self.rootViewCtrl?.pwdReceived(data: pwd!)
                    //passedAuth = true
                    
                    //Amin : todo: it doesn't work
                    self.navigationController?.popViewController(animated:true)
//
//                    let rootView = self.storyboard?.instantiateViewController(withIdentifier:  "rootView")  as! ViewController
//                    self.navigationController?.show(rootView, sender: nil )
                }
                else
                {
                    //上面提到的指纹识别错误
                    //NSLog("您未能通过Touch ID指纹验证！错误原因：\n\(String(describing: error))")
                }
            })
//            if(passedAuth){
//                self.navigationController?.popViewController(animated:true)
//            }
        }
        else
        {
            //上面提到的硬件配置
            NSLog("Touch ID不能使用！错误原因：\n\(String(describing: error))")
        }
    }
    
}
