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
  
    @IBAction func stillnessAction(_ sender: UISwitch) {
        if( sender.isOn){
            startUpdatingActivity()
        }
    }
    @IBAction func chargingAction(_ sender: UISwitch) {
        if( sender.isOn){
            // Observe battery state
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.batteryStateDidChange),
                                                   name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                   object: nil)
        }
        else {
            //remove  battery state observer
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                      object: nil)
        }
    }
    
    @IBAction func headsetAction(_ sender: UISwitch) {
        
        if(sender.isOn){
            checkHeadSet()
        } else {
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
        
        if(batteryStateString == "Unplugged"){
            self.openSecuredScreen(prevView: OtherScenarioViewName.Charging)
        }
    }
    
    @objc func hasHeadSet (_ timer: Timer) -> Bool {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        let currentRoute : AVAudioSessionRouteDescription = audioSession.currentRoute
        for output in  currentRoute.outputs {
            if(output.portType == AVAudioSessionPortHeadphones) {
//                if(self.isSecurityMode == false){
//                    self.openSecuredScreen(prevView: OtherScenarioViewName.Headset)
//                    self.isSecurityMode = true
//                    return true
//                }
                return true
            }
        }
        //Amin: Test Code
        if(self.isSecurityMode == false){
            self.openSecuredScreen(prevView: OtherScenarioViewName.Headset)
            self.isSecurityMode = true
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
    
    override func resetSwitch() {
        super.resetSwitch()
        stillnessSwitch.setOn(false, animated: true)
        chargingSwitch.setOn(false, animated: true)
        headSetSwitch.setOn(false, animated: true)
    }
    
}

