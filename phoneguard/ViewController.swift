//
//  ViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/17.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import AVFoundation


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
            player.volume = 0.9
            player.numberOfLoops = 5
            if(bPlay){
            player.play()
            } else {
                player.stop()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
 
    @IBAction func buttonClick(_ sender: Any) {
        if(isSecurityMode == false){
            isSecurityMode = true
            btnAlarm.setTitle("警戒已开启\n\n 点击关闭", for:.normal)
            btnAlarm.setBackgroundImage(UIImage(named: "alarm-set.png"), for: UIControlState.normal)
            addProximityObserve()
        } else {
            isSecurityMode = false
            btnAlarm.setBackgroundImage(UIImage(named: "alarm-clear.png"), for: UIControlState.normal)
            btnAlarm.setTitle("警戒已关闭\n\n 点击开启", for:.normal)
            playSound(false);
            removeProximityObserve();
        }
               openLockScreen()
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
        btnAlarm.setTitle("警戒已关闭\n\n 点击开启", for:.normal)
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
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
        print("self.navigationController=\(self.navigationController)")
        print(navigationController)
        let vc = LockScreenViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(vc, animated: true )
    }


}

