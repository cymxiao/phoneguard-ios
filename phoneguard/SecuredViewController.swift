//
//  SecuredViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/27.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class SecuredViewController: BaseUIViewController {
    
    var previousView : OtherScenarioViewName = OtherScenarioViewName.Stillness
    @IBOutlet weak var securedText: UITextView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(previousView == OtherScenarioViewName.Headset){
            securedText.text = "警戒模式已开启。                                                                                                  请不要锁屏，将耳机保持连接到手机上，系统会自动关闭屏幕。"
        } else if(previousView == OtherScenarioViewName.Charging){
             securedText.text = "警戒模式已开启。                                                                                                  请不要锁屏，将手机保持充电转态，系统会自动关闭屏幕。"
        } else if(previousView == OtherScenarioViewName.Network){
            securedText.text = "警戒模式已开启。                                                                                                  请不要锁屏，将手机保持无网络转态，系统会自动关闭屏幕。"
        }
        _ = setTimeout(delay: 1 , block: { () -> Void in 
            self.openBlackScreen(prevView: self.previousView)
        })
    } 
}
