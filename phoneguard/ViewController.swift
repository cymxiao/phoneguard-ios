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


class ViewController: UIViewController {
    var player: AVAudioPlayer?
    var isSecurityMode : Bool? = false
    @IBOutlet weak var btnAlarm: UIButton!
    @IBOutlet weak var mainUIView: UIView!
    
//    @IBAction func switchButton(_ sender: UISwitch) {
//
//        if(sender.isOn){
//           isSecurityMode = true
//            addProximityObserve()
//            print( "isSecurityMode : \(String(describing:  isSecurityMode ))");
//        } else {
//            playSound(false);
//            removeProximityObserve();
//        }
//
//    }
    
//    func addUIImageView(){
//        let imageView = UIImageView(image:UIImage(named:"alarm-set.png"))
//        imageView.frame = CGRect(x:0, y:0, width:375, height:375)
//        //imageView.layour
//        self.view.addSubview(imageView)
//    }
    
    func playSound(_ bPlay : Bool) {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line: */
            //player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            guard let player = player else { return }
            
            //player.volume = 1
            player.numberOfLoops = 10
            if(bPlay){
            player.play()
            } else {
                player.stop()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    func playSoundwithName(_ mp3Name : String) {
        guard let url = Bundle.main.url(forResource: mp3Name, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line: */
            //player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            guard let player = player else { return }
           
            player.play()
           
            
        } catch let error {
            print(error.localizedDescription)
        }
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
    
  
    func alarmClear(){
        isSecurityMode = false
        
        btnAlarm.setBackgroundImage(UIImage(named: "alarm-clear.png"), for: UIControlState.normal)
        btnAlarm.setTitle("警戒已关闭\n 点击开启", for:.normal)
        playSound(false)
        //Amin: todo: I guess the playSound(false) would mute the player, that why if put playSoundwithName("unlock") before it, the unlock.mp3 would not be played.
        playSoundwithName("unlock")
        removeProximityObserve();
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
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        removeProximityObserve()
        //self.view.backgroundColor = UIColor.green;
        //mainUIView.center = CGPoint(x: self.view.bounds.width / 2,  y: 0)
        btnAlarm.setBackgroundImage(UIImage(named: "alarm-clear.png"), for: UIControlState.normal)
        btnAlarm.center = CGPoint(x: self.view.bounds.width / 2,  y: 150)
        btnAlarm.titleLabel?.lineBreakMode =  .byWordWrapping
        btnAlarm.setTitle("警戒已关闭\n 点击开启", for:.normal)
 
        //self.navigationItem.setim
        //set sub page backbutton text.
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
       // self.navigationController?.navigationBar.tintColor = [UIColor, colorWithRed,:0.000 green:0.000 blue:0.000 alpha:1.000];
        //self.navigationController?.navigationBar.alpha = 1;
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(true,animated: true)
        
        if(UserDefaults.standard.value(forKey: "pwd") == nil ){
             UserDefaults.standard.set("1367", forKey: "pwd")
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
        let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        //self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(wrapperView)
        
        let volumeView = MPVolumeView(frame: wrapperView.bounds)
        wrapperView.addSubview(volumeView)
        volumeView.showsVolumeSlider = true
        volumeView.isHidden = true
        
        for view in volumeView.subviews {
            //if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
              if (view.classForCoder.description() == "MPVolumeSlider") {
                let slider = view as! UISlider
                //print(" starting set volumn")
                slider.setValue(volumne, animated: false)
            }
        }
    }
    
    // Basic.swift
    func setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
        
    }
    
    
    // MARK: - Internal method
    @objc func proximitySensorStateDidChange() {
        print("proximityState : \(UIDevice.current.proximityState)")
        
        if(UIDevice.current.proximityState){
            
        } else {
            if(isSecurityMode!){
                setVolume(volumne: 0.9)
                openLockScreen()
                // Simple usage
                _ = setTimeout(delay: 3, block: { () -> Void in
                    // do this stuff after 0.35 seconds
                    self.playSound(true);
                })
             //playSound(true);
            }
        }
    }
    
    func openLockScreen(){
//        let storyboard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
//
//        let deskVC:LockScreenViewController! = storyboard!.instantiateViewController(withIdentifier: "LockScreenViewController") as! LockScreenViewController
//
//        self.navigationController?.pushViewController(deskVC, animated: false)
        
       //let navgationController = UINavigationController(rootViewController: self);
    //print("self.navigationController=\(self.navigationController)")
       // print(navigationController)
        
        //let vc = LockScreenViewController(nibName: nil, bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LockScreen")  as! LockScreenViewController
        vc.rootViewCtrl = self
        self.navigationController?.show(vc, sender: nil )
    }

    
    func pwdReceived(data: String)
    {
        print("Data received: \(data)")
        if(data == UserDefaults.standard.value(forKey: "pwd") as? String){
            //playSound(false);
            alarmClear();
        }
    }

}

