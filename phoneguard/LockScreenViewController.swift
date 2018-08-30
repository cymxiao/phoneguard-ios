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
    var otherViewCtrl:BlackViewController?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //self.navigationItem.res
        pwdInput.isSecureTextEntry = true
        pwdInput.becomeFirstResponder()
        pwdInput.delegate = self
        if(enableTouchID()){
            readTouchID()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Number pad don't have return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text == UserDefaults.standard.value(forKey: "pwd") as? String){
            popupViewController(textData: textField.text!)
        } else {
            textField.text = "";
        }
        return true
    }
    
    func popupViewController (textData: String) {
        if((rootViewCtrl) != nil){
            rootViewCtrl?.pwdReceived(data:  textData)
            //收起键盘
            //textField.resignFirstResponder()
            navigationController?.popViewController(animated:true)
        } else if((otherViewCtrl) != nil){
            otherViewCtrl?.pwdReceived(data:  textData)
            navigationController?.popToRootViewController(animated:true)
        }
    }
    
    func  enableTouchID() -> Bool {
       let enableTouchID = UserDefaults.standard.value(forKey: "enableTouchID") as? Bool
        return enableTouchID!
    }
    
    
    func readTouchID()  {
        //1.初始化TouchID句柄
        let authentication = LAContext()
        var error: NSError?
        
        
        //2.检查Touch ID是否可用
        let isAvailable = authentication.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                           error: &error)
        
        //3.处理结果
        if isAvailable
        {
            //NSLog("Touch ID is available")
            //这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
            //--> 指纹生物识别方式
            authentication.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "这里需要您的指纹来进行验证解除警戒", reply: {
                //当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
                (success, error) -> Void in
                if success
                {
                    DispatchQueue.main.async { 
                        //Do stuff here
                        let pwd = UserDefaults.standard.value(forKey: "pwd") as? String
                        //self.rootViewCtrl?.pwdReceived(data: pwd!)
                        //self.navigationController?.popViewController(animated:true)
                        self.popupViewController(textData: pwd!)
                    }
                }
            })
        }
        else
        {
            //上面提到的硬件配置
            print("Touch ID不能使用！错误原因：\n\(String(describing: error))")
        }
    }
    
}
