//
//  BlackViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/29.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import MediaPlayer
import SystemConfiguration

class BlackViewController: BaseUIViewController {
    let activityManager = CMMotionActivityManager()
    var isLockScreenMode : Bool = false
    var previousView : OtherScenarioViewName = OtherScenarioViewName.Stillness
    var timer: Timer!
    var volumeValue : Float = 0.9
    
    @IBOutlet weak var volumSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationItem.hidesBackButton = true
        
        if(self.previousView == OtherScenarioViewName.Headset){
            checkHeadSet()
        } else if(self.previousView == OtherScenarioViewName.Charging){
            UIDevice.current.isBatteryMonitoringEnabled = true
            //batteryStateDidChange()
            checkCharging()
        } else if(self.previousView == OtherScenarioViewName.Network){
            checkNetwork()
        } else {
            startUpdatingActivity()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.activityManager.stopActivityUpdates()
        UIDevice.current.isBatteryMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceBatteryStateDidChange,
                                                  object: nil)
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
            stopTimer()
            self.openLockScreen()
            self.setAlarm(isSecurityMode: true)
            self.isLockScreenMode = true
        }
        return false;
    }
    
    @objc func hasNetwork(_ timer: Timer ) -> Bool {
        //Optional binding since `SCNetworkReachabilityCreateWithName` return an optional object
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.126.com") else { return true }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            return false
        }
        if(self.isLockScreenMode == false){
            stopTimer()
            self.openLockScreen()
            self.setAlarm(isSecurityMode: true)
            self.isLockScreenMode = true 
        }
        return true
    }
    
    func checkHeadSet(){
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.hasHeadSet(_:)),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
        
    }
    
    func stopTimer(){
        self.timer.invalidate()
        self.timer = nil
        self.isLockScreenMode = false
    }
    
    func checkNetwork(){
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.hasNetwork(_:)),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
        
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
            self.setAlarm(isSecurityMode: true)
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
                            self?.activityManager.stopActivityUpdates()
                            self?.openLockScreen()
                            self?.setAlarm(isSecurityMode: true)
                            self?.isLockScreenMode = true
                        }
                    }
                })
            })
        }
    }
    
    
    
    
    func setVolume(volumne : Float ){
        //Set max volume
        let wrapperView = UIView(frame: CGRect(x: -130, y: -20, width: 10, height: 10))
        //let wrapperView = UIView(frame: CGRect(x: 0, y: 0 , width: 100, height: 10))
        //self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(wrapperView)
        
        let volumeView = MPVolumeView(frame: wrapperView.bounds)
        wrapperView.addSubview(volumeView)
        //volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = true
        volumeView.isHidden = false
        
        for view in volumeView.subviews {
            //if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
            if (view.classForCoder.description() == "MPVolumeSlider") {
                let slider = view as! UISlider
                volumSlider = slider
                //print(" starting set volumn")
                slider.setValue(volumne, animated: false)
            }
        }
    }
    
    @objc func changeVolumSlider(notifi:NSNotification) {
        if let volum:Float = notifi.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as! Float?{
            //volumSlider.value = volum
            //Do nothing.
            volumSlider.value = volumeValue
        }
    }
    
    func addSystemVolumeObserver(){
        //添加监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeVolumSlider), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func setAlarm(isSecurityMode : Bool){
        //removeProximityObserve()
        let timeout = UserDefaults.standard.double(forKey: "timeout")
        if(hasHeadSet()){
            volumeValue = 0.3
        } else {
            volumeValue = 0.9
        }
        //let tv = Double(timeout)
        // Simple usage
        _ = setTimeout(delay: timeout , block: { () -> Void in
            // do this stuff after timeout seconds
            if(isSecurityMode){
                self.playSound(true);
                self.setVolume(volumne: self.volumeValue)
                self.addSystemVolumeObserver()
            }
        })
    }
    
}

