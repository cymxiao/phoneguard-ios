//
//  SecuredViewController.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/8/27.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

class SecuredViewController: UIViewController {
    
    @IBOutlet weak var securedText: UITextView!
    //UIDevice.current.proximityState = true
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        _ = setTimeout(delay: 3 , block: { () -> Void in
            // do this stuff after timeout seconds
            //UIDevice.current.proximi = true
            print("haha ")
        })
    }
    
    
    // Basic.swift
    func setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
        
    }
}
