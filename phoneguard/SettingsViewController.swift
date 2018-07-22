//
//  settingsViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/22.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
   
    @IBOutlet weak var saveSettings: UIButton!
    @IBAction func saveSettings(_ sender: Any) {
         navigationController?.popViewController(animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //self.navigationItem.hidesBackButton = true
        //let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,  action: #selector(backToPrevious)) 
        //self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

