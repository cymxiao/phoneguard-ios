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
    
    @IBOutlet weak var saveSettings: UIButton!
    
    @IBAction func saveSettings(_ sender: Any) {
        UserDefaults.standard.set(alertTimeoutText.text, forKey: "timeout")
        UserDefaults.standard.set(pwdText.text, forKey: "pwd") 
        navigationController?.popViewController(animated:true)
    }
    @IBAction func backToRoot(_ sender: Any) {
         navigationController?.popViewController(animated:true)
    }
    
    @IBAction func navToLicense(_ sender: Any) {
         let vc = self.storyboard?.instantiateViewController(withIdentifier:  "License")  as! LicenseViewController
        self.navigationController?.show(vc, sender: nil )
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTimeoutText.delegate = self
        pwdText.delegate = self
        //self.navigationItem.hidesBackButton = true
        //let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,  action: #selector(backToPrevious)) 
        //self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //self.navigationController?.setNavigationBarHidden(false,animated: true)
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
    
    
}



