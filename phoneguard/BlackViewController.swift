//
//  BlackViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/29.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import AVFoundation

class BlackViewController: BaseUIViewController {
    
    var isLockScreenMode : Bool = false
    var previousView : OtherScenarioViewName = OtherScenarioViewName.Stillness
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.hidesBackButton = true
        
        
        checkHeadSet()
    }
    
     
    
    @objc func hasHeadSet (_ timer: Timer) -> Bool {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        let currentRoute : AVAudioSessionRouteDescription = audioSession.currentRoute
        for output in  currentRoute.outputs {
            if(output.portType == AVAudioSessionPortHeadphones) {
                return true
            }
        }
        if(self.isLockScreenMode == false){
            self.openLockScreen()
            self.isLockScreenMode = true
        }
        return false;
    }
    
    func checkHeadSet(){
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.hasHeadSet(_:)),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
        
    }
    
    func stopCheckHeadSet(){
        self.timer.invalidate()
        self.timer = nil
        self.isLockScreenMode = false
    }
    
}

