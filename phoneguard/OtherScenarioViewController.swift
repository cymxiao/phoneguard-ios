//
//  OtherScenarioViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/28.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class OtherScenarioViewController:  BaseUIViewController {
    let activityManager = CMMotionActivityManager()
    var isSecurityMode : Bool = false
    var timer: Timer!
    
    @IBOutlet weak var stillnessText: UILabel!
    @IBOutlet weak var chargingText: UILabel!
    @IBOutlet weak var headsetText: UILabel!
    
    @IBOutlet weak var stillnessSwitch: UISwitch!
    @IBOutlet weak var chargingSwitch: UISwitch!
    @IBOutlet weak var headSetSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //each time load the screen, reset the switchs.
        resetSwitch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.activityManager.stopActivityUpdates()
        UIDevice.current.isBatteryMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                  object: nil)
    }
    
  
    @IBAction func stillnessAction(_ sender: UISwitch) {
        if( sender.isOn){
            stillnessText.text = "请保持手机静止"
            chargingText.text = ""
            headsetText.text = ""
            chargingSwitch.setOn(false, animated: true)
            headSetSwitch.setOn(false, animated: true)
            startUpdatingActivity()
        } else {
             stillnessText.text = ""
        }
    }
    @IBAction func chargingAction(_ sender: UISwitch) {
        if( sender.isOn){
            chargingText.text = "请将手机插上电源充电"
            stillnessText.text = ""
            headsetText.text = ""
            stillnessSwitch.setOn(false, animated: true)
            headSetSwitch.setOn(false, animated: true)
            UIDevice.current.isBatteryMonitoringEnabled = true
            // Observe battery state
            batteryStateDidChange()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.batteryStateDidChange),
                                                   name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                   object: nil) 
        }
        else {
            chargingText.text = ""
            //remove  battery state observer
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                      object: nil)
        }
    }
    
    @IBAction func headsetAction(_ sender: UISwitch) {
        
        if(sender.isOn){
            headsetText.text = "请连接耳机"
            stillnessText.text = ""
            chargingText.text = "" 
            stillnessSwitch.setOn(false, animated: true)
            chargingSwitch.setOn(false, animated: true)
            checkHeadSet()
        } else {
            headsetText.text = ""
            stopCheckHeadSet()
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
                        if(data.stationary && (self?.isSecurityMode)! == false){
                            self?.openSecuredScreen(prevView: OtherScenarioViewName.Stillness)
                            self?.isSecurityMode = true
                        }
                    }
                })
            })
        }
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
        
        if(batteryStateString == "Charging" || batteryStateString == "Full"){
            self.openSecuredScreen(prevView: OtherScenarioViewName.Charging)
        }
    }
    
    @objc func hasHeadSet (_ timer: Timer) -> Bool {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        let currentRoute : AVAudioSessionRouteDescription = audioSession.currentRoute
        for output in  currentRoute.outputs {
            if(output.portType == AVAudioSessionPortHeadphones) {
                if(self.isSecurityMode == false){
                    self.openSecuredScreen(prevView: OtherScenarioViewName.Headset)
                    self.isSecurityMode = true
                    return true
                }
                return true
            }
        }
        //Amin: Test Code
//        if(self.isSecurityMode == false){
//            self.openSecuredScreen(prevView: OtherScenarioViewName.Headset)
//            self.isSecurityMode = true
//        }
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
        self.isSecurityMode = false
    }
    
    func resetSwitch() {
        //super.resetSwitch()
        isSecurityMode = false
        stillnessText.text = ""
        chargingText.text = ""
        headsetText.text = ""
        stillnessSwitch.setOn(false, animated: true)
        chargingSwitch.setOn(false, animated: true)
        headSetSwitch.setOn(false, animated: true)
    }
    
}

