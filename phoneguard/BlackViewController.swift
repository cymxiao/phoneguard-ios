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
        
        if(self.previousView === OtherScenarioViewName.Headset){
            checkHeadSet()
        } else if(self.previousView === OtherScenarioViewName.Charging){
            checkCharging()
        } else {
            startUpdatingActivity()
        }
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

    func checkCharging(){
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.batteryStateDidChange),
                                                   name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                   object: nil)
        
    }

      @objc func batteryStateDidChange() {
        let batteryStateString: String
        let status = UIDevice.current.batteryState
        switch status {
        case .full:
            batteryStateString = "Full"
        case .unplugged:
            batteryStateString = "Unplugged"
        case .charging:
            batteryStateString = "Charging"
        case .unknown:
            batteryStateString = "Unknown"
        }
        
        if(batteryStateString == "Unplugged"){
            self.openLockScreen()
        }
    }


    func startUpdatingActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: {
                [weak self] (data: CMMotionActivity?) in
                DispatchQueue.main.async(execute: {
                    if let data = data {
                        print("stationary: \(data.stationary)")
                        //self?.stationary  = data.stationary
                        if(!data.stationary && (self?.isLockScreenMode)! == false){
                            self.openLockScreen()
                            self?.isLockScreenMode = true
                        }
                    }
                })
            })
        }
    }
    
}

