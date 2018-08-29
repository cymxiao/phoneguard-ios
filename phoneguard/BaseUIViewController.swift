//
//  Tool.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/24.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    func openLockScreen(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LockScreen")  as! LockScreenViewController
        //vc.rootViewCtrl = self
        self.navigationController?.show(vc, sender: nil )
    }
    
    func openSecuredScreen(){
        
        let sc = self.storyboard?.instantiateViewController(withIdentifier:  "Secured")  as! SecuredViewController
        self.navigationController?.show(sc, sender: nil )
    }
    
    func openBlackScreen(){
        
        let bc = self.storyboard?.instantiateViewController(withIdentifier:  "Black")  as! BlackViewController
        self.navigationController?.show(bc, sender: nil )
    }
    
}
