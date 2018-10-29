//
//  ViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/17.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: BaseUIViewController {
  
    var isSecurityMode : Bool? = false
    var volumeValue : Float = 0.9
    //var playSound : Bool = true
    @IBOutlet weak var btnAlarm: UIButton!
    @IBOutlet weak var mainUIView: UIView!
    @IBOutlet weak var volumSlider: UISlider!
    
    @IBOutlet weak var topPanel: UIView!
    
    
     
    @IBAction func navGuide(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "guide")  as! GuideViewController
        self.navigationController?.show(vc, sender: nil )
    } 
    
    @IBAction func buttonClick(_ sender: Any) {
        if(isSecurityMode == false){
            isSecurityMode = true
            playSoundwithName("lock")
            btnAlarm.setTitle("警戒已开启\n 点击关闭", for:.normal)
            btnAlarm.setBackgroundImage(UIImage(named: "alarm-set.png"), for: UIControlState.normal)
            addProximityObserve()
        } else {
            alarmClear()
        }
        
    }
    
  
    override func alarmClear(){
        isSecurityMode = false
        
        btnAlarm.setBackgroundImage(UIImage(named: "alarm-clear.png"), for: UIControlState.normal)
        btnAlarm.setTitle("    警戒已关闭\n点击或摇一摇开启", for:.normal)
        playSound(false)
        //Amin: todo: I guess the playSound(false) would mute the player, that why if put playSoundwithName("unlock") before it, the unlock.mp3 would not be played.
        playSoundwithName("unlock")
        removeProximityObserve();
        removeSystemVolumeObserver()
    }
    
    func addProximityObserve(){
        UIDevice.current.isProximityMonitoringEnabled = true
        
        // Observe proximity state
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximitySensorStateDidChange),
                                               name: NSNotification.Name.UIDeviceProximityStateDidChange,
                                               object: nil)
        
    }
    
    func removeProximityObserve(){
        // Finish observation
        UIDevice.current.isProximityMonitoringEnabled = false
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceProximityStateDidChange,
                                                  object: nil)
        
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //topPanel.backgroundColor = dayTheme.backgroundColor
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        removeProximityObserve()
        //self.view.backgroundColor = UIColor.green;
        //mainUIView.center = CGPoint(x: self.view.bounds.width / 2,  y: 0)
        btnAlarm.setBackgroundImage(UIImage(named: "alarm-clear.png"), for: UIControlState.normal)
        btnAlarm.center = CGPoint(x: self.view.bounds.width / 2,  y: 150)
        btnAlarm.titleLabel?.lineBreakMode =  .byWordWrapping
        btnAlarm.setTitle("    警戒已关闭\n点击或摇一摇开启", for:.normal)
 
        //self.navigationItem.setim
        //set sub page backbutton text.
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        //self.navigationController?.setNavigationBarHidden(true,animated: true)
        
        if(UserDefaults.standard.value(forKey: "pwd") == nil ){
             UserDefaults.standard.set("1367", forKey: "pwd")
        }
        if(UserDefaults.standard.value(forKey: "timeout") == nil ){
            UserDefaults.standard.set("3", forKey: "timeout")
        }
        
        if(UserDefaults.standard.value(forKey: "enableTouchID") == nil ){
             UserDefaults.standard.set(true, forKey: "enableTouchID")
        }
        
        if(UserDefaults.standard.value(forKey: "agreeLicense") == nil ){
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "License")  as! LicenseViewController
            self.navigationController?.show(vc, sender: nil )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
    }
    
    func setVolume(volumne : Float ){
        //Set max volume
        //let wrapperView = UIView(frame: CGRect(x: 130, y: 20, width: 100, height: 10))
        let wrapperView = UIView(frame: CGRect(x: 20, y: 50 , width: 100, height: 10))
        //self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(wrapperView)
        
        let volumeView = MPVolumeView(frame: wrapperView.bounds)
        wrapperView.addSubview(volumeView)
        //volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = false
        volumeView.isHidden = false
        
        for view in volumeView.subviews {
            //if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
              if (view.classForCoder.description() == "MPVolumeSlider") {
                let slider = view as! UISlider
                volumSlider = slider
                //print(" starting set volumn")
                //slider.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
              
                slider.setValue(volumne, animated: false)
            }
        }
    }
    
    func setVolumnInIOS12 (volumne : Float) {
        let strV = String(describing: volumne )
        let mpc = MPMusicPlayerController.applicationMusicPlayer
        mpc.setValue(strV, forKey: "volume" )
    }
    
    @objc func sliderAction(slider:UISlider) {
        print(slider.value)
    }
     
    // MARK: - Internal method
    @objc func proximitySensorStateDidChange() {
        //print("proximityState : \(UIDevice.current.proximityState)")
        
        if(UIDevice.current.proximityState){
            
        } else {
            if(isSecurityMode!){
                //why set volume to 0
                //setVolume(volumne: 0)
                openLockScreen()
                //Avoid dulicate lock screen displayed.
                removeProximityObserve()
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
                    if(self.isSecurityMode!){
                        self.playSound(true)
                        self.setVolume(volumne: self.volumeValue)
                        self.setVolumnInIOS12(volumne: self.volumeValue)
                        self.addSystemVolumeObserver()
                    } 
                })
             //playSound(true);
            }
        }
    }
    
   override func openLockScreen(){

        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LockScreen")  as! LockScreenViewController
        vc.rootViewCtrl = self
        self.navigationController?.show(vc, sender: nil )
    } 
    
    func addSystemVolumeObserver(){
        //添加监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeVolumSlider), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    @objc func changeVolumSlider(notifi:NSNotification) {
        if let _:Float = notifi.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as! Float?{
            //volumSlider.value = volum
            //Do nothing.
            volumSlider.value = volumeValue
        }
    }
    
    func removeSystemVolumeObserver(){
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.type == UIEventType.motion && event?.subtype == UIEventSubtype.motionShake {
            //let text = self.textView.text
            //self.textView.text = text! + "\nMotion ended"
            if(isSecurityMode == false){
                isSecurityMode = true
                playSoundwithName("lock")
                btnAlarm.setTitle("警戒已开启\n 点击关闭", for:.normal)
                btnAlarm.setBackgroundImage(UIImage(named: "alarm-set.png"), for: UIControlState.normal)
                addProximityObserve()
            }
        }
    }

}

