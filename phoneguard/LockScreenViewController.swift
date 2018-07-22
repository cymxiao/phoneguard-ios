//
//  LockScreenViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class LockScreenViewController: UIViewController {
    @IBOutlet weak var textInput: UITextField!
    @IBAction func pwsValueChanged(_ sender: UITextField) {
        print (sender.text ?? "")
        if(sender.text == "1234"){
             navigationController?.popViewController(animated:true)
        }
        //navigationController?.popToRootViewController(animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
