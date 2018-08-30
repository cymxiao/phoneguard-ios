//
//  settingsViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UITextFieldDelegate {
   
    @IBOutlet weak var alertTimeoutText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    //@IBOutlet weak var saveSettings: UIButton!
    @IBOutlet weak var swhTouchID: UISwitch!
    
    @IBAction func saveSettings(_ sender: Any) {
        UserDefaults.standard.set(alertTimeoutText.text, forKey: "timeout")
        UserDefaults.standard.set(pwdText.text, forKey: "pwd")
        UserDefaults.standard.synchronize()
        
        // create the alert
        let alert = UIAlertController(title: "提示", message: "保持成功.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        //self.present(alert, animated: true, completion: nil)
        //self.resignFirstResponder()
        navigationController?.popViewController(animated:true)
        openSettingsView()
    }
   
    @IBAction func touchIDSwitchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "enableTouchID")
    }
    
 
    
    @IBAction func closeKeyBoard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTimeoutText.delegate = self
        pwdText.delegate = self
        //self.navigationItem.hidesBackButton = true
        //let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,  action: #selector(backToPrevious)) 
        //self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //self.navigationController?.setNavigationBarHidden(false,animated: true)
        
        let initTimeOut = UserDefaults.standard.value(forKey: "timeout") as? String
        let initPwd  = UserDefaults.standard.value(forKey: "pwd") as? String
        let enableTouchID  = UserDefaults.standard.bool(forKey: "enableTouchID")
     
        alertTimeoutText.text = initTimeOut
        pwdText.text = initPwd
        swhTouchID.setOn(enableTouchID, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        var maxLength = 4
        switch textField {
        case alertTimeoutText:
             maxLength = 1
        default:
             maxLength = 4
        }
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func openSettingsView(){
        
        let sc = self.storyboard?.instantiateViewController(withIdentifier:  "Settings")  as! SettingsViewController
        self.navigationController?.show(sc, sender: nil )
    }
    
}



