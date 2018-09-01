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
import SystemConfiguration

class OtherScenarioViewController:  BaseUIViewController {
    let activityManager = CMMotionActivityManager()
    var isSecurityMode : Bool = false
    var timer: Timer!
    
    
    @IBOutlet weak var stillnessText: UILabel!
    @IBOutlet weak var chargingText: UILabel!
    @IBOutlet weak var headsetText: UILabel!
    @IBOutlet weak var airplaneText: UILabel!
    
    @IBOutlet weak var stillnessSwitch: UISwitch!
    @IBOutlet weak var chargingSwitch: UISwitch!
    @IBOutlet weak var headSetSwitch: UISwitch!
    @IBOutlet weak var airplaneSwitch: UISwitch!
    
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
            stillnessText.text = "请保持手机静止，移动则发出警报"
            chargingText.text = ""
            headsetText.text = ""
            airplaneText.text = ""
            chargingSwitch.setOn(false, animated: true)
            headSetSwitch.setOn(false, animated: true)
            airplaneSwitch.setOn(false, animated: true)
            startUpdatingActivity()
        } else {
             stillnessText.text = ""
        }
    }
    @IBAction func chargingAction(_ sender: UISwitch) {
        if( sender.isOn){
            chargingText.text = "请将手机插上电源充电，断开电源则发出警报"
            stillnessText.text = ""
            headsetText.text = ""
            airplaneText.text = ""
            stillnessSwitch.setOn(false, animated: true)
            headSetSwitch.setOn(false, animated: true)
            airplaneSwitch.setOn(false, animated: true)
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
            headsetText.text = "请连接耳机，断开耳机则发出警报"
            stillnessText.text = ""
            chargingText.text = ""
            airplaneText.text = ""
            stillnessSwitch.setOn(false, animated: true)
            chargingSwitch.setOn(false, animated: true)
            airplaneSwitch.setOn(false, animated: true)
            checkHeadSet()
        } else {
            headsetText.text = ""
            stopCheckHeadSet()
        }
    }
    
    @IBAction func airplaneAction(_ sender: UISwitch) {
        if(sender.isOn){
            airplaneText.text = "请关闭网络或打开飞行模式且关闭Wifi，开启网络则发出警报"
            stillnessText.text = ""
            chargingText.text = ""
            headsetText.text = ""
            stillnessSwitch.setOn(false, animated: true)
            chargingSwitch.setOn(false, animated: true)
            headSetSwitch.setOn(false, animated: true)
            checkNetwork()
        }
        else {
            airplaneText.text = ""
            stopCheckNetwork()
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
        airplaneText.text = ""
        stillnessSwitch.setOn(false, animated: true)
        chargingSwitch.setOn(false, animated: true)
        headSetSwitch.setOn(false, animated: true)
        airplaneSwitch.setOn(false, animated: true)
    }
     
    func checkNetwork(){
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.hasNetwork(_:)),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
        
    }
    
    func stopCheckNetwork(){
        self.timer.invalidate()
        self.timer = nil
        self.isSecurityMode = false
    }
    
    @objc func hasNetwork(_ timer: Timer ) -> Bool {
        //Optional binding since `SCNetworkReachabilityCreateWithName` return an optional object
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.126.com") else { return true }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            if(self.isSecurityMode == false){
                self.openSecuredScreen(prevView: OtherScenarioViewName.Network)
                self.isSecurityMode = true
                return false
            }
        }
        return true
    }
    
}

