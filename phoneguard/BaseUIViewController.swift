//
//  Tool.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/24.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit
import AVFoundation
import SystemConfiguration


class BaseUIViewController: UIViewController {
    var player: AVAudioPlayer?
  
    static var staticPlayer : AVAudioPlayer?
    
    enum OtherScenarioViewName {
        case Stillness
        case Charging
        case Headset
        case Network
    }
    
    func openLockScreen(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LockScreen")  as! LockScreenViewController
        vc.otherViewCtrl = self as! BlackViewController
        self.navigationController?.show(vc, sender: nil )
    }
    
    func openSecuredScreen( prevView : OtherScenarioViewName ){
        
        let sc = self.storyboard?.instantiateViewController(withIdentifier:  "Secured")  as! SecuredViewController
        sc.previousView = prevView
        self.navigationController?.show(sc, sender: nil )
    }
    
    func openBlackScreen( prevView : OtherScenarioViewName){
        
        let bc = self.storyboard?.instantiateViewController(withIdentifier:  "Black")  as! BlackViewController
        bc.previousView = prevView
        self.navigationController?.show(bc, sender: nil )
    }
    
    
    func pwdReceived(data: String)
    {
        //print("Data received: \(data)")
        if(data == UserDefaults.standard.value(forKey: "pwd") as? String){
            //self.playSound = false
            alarmClear()
        }
    }
    
    
    func alarmClear(){
       
        playSound(false)
        //Amin: todo: I guess the playSound(false) would mute the player, that why if put playSoundwithName("unlock") before it, the unlock.mp3 would not be played.
        playSoundwithName("unlock")  
    }
    
    
    func setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
        
    }
    
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
            player.numberOfLoops = 100
            if(bPlay){
                player.play()
            } else {
                player.stop()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    } 
    
    static func playSound(_ bPlay : Bool) {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            staticPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line: */
            //player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            guard let player = staticPlayer else { return }
            
            //player.volume = 1
            player.numberOfLoops = 100
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
    
//    func resetSwitch() {
//        //fatalError("Must Override")
//    }
    
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
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    
    
    
    
}
