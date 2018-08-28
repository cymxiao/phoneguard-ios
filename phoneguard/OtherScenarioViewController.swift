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

class OtherScenarioViewController: UIViewController {
    let activityManager = CMMotionActivityManager()
    //var stationary : Bool = false
    
  
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
                        if(data.stationary){
                            self?.openSecuredScreen()
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
            self.openSecuredScreen()
        }
    }
    
    func hasHeadSet () -> Bool {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        let currentRoute : AVAudioSessionRouteDescription = audioSession.currentRoute
        for output in  currentRoute.outputs {
            if(output.portType == AVAudioSessionPortHeadphones) {
                return true
            }
        }
        return false;
        
    }
    
    
    func openLockScreen(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LockScreen")  as! LockScreenViewController
        //vc.rootViewCtrl = self
        self.navigationController?.show(vc, sender: nil )
    }
    
    func openSecuredScreen(){

        let sc = self.storyboard?.instantiateViewController(withIdentifier:  "Secured")  as! SecuredViewController
        self.navigationController?.show(sc, sender: nil )
    }
    
}

